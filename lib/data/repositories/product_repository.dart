import 'package:dio/dio.dart';
import '../datasources/remote/api_service.dart';
import '../models/product_model.dart';

class ProductRepository {
  final ApiService _apiService;

  ProductRepository({ApiService? apiService})
    : _apiService = apiService ?? ApiService();

  Future<List<ProductModel>> getProducts() async {
    try {
      final response = await _apiService.dio.get('/products');
      return (response.data as List)
          .map((json) => ProductModel.fromJson(json))
          .toList();
    } on DioException catch (e) {
      throw Exception(e.message);
    }
  }

  Future<ProductModel> getProductById(int id) async {
    try {
      final response = await _apiService.dio.get('/products/$id');
      return ProductModel.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception(e.message);
    }
  }

  Future<List<String>> getCategories() async {
    try {
      final response = await _apiService.dio.get('/products/categories');
      return (response.data as List).map((e) => e.toString()).toList();
    } on DioException catch (e) {
      throw Exception(e.message);
    }
  }

  Future<List<ProductModel>> getProductsByCategory(String category) async {
    try {
      final response = await _apiService.dio.get(
        '/products/category/$category',
      );
      return (response.data as List)
          .map((json) => ProductModel.fromJson(json))
          .toList();
    } on DioException catch (e) {
      throw Exception(e.message);
    }
  }
}
