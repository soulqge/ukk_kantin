import 'dart:convert';
import 'dart:ffi';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  final String baseUrl = 'https://ukk-p2.smktelkom-mlg.sch.id/api/';
  final String makerID = '23';

  Future<String?> _getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('access_token');
    print("Token diambil: $token");
    return token;
  }

  Future<void> _saveToken(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('access_token', token);
    print("Token disimpan: $token");
  }

  Future<bool> registerStudent({
    required String namaSiswa,
    required String alamat,
    required String telp,
    required String username,
    required String password,
    File? foto,
  }) async {
    try {
      var request =
          http.MultipartRequest('POST', Uri.parse('${baseUrl}register_siswa'))
            ..headers.addAll(await _getAuthHeaders())
            ..fields.addAll({
              'nama_siswa': namaSiswa,
              'alamat': alamat,
              'telp': telp,
              'username': username,
              'password': password,
            });

      if (foto != null) {
        request.files.add(await http.MultipartFile.fromPath('foto', foto.path));
      }

      var response = await request.send();
      var responseBody = await response.stream.bytesToString();
      print('Register Siswa Response: $responseBody');

      return response.statusCode == 200;
    } catch (e) {
      print('Exception occurred: $e');
      return false;
    }
  }

  Future<bool> updateSiswa({
    required int id,
    required String namaSiswa,
    required String alamat,
    required String telp,
    required String username,
    File? foto,
  }) async {
    // try {
    var uri = Uri.parse("$baseUrl/ubah_siswa/$id");

    var request = http.MultipartRequest("POST", uri);

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("access_token");
    request.headers.addAll({
      "Authorization": "Bearer $token",
      'Content-Type': 'application/json',
      'makerID': makerID,
    });

    request.fields['nama_siswa'] = namaSiswa;
    request.fields['alamat'] = alamat;
    request.fields['telp'] = telp;
    request.fields['username'] = username;
    request.fields['maker_id'] = "23";

    // Tambahkan file gambar jika ada
    if (foto != null) {
      request.files.add(await http.MultipartFile.fromPath('foto', foto.path));
    }

    var response = await request.send();
    var responseBody = await response.stream.bytesToString();
    var jsonResponse = jsonDecode(responseBody);

    if (response.statusCode == 200 && jsonResponse['status'] == true) {
      print("Update sukses: ${jsonResponse['message']}");
      return true;
    } else {
      print("Update gagal: ${jsonResponse['message']}");
      return false;
    }
    // } catch (e) {
    //   print("Error update siswa: $e");
    //   return false;
    // }
  }

  Future<bool> hapusSiswa({required String siswaId}) async {
    try {
      var response = await http.delete(
        Uri.parse('${baseUrl}hapus_siswa/$siswaId'),
        headers: await _getAuthHeaders(),
        body: jsonEncode({'id_user': siswaId}),
      );

      print("Response Hapus User: ${response.body}");

      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print("Error hapusUser: $e");
      return false;
    }
  }

  Future<bool> registerStan({
    required String namaStan,
    required String namaPemilik,
    required String telp,
    required String username,
    required String password,
  }) async {
    try {
      var request =
          http.MultipartRequest('POST', Uri.parse('${baseUrl}register_stan'))
            ..headers.addAll(await _getAuthHeaders())
            ..fields.addAll({
              'nama_stan': namaStan,
              'nama_pemilik': namaPemilik,
              'telp': telp,
              'username': username,
              'password': password,
            });

      var response = await request.send();
      var responseBody = await response.stream.bytesToString();
      print('Register Stand Response: $responseBody');

      return response.statusCode == 200;
    } catch (e) {
      print('Exception occurred: $e');
      return false;
    }
  }

  Future<Map<String, dynamic>> loginSiswa({
    required String username,
    required String password,
  }) async {
    return _login('${baseUrl}login_siswa', username, password, 'siswa');
  }

  Future<Map<String, dynamic>> loginStand({
    required String username,
    required String password,
  }) async {
    var response =
        await _login('${baseUrl}login_stan', username, password, 'admin_stan');

    print("Response API: $response");

    if (response['success']) {
      var user = response['user'];

      if (user != null && user['maker_id'] != null) {
        String makerID = user['maker_id'].toString();

        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('maker_id', makerID);

        print("maker_id berhasil disimpan: $makerID");
      } else {
        print("Warning: maker_id tidak ditemukan dalam response!");
      }
    }

    return response;
  }

  Future<Map<String, dynamic>> _login(
      String url, String username, String password, String roleType) async {
    var headers = {
      'Content-Type': 'application/json',
      'makerID': makerID,
    };

    var body = jsonEncode({'username': username, 'password': password});

    var response =
        await http.post(Uri.parse(url), headers: headers, body: body);
    print("Login Response ($roleType): ${response.body}");

    if (response.statusCode != 200) {
      return {'success': false, 'message': 'Server error'};
    }

    var responseData;
    try {
      responseData = jsonDecode(response.body);
    } catch (e) {
      print("JSON Decode Error: $e");
      return {'success': false, 'message': 'Invalid response format'};
    }

    if (responseData['access_token'] != null) {
      String token = responseData['access_token'];
      String username = responseData['user']['username'];
      String role = responseData['user']['role'];
      String id = responseData['user']['id'].toString();
      String maker_id = responseData['user']['maker_id'].toString();

      await _saveToken(token);

      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('role', role);
      await prefs.setString('username', username);
      await prefs.setString('id', id);
      await prefs.setString('maker_id', maker_id);

      return {
        'success': true,
        'role': role,
        'username': username,
        'token': token,
        'id': id,
        'maker_id': maker_id
      };
    } else {
      return {
        'success': false,
        'message': responseData['message'] ?? 'Login gagal'
      };
    }
  }

  Future<List<Map<String, dynamic>>> getSiswa() async {
    try {
      final token = await _getToken();
      if (token == null) {
        return [];
      }

      final prefs = await SharedPreferences.getInstance();
      final storedMakerId = prefs.getString("makerID") ?? '23';

      final response = await http.post(
        Uri.parse('${baseUrl}get_siswa'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
          'makerID': storedMakerId,
        },
      );

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);

        if (jsonResponse is Map<String, dynamic> &&
            jsonResponse.containsKey("data")) {
          final data = jsonResponse["data"];

          if (data is List) {
            return List<Map<String, dynamic>>.from(data);
          } else if (data is Map<String, dynamic>) {
            return [data];
          }
        }
      }

      return [];
    } catch (e) {
      print("Error getSiswa: $e");
      return [];
    }
  }

  Future<List<dynamic>> getStan() async {
    try {
      final token = await _getToken();
      if (token == null) {
        return [];
      }

      final prefs = await SharedPreferences.getInstance();
      final storedMakerId = prefs.getString("makerID") ?? '23';

      final response = await http.get(
        Uri.parse('${baseUrl}get_stan'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
          'makerID': storedMakerId,
        },
      );

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);

        if (jsonResponse is Map<String, dynamic> &&
            jsonResponse.containsKey("data")) {
          final data = jsonResponse["data"];

          if (data is List) {
            return data;
          } else if (data is Map<String, dynamic>) {
            return [data];
          }
        }
      }

      return [];
    } catch (e) {
      print("Error getStan: $e");
      return [];
    }
  }

  Future<List<dynamic>> getMenuMakanan() async {
    try {
      final token = await _getToken();
      final response = await http.post(
        Uri.parse('${baseUrl}getmenufood'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
          'makerID': makerID,
        },
      );

      print("Response Menu Makanan: ${response.body}");

      if (response.statusCode == 200) {
        var responseData = jsonDecode(response.body);
        return responseData['data'] ?? [];
      } else {
        return [];
      }
    } catch (e) {
      print("Error getMenuMakanan: $e");
      return [];
    }
  }

  Future<List<dynamic>> getMenuMinuman() async {
    try {
      final token = await _getToken();
      final response = await http.post(
        Uri.parse('${baseUrl}getmenudrink'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
          'makerID': makerID,
        },
      );

      print("Response Menu Minuman: ${response.body}");

      if (response.statusCode == 200) {
        var responseData = jsonDecode(response.body);
        return responseData['data'] ?? [];
      } else {
        return [];
      }
    } catch (e) {
      print("Error getMenuMinuman: $e");
      return [];
    }
  }

  Future<List<dynamic>> showMenu() async {
    try {
      final token = await _getToken();
      final response = await http.post(
        Uri.parse('${baseUrl}showmenu'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
          'makerID': makerID,
        },
      );

      print("Response Show Menu: ${response.body}");

      if (response.statusCode == 200) {
        var responseData = jsonDecode(response.body);
        return responseData['data'] ?? [];
      } else {
        return [];
      }
    } catch (e) {
      print("Error Show Menu: $e");
      return [];
    }
  }

  Future<bool> tambahMenu({
    required String namaMakanan,
    required String jenis,
    required String harga,
    required String deskripsi,
    File? foto,
  }) async {
    try {
      String makerID = "23";

      var request =
          http.MultipartRequest('POST', Uri.parse('${baseUrl}tambahmenu'))
            ..headers.addAll(await _getAuthHeaders())
            ..fields.addAll({
              'nama_makanan': namaMakanan,
              'jenis': jenis,
              'harga': harga,
              'deskripsi': deskripsi,
              'makerID': makerID,
            });

      if (foto != null) {
        request.files.add(await http.MultipartFile.fromPath('foto', foto.path));
      }

      var response = await request.send();
      var responseBody = await response.stream.bytesToString();
      print('Tambah Menu Response: $responseBody');

      return response.statusCode == 200;
    } catch (e) {
      print('Exception occurred: $e');
      return false;
    }
  }

  Future<bool> hapusMenu({required String menuId}) async {
    try {
      var response = await http.delete(
        Uri.parse('${baseUrl}hapus_menu/$menuId'),
        headers: await _getAuthHeaders(),
        body: jsonEncode({'id': menuId}),
      );

      print("Response Hapus Menu: ${response.body}");

      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print("Error hapusMenu: $e");
      return false;
    }
  }

  Future<Map<String, String>> _getAuthHeaders() async {
    String? token = await _getToken();
    return {
      'Content-Type': 'application/json',
      'makerID': makerID,
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }
}
