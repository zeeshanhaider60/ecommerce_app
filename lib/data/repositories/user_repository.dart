import 'package:dio/dio.dart';
import '../datasources/remote/api_service.dart';
import '../models/user_model.dart';

class UserRepository {
  final ApiService _apiService;

  UserRepository({ApiService? apiService})
    : _apiService = apiService ?? ApiService();

  Future<UserModel> getUser(int id) async {
    try {
      final response = await _apiService.dio.get('/users/$id');
      return UserModel.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception(e.message);
    }
  }
}
