import 'package:dio/dio.dart';
import '../datasources/remote/api_service.dart';
import '../models/login_response.dart';
import '../../services/storage_service.dart';

class AuthRepository {
  final ApiService _apiService;
  final StorageService _storageService;

  AuthRepository({
    ApiService? apiService,
    required StorageService storageService,
  }) : _apiService = apiService ?? ApiService(),
       _storageService = storageService;

  Future<String> login(String username, String password) async {
    try {
      final response = await _apiService.dio.post(
        '/auth/login',
        data: {'username': username, 'password': password},
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (response.data is Map<String, dynamic>) {
          final loginResponse = LoginResponse.fromJson(response.data);
          await _storageService.saveToken(loginResponse.token);
          _apiService.setAuthToken(loginResponse.token);
          return loginResponse.token;
        } else {
          throw Exception('Invalid response format');
        }
      } else {
        throw Exception('Login failed with status: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception(e.response?.data?['message'] ?? 'Network error occurred');
    } catch (e) {
      throw Exception('Login failed: $e');
    }
  }

  Future<void> logout() async {
    await _storageService.deleteToken();
    await _storageService.deleteUserId();
    _apiService.clearAuthToken();
  }

  Future<bool> isLoggedIn() async {
    final token = await _storageService.getToken();
    if (token != null && token.isNotEmpty) {
      _apiService.setAuthToken(token);
      return true;
    }
    return false;
  }

  Future<String?> getToken() async {
    return await _storageService.getToken();
  }
}
