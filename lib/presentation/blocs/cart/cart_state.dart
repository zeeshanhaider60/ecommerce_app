import 'package:equatable/equatable.dart';
import '../../../data/models/cart_model.dart';

abstract class CartState extends Equatable {
  const CartState();

  @override
  List<Object?> get props => [];
}

class CartInitial extends CartState {}

class CartLoading extends CartState {}

class CartLoaded extends CartState {
  final List<CartModel> carts;
  final String? message;

  const CartLoaded(this.carts, {this.message});

  @override
  List<Object?> get props => [carts, message];

  // Calculating total price: price * quantity for each item
  double get totalPrice {
    double total = 0;
    for (var cart in carts) {
      for (var item in cart.products) {
        if (item is CartItemModel) {
          total += item.totalPrice;
        }
      }
    }
    return total;
  }

  int get totalItems {
    int count = 0;
    for (var cart in carts) {
      for (var item in cart.products) {
        count += item.quantity;
      }
    }
    return count;
  }
}

class CartError extends CartState {
  final String message;

  const CartError(this.message);

  @override
  List<Object?> get props => [message];
}

class CartOperationSuccess extends CartState {
  final String message;

  const CartOperationSuccess(this.message);

  @override
  List<Object?> get props => [message];
}
