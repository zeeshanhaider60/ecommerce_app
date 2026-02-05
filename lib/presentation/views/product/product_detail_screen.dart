import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../data/models/product_model.dart';
import '../../../data/repositories/product_repository.dart';
import '../../../data/repositories/cart_repository.dart';
import '../../../services/storage_service.dart';
import '../../blocs/cart/cart_bloc.dart';
import '../../blocs/cart/cart_event.dart';
import '../../blocs/cart/cart_state.dart';

class ProductDetailScreen extends StatefulWidget {
  final int productId;

  const ProductDetailScreen({super.key, required this.productId});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  late Future<ProductModel> _productFuture;
  bool _isAddingToCart = false;
  late final CartBloc _cartBloc;

  @override
  void initState() {
    super.initState();
    _productFuture = ProductRepository().getProductById(widget.productId);
    _cartBloc = CartBloc(cartRepository: CartRepository());
  }

  @override
  void dispose() {
    _cartBloc.close();
    super.dispose();
  }

  void _addToCart(ProductModel product) async {
    final storageService = context.read<StorageService>();
    final userId = storageService.getUserId() ?? 2;

    setState(() {
      _isAddingToCart = true;
    });

    _cartBloc.add(AddToCart(userId: userId, product: product, quantity: 1));
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _cartBloc,
      child: BlocListener<CartBloc, CartState>(
        listener: (context, state) {
          if (state is CartLoaded && state.message != null) {
            setState(() {
              _isAddingToCart = false;
            });
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message!),
                behavior: SnackBarBehavior.floating,
                backgroundColor: Colors.green,
              ),
            );
          } else if (state is CartError) {
            setState(() {
              _isAddingToCart = false;
            });
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                behavior: SnackBarBehavior.floating,
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: Scaffold(
          body: FutureBuilder<ProductModel>(
            future: _productFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData) {
                return const Center(child: Text('Product not found'));
              }

              final product = snapshot.data!;
              return CustomScrollView(
                slivers: [
                  SliverAppBar(
                    expandedHeight: 400.h,
                    pinned: true,
                    flexibleSpace: FlexibleSpaceBar(
                      background: CachedNetworkImage(
                        imageUrl: product.image,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.all(24.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 12.w,
                              vertical: 6.h,
                            ),
                            decoration: BoxDecoration(
                              color:
                                  Theme.of(
                                    context,
                                  ).colorScheme.primaryContainer,
                              borderRadius: BorderRadius.circular(20.r),
                            ),
                            child: Text(
                              product.category.toUpperCase(),
                              style: TextStyle(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w600,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                          ),
                          SizedBox(height: 16.h),
                          Text(
                            product.title,
                            style: TextStyle(
                              fontSize: 24.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 8.h),
                          Row(
                            children: [
                              Icon(Icons.star, color: Colors.amber, size: 20.w),
                              SizedBox(width: 4.w),
                              Text(
                                '${product.rating.rate} (${product.rating.count} reviews)',
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 16.h),
                          Text(
                            '\$${product.price.toStringAsFixed(2)}',
                            style: TextStyle(
                              fontSize: 28.sp,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                          SizedBox(height: 24.h),
                          Text(
                            'Description',
                            style: TextStyle(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: 8.h),
                          Text(
                            product.description,
                            style: TextStyle(
                              fontSize: 16.sp,
                              color: Colors.grey[600],
                              height: 1.5,
                            ),
                          ),
                          SizedBox(height: 32.h),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              onPressed:
                                  _isAddingToCart
                                      ? null
                                      : () => _addToCart(product),
                              icon:
                                  _isAddingToCart
                                      ? SizedBox(
                                        height: 20.h,
                                        width: 20.w,
                                        child: const CircularProgressIndicator(
                                          strokeWidth: 2,
                                          color: Colors.white,
                                        ),
                                      )
                                      : const Icon(Icons.shopping_cart),
                              label: Text(
                                _isAddingToCart ? 'Adding...' : 'Add to Cart',
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
