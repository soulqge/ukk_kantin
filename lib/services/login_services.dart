import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  final String baseUrl = 'https://ukk-p2.smktelkom-mlg.sch.id/api/';
  final String makerID = '23'; // Jika tidak perlu, bisa dihapus

  Future<String?> _getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('access_token');
  }

  Future<void> _saveToken(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('access_token', token);
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

  Future<bool> registerStand({
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
    return _login('${baseUrl}login_stan', username, password, 'admin_stan');
  }

  Future<Map<String, dynamic>> _login(
      String url, String username, String password, String roleType) async {
    var headers = {
      'Content-Type': 'application/json',
      'makerID': makerID, // Jika tidak perlu, hapus saja
    };

    var body = jsonEncode({'username': username, 'password': password});

    try {
      var response =
          await http.post(Uri.parse(url), headers: headers, body: body);

      print("Login Response ($roleType) Status Code: ${response.statusCode}");
      print("Raw Response: ${response.body}");

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

      if (responseData.containsKey('access_token')) {
        String token = responseData['access_token'];
        String username = responseData['user']['username'];
        String role = responseData['user']['role'];
        String id = responseData['user']['id'].toString();

        await _saveToken(token);

        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('role', role);
        await prefs.setString('username', username);
        await prefs.setString('user_id', id);

        return {
          'success': true,
          'role': role,
          'username': username,
          'token': token
        };
      } else {
        return {
          'success': false,
          'message': responseData['message'] ?? 'Login gagal'
        };
      }
    } catch (e) {
      print('Exception occurred: $e');
      return {'success': false, 'message': 'Terjadi kesalahan'};
    }
  }

  Future<Map<String, String>> _getAuthHeaders() async {
    String? token = await _getToken();
    return {
      'makerID': makerID,
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }
}
