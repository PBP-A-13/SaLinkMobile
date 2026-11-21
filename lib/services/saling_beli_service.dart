import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:salink_mobile/models/item_listing.dart';
import 'package:salink_mobile/services/auth_service.dart';

class SalingBeliService {
  static const String baseUrl =
      'https://muhammad-hasbi52-salink.pws.cs.ui.ac.id/saling-beli';

  final AuthService _authService = AuthService();

  /// Mengambil daftar semua barang aktif dari API Saling Beli
  Future<List<ItemListing>> fetchListings() async {
    final response = await http.get(
      Uri.parse('$baseUrl/json/'),
      headers: {
        'Accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(utf8.decode(response.bodyBytes));
      return data.map((json) => ItemListing.fromJson(json)).toList();
    } else {
      throw Exception('Gagal memuat barang: HTTP ${response.statusCode}');
    }
  }

  /// Mengambil detail satu barang
  Future<ItemListing> fetchListingDetail(String id) async {
    final response = await http.get(
      Uri.parse('$baseUrl/$id/'),
      headers: {
        'Accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data =
          jsonDecode(utf8.decode(response.bodyBytes));
      return ItemListing.fromJson(data);
    } else {
      throw Exception('Gagal memuat detail barang: HTTP ${response.statusCode}');
    }
  }

  /// Menambah barang jualan / hibah baru
  Future<Map<String, dynamic>> createListing(Map<String, dynamic> payload) async {
    final token = await _authService.getToken();

    final response = await http.post(
      Uri.parse('$baseUrl/create/'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        if (token != null) 'Authorization': 'Token $token',
      },
      body: jsonEncode(payload),
    );

    final data = jsonDecode(utf8.decode(response.bodyBytes));
    if (response.statusCode == 201) {
      return {'success': true, 'data': data};
    } else {
      return {
        'success': false,
        'message': data['error'] ?? data['errors']?.toString() ?? 'Gagal membuat barang.',
      };
    }
  }

  /// Mengedit data barang
  Future<Map<String, dynamic>> updateListing(
    String id,
    Map<String, dynamic> payload,
  ) async {
    final token = await _authService.getToken();

    final response = await http.patch(
      Uri.parse('$baseUrl/$id/update/'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        if (token != null) 'Authorization': 'Token $token',
      },
      body: jsonEncode(payload),
    );

    final data = jsonDecode(utf8.decode(response.bodyBytes));
    if (response.statusCode == 200) {
      return {'success': true, 'data': data};
    } else {
      return {
        'success': false,
        'message': data['error'] ?? data['errors']?.toString() ?? 'Gagal mengedit barang.',
      };
    }
  }

  /// Menghapus barang
  Future<bool> deleteListing(String id) async {
    final token = await _authService.getToken();

    final response = await http.delete(
      Uri.parse('$baseUrl/$id/delete/'),
      headers: {
        'Accept': 'application/json',
        if (token != null) 'Authorization': 'Token $token',
      },
    );

    return response.statusCode == 204;
  }
}
