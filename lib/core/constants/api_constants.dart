class ApiConstants {
  static const String baseUrl = 'https://fakestoreapi.com';

  // Auth
  static const String login = '/auth/login';

  // Products
  static const String products = '/products';
  static String productById(int id) => '/products/$id';
  static const String categories = '/products/categories';
  static String productsByCategory(String category) =>
      '/products/category/$category';

  // Carts
  static String userCart(int userId) => '/carts/user/$userId';

  // Users
  static String userById(int id) => '/users/$id';
}
