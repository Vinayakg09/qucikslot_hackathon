import 'dart:convert';
import 'package:http/http.dart' as http;
import '../res/app_constants.dart';

class ApiClient {
  static final _client = http.Client();

  static Future<dynamic> get(String path, {String? userId}) async {
    final uri = Uri.parse('${AppConstants.baseUrl}$path');
    final headers = <String, String>{};
    if (userId != null) headers['X-User-Id'] = userId;
    final res = await _client.get(uri, headers: headers);
    if (res.statusCode == 200) return jsonDecode(res.body);
    throw Exception('GET $path failed: ${res.statusCode}');
  }

  static Future<dynamic> post(String path, Map<String, dynamic> body,
      {required String userId}) async {
    final uri = Uri.parse('${AppConstants.baseUrl}$path');
    final res = await _client.post(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'X-User-Id': userId,
      },
      body: jsonEncode(body),
    );
    final decoded = jsonDecode(res.body);
    if (res.statusCode == 201) return decoded;
    if (res.statusCode == 409) throw ConflictException(decoded['error']);
    throw Exception(decoded['error'] ?? 'Request failed');
  }

  static Future<void> delete(String path, {required String userId}) async {
    final uri = Uri.parse('${AppConstants.baseUrl}$path');
    final res = await _client.delete(
      uri,
      headers: {'X-User-Id': userId},
    );
    if (res.statusCode != 200) throw Exception('Delete failed');
  }
}

class ConflictException implements Exception {
  final String message;
  ConflictException(this.message);
}