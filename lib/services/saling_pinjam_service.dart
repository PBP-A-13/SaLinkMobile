import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:salink_mobile/models/borrow_item.dart';
import 'package:salink_mobile/services/auth_service.dart';

class SalingPinjamService {
  static const String baseUrl =
      'https://muhammad-hasbi52-salink.pws.cs.ui.ac.id/saling-pinjam';

  final AuthService _authService = AuthService();

  /// Mengambil daftar semua barang pinjaman yang tersedia
  Future<List<BorrowItem>> fetchItems({String query = '', String category = ''}) async {
    final queryParams = <String, String>{};
    if (query.isNotEmpty) queryParams['q'] = query;
    if (category.isNotEmpty) queryParams['category'] = category;

    final uri = Uri.parse('$baseUrl/api/items/').replace(queryParameters: queryParams.isEmpty ? null : queryParams);
    final token = await _authService.getToken();

    final response = await http.get(
      uri,
      headers: {
        'Accept': 'application/json',
        if (token != null) 'Authorization': 'Token $token',
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> body = jsonDecode(utf8.decode(response.bodyBytes));
      final List<dynamic> data = body['data'] ?? [];
      return data.map((json) => BorrowItem.fromJson(json)).toList();
    } else {
      throw Exception('Gagal memuat barang pinjaman: HTTP ${response.statusCode}');
    }
  }

  /// Mengambil detail satu barang
  Future<BorrowItem> fetchItemDetail(String id) async {
    final token = await _authService.getToken();
    final response = await http.get(
      Uri.parse('$baseUrl/api/items/$id/'),
      headers: {
        'Accept': 'application/json',
        if (token != null) 'Authorization': 'Token $token',
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> body = jsonDecode(utf8.decode(response.bodyBytes));
      return BorrowItem.fromJson(body['data']);
    } else {
      throw Exception('Gagal memuat detail barang: HTTP ${response.statusCode}');
    }
  }

  /// Mengajukan pinjaman barang
  Future<Map<String, dynamic>> requestBorrow({
    required String itemId,
    required DateTime startDate,
    required DateTime endDate,
    String notes = '',
  }) async {
    final token = await _authService.getToken();
    final payload = {
      'start_date': "${startDate.year}-${startDate.month.toString().padLeft(2, '0')}-${startDate.day.toString().padLeft(2, '0')}",
      'end_date': "${endDate.year}-${endDate.month.toString().padLeft(2, '0')}-${endDate.day.toString().padLeft(2, '0')}",
      'notes': notes,
    };

    final response = await http.post(
      Uri.parse('$baseUrl/api/items/$itemId/request/'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        if (token != null) 'Authorization': 'Token $token',
      },
      body: jsonEncode(payload),
    );

    final data = jsonDecode(utf8.decode(response.bodyBytes));
    if (response.statusCode == 201) {
      return {'success': true, 'data': data['data'], 'message': data['message']};
    } else {
      return {
        'success': false,
        'message': data['message'] ?? 'Gagal mengajukan pinjaman.',
        'errors': data['errors'],
      };
    }
  }

  /// Mengambil data pinjaman saya (sebagai peminjam, sebagai pemilik, dan barang saya)
  Future<Map<String, dynamic>> fetchMyBorrows() async {
    final token = await _authService.getToken();
    final response = await http.get(
      Uri.parse('$baseUrl/api/my-borrows/'),
      headers: {
        'Accept': 'application/json',
        if (token != null) 'Authorization': 'Token $token',
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> body = jsonDecode(utf8.decode(response.bodyBytes));
      final Map<String, dynamic> data = body['data'] ?? {};

      final asBorrowerList = (data['as_borrower'] as List<dynamic>? ?? [])
          .map((json) => ActiveBorrowSlot.fromJson(json))
          .toList();

      final asOwnerList = (data['as_owner'] as List<dynamic>? ?? [])
          .map((json) => ActiveBorrowSlot.fromJson(json))
          .toList();

      final myItemsList = (data['my_items'] as List<dynamic>? ?? [])
          .map((json) => BorrowItem.fromJson(json))
          .toList();

      return {
        'as_borrower': asBorrowerList,
        'as_owner': asOwnerList,
        'my_items': myItemsList,
        'active_count': data['active_count'] ?? 0,
        'max_active': data['max_active'] ?? 2,
      };
    } else {
      throw Exception('Gagal memuat pinjaman saya: HTTP ${response.statusCode}');
    }
  }

  /// Konfirmasi Serah-Terima Barang di Awal (Two-Way Handover Confirmation)
  Future<Map<String, dynamic>> confirmHandover(String requestId) async {
    final token = await _authService.getToken();
    final response = await http.post(
      Uri.parse('$baseUrl/api/requests/$requestId/confirm-handover/'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        if (token != null) 'Authorization': 'Token $token',
      },
      body: jsonEncode({}),
    );

    final data = jsonDecode(utf8.decode(response.bodyBytes));
    if (response.statusCode == 200) {
      return {'success': true, 'data': data['data'], 'message': data['message']};
    } else {
      return {'success': false, 'message': data['message'] ?? 'Gagal konfirmasi serah-terima.'};
    }
  }

  /// Konfirmasi Pengembalian Barang di Akhir (Two-Way Return Confirmation)
  Future<Map<String, dynamic>> confirmReturn(String requestId) async {
    final token = await _authService.getToken();
    final response = await http.post(
      Uri.parse('$baseUrl/api/requests/$requestId/confirm-return/'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        if (token != null) 'Authorization': 'Token $token',
      },
      body: jsonEncode({}),
    );

    final data = jsonDecode(utf8.decode(response.bodyBytes));
    if (response.statusCode == 200) {
      return {'success': true, 'data': data['data'], 'message': data['message']};
    } else {
      return {'success': false, 'message': data['message'] ?? 'Gagal konfirmasi pengembalian.'};
    }
  }

  /// Batalkan pengajuan pinjaman
  Future<bool> cancelRequest(String requestId) async {
    final token = await _authService.getToken();
    final response = await http.post(
      Uri.parse('$baseUrl/api/requests/$requestId/cancel/'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        if (token != null) 'Authorization': 'Token $token',
      },
      body: jsonEncode({}),
    );

    return response.statusCode == 200;
  }
}
