import 'package:equatable/equatable.dart';
import '../../../data/models/product_model.dart';

abstract class CartEvent extends Equatable {
  const CartEvent();

  @override
  List<Object?> get props => [];
}

class LoadCart extends CartEvent {
  final int userId;

  const LoadCart(this.userId);

  @override
  List<Object?> get props => [userId];
}

class AddToCart extends CartEvent {
  final int userId;
  final ProductModel product;
  final int quantity;

  const AddToCart({
    required this.userId,
    required this.product,
    this.quantity = 1,
  });

  @override
  List<Object?> get props => [userId, product, quantity];
}

class RemoveFromCart extends CartEvent {
  final int cartId;

  const RemoveFromCart(this.cartId);

  @override
  List<Object?> get props => [cartId];
}

class UpdateCartItem extends CartEvent {
  final int cartId;
  final int userId;
  final int productId;
  final int quantity;

  const UpdateCartItem({
    required this.cartId,
    required this.userId,
    required this.productId,
    required this.quantity,
  });

  @override
  List<Object?> get props => [cartId, userId, productId, quantity];
}

class ClearCart extends CartEvent {}
