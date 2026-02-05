import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../config/routes.dart';
import '../../../data/repositories/product_repository.dart';
import '../../blocs/product/product_bloc.dart';
import '../../blocs/product/product_event.dart';
import '../../blocs/product/product_state.dart';
import '../../widgets/product_card.dart';
import '../../widgets/loading_widget.dart';
import '../../widgets/error_widget.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  final TextEditingController _searchController = TextEditingController();
  late final ProductBloc _productBloc;

  @override
  void initState() {
    super.initState();
    _productBloc = ProductBloc(productRepository: ProductRepository())
      ..add(LoadProducts());
  }

  @override
  void dispose() {
    _searchController.dispose();
    _productBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _productBloc,
      child: Column(
        children: [
          // Search Bar
          Padding(
            padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 12.h),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search products...',
                  hintStyle: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 15.sp,
                  ),
                  prefixIcon: Icon(
                    Icons.search_rounded,
                    color: Theme.of(context).colorScheme.primary,
                    size: 22.w,
                  ),
                  suffixIcon:
                      _searchController.text.isNotEmpty
                          ? IconButton(
                            icon: Icon(
                              Icons.clear_rounded,
                              color: Colors.grey[500],
                              size: 20.w,
                            ),
                            onPressed: () {
                              _searchController.clear();
                              _productBloc.add(LoadProducts());
                            },
                          )
                          : null,
                  filled: true,
                  fillColor: Theme.of(context).cardColor,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: Theme.of(context).colorScheme.primary,
                      width: 1.5,
                    ),
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    vertical: 14.h,
                    horizontal: 16.w,
                  ),
                ),
                style: TextStyle(fontSize: 15.sp),
                onChanged: (value) {
                  if (value.isNotEmpty) {
                    _productBloc.add(SearchProducts(value));
                  } else {
                    _productBloc.add(LoadProducts());
                  }
                },
              ),
            ),
          ),

          // Categories
          BlocBuilder<ProductBloc, ProductState>(
            builder: (context, state) {
              if (state is ProductLoaded) {
                return SizedBox(
                  height: 50.h,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    itemCount: state.categories.length + 1,
                    itemBuilder: (context, index) {
                      if (index == 0) {
                        final isSelected = state.selectedCategory == null;
                        return Padding(
                          padding: EdgeInsets.only(right: 8.w),
                          child: FilterChip(
                            selected: isSelected,
                            label: const Text('All'),
                            onSelected: (_) {
                              _productBloc.add(LoadProducts());
                            },
                          ),
                        );
                      }
                      final category = state.categories[index - 1];
                      final isSelected = state.selectedCategory == category;
                      return Padding(
                        padding: EdgeInsets.only(right: 8.w),
                        child: FilterChip(
                          selected: isSelected,
                          label: Text(
                            category.toUpperCase(),
                            style: TextStyle(fontSize: 12.sp),
                          ),
                          onSelected: (_) {
                            _productBloc.add(LoadProductsByCategory(category));
                          },
                        ),
                      );
                    },
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),

          // Product Grid
          Expanded(
            child: BlocBuilder<ProductBloc, ProductState>(
              builder: (context, state) {
                if (state is ProductLoading) {
                  return const LoadingWidget();
                } else if (state is ProductError) {
                  return ErrorWidgetCustom(
                    message: state.message,
                    onRetry: () {
                      _productBloc.add(LoadProducts());
                    },
                  );
                } else if (state is ProductLoaded) {
                  if (state.products.isEmpty) {
                    return const Center(child: Text('No products found'));
                  }
                  return RefreshIndicator(
                    onRefresh: () async {
                      _productBloc.add(RefreshProducts());
                    },
                    child: GridView.builder(
                      padding: EdgeInsets.all(16.w),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.7,
                        crossAxisSpacing: 16.w,
                        mainAxisSpacing: 16.h,
                      ),
                      itemCount: state.products.length,
                      itemBuilder: (context, index) {
                        final product = state.products[index];
                        return ProductCard(
                          product: product,
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              AppRoutes.productDetail,
                              arguments: product.id,
                            );
                          },
                        );
                      },
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }
}
