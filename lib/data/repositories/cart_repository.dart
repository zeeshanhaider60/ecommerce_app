import 'package:dio/dio.dart';
import '../datasources/remote/api_service.dart';
import '../models/cart_model.dart';
import '../models/product_model.dart';
import 'product_repository.dart';

class CartRepository {
  final ApiService _apiService;
  final ProductRepository _productRepository;

  CartRepository({ApiService? apiService, ProductRepository? productRepository})
    : _apiService = apiService ?? ApiService(),
      _productRepository = productRepository ?? ProductRepository();

  Future<List<CartModel>> getUserCarts(int userId) async {
    try {
      final response = await _apiService.dio.get('/carts/user/$userId');
      List<CartModel> carts =
          (response.data as List)
              .map((json) => CartModel.fromJson(json))
              .toList();

      // cart items with product details
      carts = await _enrichCartWithProductDetails(carts);

      return carts;
    } on DioException catch (e) {
      throw Exception(e.message);
    }
  }

  // Fetches product details and merge with cart items
  Future<List<CartModel>> _enrichCartWithProductDetails(
    List<CartModel> carts,
  ) async {
    List<CartModel> enrichedCarts = [];

    for (var cart in carts) {
      List<CartItemModel> enrichedItems = [];

      for (var item in cart.products) {
        if (item is CartItemModel) {
          // If item already has details then will use them
          if (item.title != null && item.price != null && item.image != null) {
            enrichedItems.add(item);
          } else {
            // Fetches product details using API
            try {
              final product = await _productRepository.getProductById(
                item.productId,
              );
              enrichedItems.add(
                item.copyWith(
                  title: product.title,
                  price: product.price,
                  image: product.image,
                  description: product.description,
                  category: product.category,
                ),
              );
            } catch (e) {
              enrichedItems.add(item);
            }
          }
        }
      }

      enrichedCarts.add(
        CartModel(
          id: cart.id,
          userId: cart.userId,
          date: cart.date,
          products: enrichedItems,
        ),
      );
    }

    return enrichedCarts;
  }

  Future<CartModel> addToCart(
    int userId,
    ProductModel product,
    int quantity,
  ) async {
    try {
      final response = await _apiService.dio.post(
        '/carts',
        data: {
          'userId': userId,
          'date': DateTime.now().toIso8601String(),
          'products': [
            {
              'productId': product.id,
              'quantity': quantity,
              'title': product.title,
              'price': product.price,
              'image': product.image,
              'description': product.description,
              'category': product.category,
            },
          ],
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return CartModel.fromJson(response.data);
      } else {
        throw Exception('Failed to add to cart');
      }
    } on DioException catch (e) {
      throw Exception(e.response?.data?['message'] ?? 'Failed to add to cart');
    }
  }

  Future<void> removeFromCart(int cartId) async {
    try {
      final response = await _apiService.dio.delete('/carts/$cartId');
      if (response.statusCode != 200 && response.statusCode != 204) {
        throw Exception('Failed to remove from cart');
      }
    } on DioException catch (e) {
      throw Exception(e.message);
    }
  }

  Future<CartModel> updateCart(
    int cartId,
    int userId,
    List<CartItemModel> items,
  ) async {
    try {
      final response = await _apiService.dio.put(
        '/carts/$cartId',
        data: {
          'userId': userId,
          'date': DateTime.now().toIso8601String(),
          'products': items.map((e) => e.toJson()).toList(),
        },
      );

      if (response.statusCode == 200) {
        return CartModel.fromJson(response.data);
      } else {
        throw Exception('Failed to update cart');
      }
    } on DioException catch (e) {
      throw Exception(e.message);
    }
  }
}
