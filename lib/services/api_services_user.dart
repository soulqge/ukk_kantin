import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ukk_kantin/models/pesan_models.dart';

class ApiServicesUser {
  final String baseUrl = 'https://ukk-p2.smktelkom-mlg.sch.id/api/';
  final String makerID = '68';

  //token
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

  Future<Map<String, String>> _getAuthHeaders() async {
    String? token = await _getToken();
    return {
      'Content-Type': 'application/json',
      'makerID': makerID,
      if (token != null) 'Authorization': 'Bearer $token',
    };
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

  Future<Map<String, dynamic>> registerStudent({
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

      return jsonDecode(responseBody);
    } catch (e) {
      print('Exception occurred: $e');
      return {
        'status': false,
        'message': 'Terjadi kesalahan pada koneksi atau server.'
      };
    }
  }

  Future<bool> updateSiswaAdmin({
    required int id,
    required String namaSiswa,
    required String alamat,
    required String telp,
    required String username,
    File? foto,
  }) async {
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
    request.fields['maker_id'] = "68";

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
  }

  Future<bool> updateSiswaUser({
    required int id,
    required String namaSiswa,
    required String alamat,
    required String telp,
    required String username,
    File? foto,
  }) async {
    var uri = Uri.parse("$baseUrl/update_siswa/$id");

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
    request.fields['maker_id'] = "68";

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

  Future<Map<String, dynamic>> loginSiswa({
    required String username,
    required String password,
  }) async {
    return _login('${baseUrl}login_siswa', username, password, 'siswa');
  }

  Future<List<dynamic>> getProfile() async {
    try {
      final token = await _getToken();
      if (token == null) {
        return [];
      }

      final prefs = await SharedPreferences.getInstance();
      final storedMakerId = prefs.getString("makerID") ?? '68';

      final response = await http.get(
        Uri.parse('${baseUrl}get_profile'),
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
      print("Error getProfile: $e");
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> getSiswa() async {
    try {
      final token = await _getToken();
      if (token == null) {
        return [];
      }

      final prefs = await SharedPreferences.getInstance();
      final storedMakerId = prefs.getString("makerID") ?? '68';

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

  Future<List<dynamic>> getAllStan() async {
    try {
      final token = await _getToken();
      final response = await http.post(
        Uri.parse('${baseUrl}get_all_stan'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
          'makerID': makerID,
        },
      );

      print("Response Get All Stan: ${response.body}");

      if (response.statusCode == 200) {
        var responseData = jsonDecode(response.body);
        return responseData['data'] ?? [];
      } else {
        return [];
      }
    } catch (e) {
      print("Error getStan: $e");
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

  Future<List<Map<String, dynamic>>> getOrderSiswa(String status) async {
    try {
      final token = await _getToken();
      if (token == null) {
        print("Token tidak ditemukan, harap login kembali.");
        return [];
      }

      final prefs = await SharedPreferences.getInstance();
      final storedMakerId = prefs.getString("maker_id") ?? makerID;

      final response = await http.get(
        Uri.parse('${baseUrl}showorder/$status'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
          'makerID': storedMakerId,
        },
      );

      print("Response showOrder: ${response.body}");

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);

        if (jsonResponse is Map<String, dynamic> &&
            jsonResponse.containsKey("data")) {
          final data = jsonResponse["data"];

          if (data is List) {
            return data.cast<Map<String, dynamic>>();
          } else if (data is Map<String, dynamic>) {
            return [data];
          }
        }
      }
      return [];
    } catch (e) {
      print("Error showOrder: $e");
      return [];
    }
  }

  Future<List<int>> getAllFoodMenuIds() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("access_token");
    var headers = {
      "Authorization": "Bearer $token",
      'Content-Type': 'application/json',
      "makerID": makerID
    };

    try {
      var responseFood = await http.post(
        Uri.parse("$baseUrl/getmenufood"),
        body: {"search": ""},
        headers: headers,
      );

      var responseDrink = await http.post(
        Uri.parse("$baseUrl/getmenudrink"),
        body: {"search": ""},
        headers: headers,
      );

      if (responseFood.statusCode == 200 && responseDrink.statusCode == 200) {
        List<int> menuIds = [];

        Map<String, dynamic> foodData = jsonDecode(responseFood.body);
        Map<String, dynamic> drinkData = jsonDecode(responseDrink.body);

        for (var item in foodData["data"]) {
          menuIds.add(item["id_menu"]);
        }
        for (var item in drinkData["data"]) {
          menuIds.add(item["id_menu"]);
        }

        return menuIds;
      } else {
        print(
            "Failed to fetch menu. Status: ${responseFood.statusCode}, ${responseDrink.statusCode}");
        return [];
      }
    } catch (e) {
      print("Error fetching menu IDs: $e");
      return [];
    }
  }

  Future<String?> getFoodName(int idMenu) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString("access_token");

      if (token == null) {
        print("Token tidak ditemukan. Harap login kembali.");
        return null;
      }

      var headers = {
        "Authorization": "Bearer $token",
        'Content-Type': 'application/json',
        "makerID": makerID
      };

      print("Fetching food and drink menu..."); // Debugging

      final foodResponse = await http.post(
        Uri.parse('$baseUrl/getmenufood'),
        body: jsonEncode({"search": ""}),
        headers: headers,
      );

      final drinkResponse = await http.post(
        Uri.parse('$baseUrl/getmenudrink'),
        body: jsonEncode({"search": ""}),
        headers: headers,
      );

      if (foodResponse.statusCode == 200) {
        final foodData = jsonDecode(foodResponse.body);
        print("Food Menu Response: ${foodData["data"]}"); // Debugging

        for (var item in foodData["data"]) {
          if (item["id_menu"] == idMenu) {
            print("Ditemukan di makanan: ${item["nama_makanan"]}");
            return item["nama_makanan"];
          }
        }
      } else {
        print(
            "Gagal mendapatkan makanan, status code: ${foodResponse.statusCode}");
      }

      if (drinkResponse.statusCode == 200) {
        final drinkData = jsonDecode(drinkResponse.body);
        print("Drink Menu Response: ${drinkData["data"]}"); // Debugging

        for (var item in drinkData["data"]) {
          if (item["id_menu"] == idMenu) {
            print("Ditemukan di minuman: ${item["nama_makanan"]}");
            return item["nama_makanan"];
          }
        }
      } else {
        print(
            "Gagal mendapatkan minuman, status code: ${drinkResponse.statusCode}");
      }

      return null;
    } catch (e) {
      print("Error getFoodName: $e");
      return null;
    }
  }

  Future<Map<String, dynamic>> pesan() async {
    try {
      final token = await _getToken();
      if (token == null) {
        print("Token tidak ditemukan.");
        return {};
      }

      final response = await http.get(
        Uri.parse('${baseUrl}pesan'),
        headers: {
          "Authorization": "Bearer $token",
          'Content-Type': 'application/json',
          'makerID': makerID,
        },
      );

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        if (jsonResponse is Map<String, dynamic> &&
            jsonResponse.containsKey("data")) {
          return jsonResponse["data"];
        }
      } else {
        print("Gagal mengambil data, status code: ${response.statusCode},");
      }
    } catch (e) {
      print("Error Pesan: $e");
    }
    return {};
  }

  Future<List<dynamic>> getDiskon() async {
    try {
      final token = await _getToken();
      final response = await http.post(
        Uri.parse('${baseUrl}getmenudiskonsiswa'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
          'makerID': makerID,
        },
      );

      print("Response Show Diskon: ${response.body}");

      if (response.statusCode == 200) {
        var responseData = jsonDecode(response.body);
        return responseData['data'] ?? [];
      } else {
        return [];
      }
    } catch (e) {
      print("Error Show Diskon: $e");
      return [];
    }
  }

  //siswa

  Future<bool> pesanMakanan(int idStan, List<Pesanan> pesanan) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('access_token');

      if (token == null) {
        throw Exception('Token tidak ditemukan, harap login kembali.');
      }

      // Bangun parameter pesan[] dalam bentuk array query
      final queryParams = {
        'id_stan': idStan.toString(),
        for (int i = 0; i < pesanan.length; i++) ...{
          'pesan[$i][id_menu]': pesanan[i].idMenu.toString(),
          'pesan[$i][qty]': pesanan[i].qty.toString(),
        }
      };

      final url =
          Uri.parse('${baseUrl}pesan').replace(queryParameters: queryParams);

      final headers = {
        'Authorization': 'Bearer $token',
        'makerID': makerID,
      };

      final response = await http.get(url, headers: headers);

      print('[DEBUG] URL: $url');
      print('[DEBUG] Status Code: ${response.statusCode}');
      print('[DEBUG] Response Body: ${response.body}');

      return response.statusCode == 200;
    } catch (e) {
      print("⚠️ Terjadi kesalahan saat memesan makanan: $e");
      return false;
    }
  }
}
