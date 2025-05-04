import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiServiceAdmin {
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

  Future<Map<String, dynamic>> registerStan({
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

      return jsonDecode(responseBody);
    } catch (e) {
      print('Exception occurred: $e');
      return {'status': false, 'message': 'Terjadi kesalahan pada server.'};
    }
  }

  Future<bool> updateStan({
    required int id,
    required String namaStan,
    required String namaPemilik,
    required String telp,
    required String username,
  }) async {
    var uri = Uri.parse("$baseUrl/update_stan/$id");

    var request = http.MultipartRequest("POST", uri);

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("access_token");
    request.headers.addAll({
      "Authorization": "Bearer $token",
      'Content-Type': 'application/json',
      'makerID': makerID,
    });

    request.fields['nama_stan'] = namaStan;
    request.fields['nama_pemilik'] = namaPemilik;
    request.fields['telp'] = telp;
    request.fields['username'] = username;
    request.fields['maker_id'] = "68";

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

  Future<List<dynamic>> getStan() async {
    try {
      final token = await _getToken();
      if (token == null) {
        return [];
      }

      final prefs = await SharedPreferences.getInstance();
      final storedMakerId = prefs.getString("makerID") ?? '68';

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
      String makerID = "68";

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

  Future<Map<String, dynamic>> getPemasukan(String bulan) async {
    try {
      final token = await _getToken();
      if (token == null) {
        print("Token tidak ditemukan, harap login kembali.");
        return {};
      }

      final prefs = await SharedPreferences.getInstance();
      final storedMakerId = prefs.getString("maker_id") ?? makerID;

      final response = await http.get(
        Uri.parse('${baseUrl}showpemasukanbybulan/$bulan'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
          'makerID': storedMakerId,
        },
      );

      print("Response showorderbymonth: ${response.body}");

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);

        if (jsonResponse is Map<String, dynamic> &&
            jsonResponse.containsKey("data")) {
          final data = jsonResponse["data"];

          if (data is Map<String, dynamic> &&
              data.containsKey("data_transaksi")) {
            final transaksiList = data["data_transaksi"] as List;

            int totalPemasukan = 0;

            for (var transaksi in transaksiList) {
              final detail = transaksi["detailTrans"] as List;

              for (var item in detail) {
                final hargaBeliRaw = item["harga_beli"];
                final hargaBeli = hargaBeliRaw is int
                    ? hargaBeliRaw
                    : int.tryParse(hargaBeliRaw.toString()) ?? 0;

                totalPemasukan += hargaBeli;
              }
            }

            return {
              "bulan": data["bulan"] ?? "Unknown",
              "total_pemasukan": totalPemasukan,
              "data_transaksi": transaksiList,
            };
          }
        }
      }

      return {};
    } catch (e) {
      print("Error getRekapPemasukanStan: $e");
      return {};
    }
  }

  Future<List<Map<String, dynamic>>> getOrderAdmin(String status) async {
    try {
      final token = await _getToken();
      if (token == null) {
        print("Token tidak ditemukan, harap login kembali.");
        return [];
      }

      final prefs = await SharedPreferences.getInstance();
      final storedMakerId = prefs.getString("maker_id") ?? makerID;

      final response = await http.get(
        Uri.parse('${baseUrl}getorder/$status'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
          'makerID': storedMakerId,
        },
      );

      print("Response getOrder: ${response.body}");

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
      print("Error getOrder: $e");
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> getOrderAdminBelum() async {
    try {
      final token = await _getToken();
      if (token == null) {
        print("Token tidak ditemukan, harap login kembali.");
        return [];
      }

      final prefs = await SharedPreferences.getInstance();
      final storedMakerId = prefs.getString("maker_id") ?? makerID;

      final response = await http.get(
        Uri.parse('${baseUrl}getorder/belum dikonfirm'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
          'makerID': storedMakerId,
        },
      );

      print("Response getOrder: ${response.body}");

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
      print("Error getOrder: $e");
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> getOrderAdminSelesai() async {
    try {
      final token = await _getToken();
      if (token == null) {
        print("Token tidak ditemukan, harap login kembali.");
        return [];
      }

      final prefs = await SharedPreferences.getInstance();
      final storedMakerId = prefs.getString("maker_id") ?? makerID;

      final response = await http.get(
        Uri.parse('${baseUrl}getorder/sampai'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
          'makerID': storedMakerId,
        },
      );

      print("Response getOrder: ${response.body}");

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
      print("Error getOrder: $e");
      return [];
    }
  }

  Future<bool> updateOrderStatus(String idPesanan, String status) async {
    try {
      final token = await _getToken();
      if (token == null) {
        print("Token tidak ditemukan, harap login kembali.");
        return false;
      }

      final prefs = await SharedPreferences.getInstance();
      final storedMakerId = prefs.getString("maker_id") ?? makerID;

      final response = await http.put(
        Uri.parse('${baseUrl}updatestatus/$idPesanan'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
          'makerID': storedMakerId,
        },
        body: jsonEncode({"status": status}),
      );

      print("Response updateOrder: ${response.body}");

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        return jsonResponse["status"] == true;
      }
      return false;
    } catch (e) {
      print("Error updateOrderStatus: $e");
      return false;
    }
  }

  Future<List<Map<String, dynamic>>> rekapOrderBulan(String bulan) async {
    try {
      final token = await _getToken();
      if (token == null) {
        print("Token tidak ditemukan, harap login kembali.");
        return [];
      }

      final prefs = await SharedPreferences.getInstance();
      final storedMakerId = prefs.getString("maker_id") ?? makerID;

      final response = await http.get(
        Uri.parse(
            '${baseUrl}showorderbymonth/$bulan'), // <- di sini pakai format YYYY-MM
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
          'makerID': storedMakerId,
        },
      );

      print("Response showorderbymonth: ${response.body}");

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
      print("Error getRekapPemesananStanByMonth: $e");
      return [];
    }
  }

  Future<List<dynamic>> showDiskon() async {
    try {
      final token = await _getToken();
      final response = await http.post(
        Uri.parse('${baseUrl}showdiskon'),
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

  Future<bool> tambahDiskon({
    required String namaDiskon,
    required int presentase,
    required DateTime tanggalMulai,
    required DateTime tanggalSelesai,
  }) async {
    try {
      String makerID = "68";

      var request = http.MultipartRequest(
        'POST',
        Uri.parse('${baseUrl}tambahdiskon'),
      )
        ..headers.addAll(await _getAuthHeaders())
        ..fields.addAll({
          'nama_diskon': namaDiskon,
          'persentase_diskon': presentase.toString(),
          'tanggal_awal': tanggalMulai.toIso8601String().split('T')[0],
          'tanggal_akhir': tanggalSelesai.toIso8601String().split('T')[0],
          'makerID': makerID,
        });

      var response = await request.send();
      var responseBody = await response.stream.bytesToString();
      print('Tambah Diskon Response: $responseBody');

      return response.statusCode == 200;
    } catch (e) {
      print('Exception occurred: $e');
      return false;
    }
  }
}
