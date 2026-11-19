import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const String baseUrl =
      'https://muhammad-hasbi52-salink.pws.cs.ui.ac.id';

  static const String tokenKey = 'auth_token';

  // Mengambil token yang tersimpan
  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(tokenKey);
  }

  // Menyimpan token
  Future<void> _saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(tokenKey, token);
  }

  // Menghapus token
  Future<void> _removeToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(tokenKey);
  }

  // Login
  Future<Map<String, dynamic>> login(
    String username,
    String password,
  ) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/v1/auth/login/'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'username': username,
        'password': password,
      }),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      await _saveToken(data['token']);
      return {
        'success': true,
        'data': data,
      };
    }

    return {
      'success': false,
      'data': data,
    };
  }

  // Register
  Future<Map<String, dynamic>> register(
    Map<String, dynamic> userData,
  ) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/v1/auth/register/'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(userData),
    );

    return {
      'success': response.statusCode == 201,
      'data': jsonDecode(response.body),
    };
  }

  // Mengambil profil pengguna
  Future<Map<String, dynamic>> getProfile() async {
    final token = await getToken();

    if (token == null) {
      throw Exception('Token tidak ditemukan. Silakan login kembali.');
    }

    final response = await http.get(
      Uri.parse('$baseUrl/api/v1/auth/profile/'),
      headers: {
        'Authorization': 'Token $token',
      },
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return data;
    }

    throw Exception(data['detail'] ?? 'Gagal mengambil profil.');
  }

  // Logout
  Future<void> logout() async {
    final token = await getToken();

    if (token != null) {
      await http.post(
        Uri.parse('$baseUrl/api/v1/auth/logout/'),
        headers: {
          'Authorization': 'Token $token',
        },
      );
    }

    await _removeToken();
  }
}
