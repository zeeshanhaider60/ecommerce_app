import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../services/storage_service.dart';
import '../../blocs/cart/cart_bloc.dart';
import '../../blocs/cart/cart_event.dart';
import '../../blocs/cart/cart_state.dart';
import '../../../data/repositories/cart_repository.dart';
import '../../../data/models/cart_model.dart';
import '../../widgets/loading_widget.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  late final CartBloc _cartBloc;

  @override
  void initState() {
    super.initState();
    final storageService = context.read<StorageService>();
    final userId = storageService.getUserId() ?? 2;

    _cartBloc = CartBloc(cartRepository: CartRepository())
      ..add(LoadCart(userId));
  }

  @override
  void dispose() {
    _cartBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _cartBloc,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('My Cart'),
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () {
                final storageService = context.read<StorageService>();
                final userId = storageService.getUserId() ?? 2;
                _cartBloc.add(LoadCart(userId));
              },
            ),
          ],
        ),
        body: BlocConsumer<CartBloc, CartState>(
          listener: (context, state) {
            if (state is CartLoaded && state.message != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message!),
                  behavior: SnackBarBehavior.floating,
                  backgroundColor: Colors.green,
                ),
              );
            } else if (state is CartError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.red,
                  behavior: SnackBarBehavior.floating,
                ),
              );
            }
          },
          builder: (context, state) {
            if (state is CartLoading) {
              return const LoadingWidget();
            } else if (state is CartError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error_outline, size: 64.w, color: Colors.red),
                    SizedBox(height: 16.h),
                    Text(state.message),
                    SizedBox(height: 16.h),
                    ElevatedButton(
                      onPressed: () {
                        final storageService = context.read<StorageService>();
                        final userId = storageService.getUserId() ?? 2;
                        _cartBloc.add(LoadCart(userId));
                      },
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            } else if (state is CartLoaded) {
              if (state.carts.isEmpty || state.totalItems == 0) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.shopping_cart_outlined,
                        size: 100.w,
                        color: Colors.grey[300],
                      ),
                      SizedBox(height: 24.h),
                      Text(
                        'Your cart is empty',
                        style: TextStyle(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey[600],
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        'Add some products to your cart',
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: Colors.grey[500],
                        ),
                      ),
                    ],
                  ),
                );
              }

              return Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      padding: EdgeInsets.all(16.w),
                      itemCount: state.carts.length,
                      itemBuilder: (context, cartIndex) {
                        final cart = state.carts[cartIndex];
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (cartIndex > 0) SizedBox(height: 16.h),
                            ...cart.products.asMap().entries.map((entry) {
                              final item = entry.value as CartItemModel;
                              return _buildCartItem(cart, item);
                            }).toList(),
                          ],
                        );
                      },
                    ),
                  ),
                  _buildCheckoutSection(state),
                ],
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Widget _buildCartItem(CartModel cart, CartItemModel item) {
    return Card(
      margin: EdgeInsets.only(bottom: 12.h),
      child: Padding(
        padding: EdgeInsets.all(12.w),
        child: Row(
          children: [
            // Product Image
            ClipRRect(
              borderRadius: BorderRadius.circular(8.r),
              child:
                  item.image != null
                      ? CachedNetworkImage(
                        imageUrl: item.image!,
                        width: 80.w,
                        height: 80.w,
                        fit: BoxFit.cover,
                        placeholder:
                            (context, url) => Container(
                              width: 80.w,
                              height: 80.w,
                              color: Colors.grey[200],
                              child: const Center(
                                child: CircularProgressIndicator(),
                              ),
                            ),
                        errorWidget:
                            (context, url, error) => Container(
                              width: 80.w,
                              height: 80.w,
                              color: Colors.grey[200],
                              child: const Icon(Icons.image_not_supported),
                            ),
                      )
                      : Container(
                        width: 80.w,
                        height: 80.w,
                        color: Colors.grey[200],
                        child: const Icon(Icons.shopping_bag),
                      ),
            ),
            SizedBox(width: 16.w),

            // Product Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title ?? 'Product #${item.productId}',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4.h),
                  // Showing item price
                  Text(
                    '\$${(item.price ?? 0).toStringAsFixed(2)} each',
                    style: TextStyle(fontSize: 12.sp, color: Colors.grey[600]),
                  ),
                  SizedBox(height: 8.h),
                  Row(
                    children: [
                      // Quantity
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 12.w,
                          vertical: 4.h,
                        ),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primaryContainer,
                          borderRadius: BorderRadius.circular(20.r),
                        ),
                        child: Text(
                          'Qty: ${item.quantity}',
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ),
                      SizedBox(width: 12.w),
                      // Items total price (price * quantity)
                      Text(
                        '= \$${item.totalPrice.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Remove Button
            IconButton(
              icon: Icon(Icons.delete_outline, color: Colors.red[400]),
              onPressed: () {
                showDialog(
                  context: context,
                  builder:
                      (context) => AlertDialog(
                        title: const Text('Remove Item'),
                        content: Text(
                          'Remove "${item.title ?? 'this item'}" from cart?',
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                              _cartBloc.add(RemoveFromCart(cart.id));
                            },
                            child: Text(
                              'Remove',
                              style: TextStyle(color: Colors.red[400]),
                            ),
                          ),
                        ],
                      ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCheckoutSection(CartLoaded state) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Items (${state.totalItems})',
                  style: TextStyle(fontSize: 14.sp, color: Colors.grey[600]),
                ),
                Text(
                  '\$${state.totalPrice.toStringAsFixed(2)}',
                  style: TextStyle(fontSize: 14.sp, color: Colors.grey[800]),
                ),
              ],
            ),
            SizedBox(height: 8.h),
            const Divider(),
            SizedBox(height: 8.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total Amount',
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  '\$${state.totalPrice.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: 24.sp,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.h),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Checkout functionality coming soon!'),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 16.h),
                ),
                child: const Text('Proceed to Checkout'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
