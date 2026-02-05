import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/repositories/cart_repository.dart';
import '../../../data/models/cart_model.dart';
import 'cart_event.dart';
import 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  final CartRepository _cartRepository;

  CartBloc({required CartRepository cartRepository})
    : _cartRepository = cartRepository,
      super(CartInitial()) {
    on<LoadCart>(_onLoadCart);
    on<AddToCart>(_onAddToCart);
    on<RemoveFromCart>(_onRemoveFromCart);
    on<UpdateCartItem>(_onUpdateCartItem);
    on<ClearCart>(_onClearCart);
  }

  Future<void> _onLoadCart(LoadCart event, Emitter<CartState> emit) async {
    emit(CartLoading());
    try {
      final carts = await _cartRepository.getUserCarts(event.userId);
      emit(CartLoaded(carts));
    } catch (e) {
      emit(CartError(e.toString()));
    }
  }

  Future<void> _onAddToCart(AddToCart event, Emitter<CartState> emit) async {
    emit(CartLoading());
    try {
      await _cartRepository.addToCart(
        event.userId,
        event.product,
        event.quantity,
      );

      final carts = await _cartRepository.getUserCarts(event.userId);
      emit(CartLoaded(carts, message: '${event.product.title} added to cart!'));
    } catch (e) {
      emit(CartError('Failed to add to cart: $e'));
    }
  }

  Future<void> _onRemoveFromCart(
    RemoveFromCart event,
    Emitter<CartState> emit,
  ) async {
    emit(CartLoading());
    try {
      await _cartRepository.removeFromCart(event.cartId);

      int userId = 2;
      if (state is CartLoaded) {
        userId =
            (state as CartLoaded).carts.isNotEmpty
                ? (state as CartLoaded).carts.first.userId
                : 2;
      }

      final carts = await _cartRepository.getUserCarts(userId);
      emit(CartLoaded(carts, message: 'Item removed from cart'));
    } catch (e) {
      emit(CartError(e.toString()));
    }
  }

  Future<void> _onUpdateCartItem(
    UpdateCartItem event,
    Emitter<CartState> emit,
  ) async {
    try {
      add(LoadCart(event.userId));
    } catch (e) {
      emit(CartError(e.toString()));
    }
  }

  Future<void> _onClearCart(ClearCart event, Emitter<CartState> emit) async {
    emit(CartInitial());
  }
}
