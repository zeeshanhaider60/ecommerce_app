import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../presentation/views/login/login_screen.dart';
import '../presentation/views/home/home_screen.dart';
import '../presentation/views/product/product_detail_screen.dart';
import '../presentation/blocs/cart/cart_bloc.dart';
import '../data/repositories/cart_repository.dart';

class AppRoutes {
  static const String login = '/';
  static const String home = '/home';
  static const String productDetail = '/product-detail';

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case home:
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      case productDetail:
        final productId = settings.arguments as int;
        return MaterialPageRoute(
          builder:
              (_) => BlocProvider(
                create: (context) => CartBloc(cartRepository: CartRepository()),
                child: ProductDetailScreen(productId: productId),
              ),
        );
      default:
        return MaterialPageRoute(
          builder:
              (_) =>
                  const Scaffold(body: Center(child: Text('Route not found'))),
        );
    }
  }
}
