import 'package:equatable/equatable.dart';

class Cart extends Equatable {
  final int id;
  final int userId;
  final DateTime date;
  final List<CartItem> products;

  const Cart({
    required this.id,
    required this.userId,
    required this.date,
    required this.products,
  });

  double get totalPrice {
    return 0.0;
  }

  @override
  List<Object?> get props => [id, userId, date, products];
}

class CartItem extends Equatable {
  final int productId;
  final int quantity;

  const CartItem({required this.productId, required this.quantity});

  @override
  List<Object?> get props => [productId, quantity];
}
