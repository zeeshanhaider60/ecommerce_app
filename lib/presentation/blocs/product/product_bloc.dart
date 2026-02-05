import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/repositories/product_repository.dart';
import 'product_event.dart';
import 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final ProductRepository _productRepository;
  List<String> _categories = [];

  ProductBloc({required ProductRepository productRepository})
    : _productRepository = productRepository,
      super(ProductInitial()) {
    on<LoadProducts>(_onLoadProducts);
    on<LoadProductsByCategory>(_onLoadProductsByCategory);
    on<SearchProducts>(_onSearchProducts);
    on<RefreshProducts>(_onRefreshProducts);
  }

  Future<void> _onLoadProducts(
    LoadProducts event,
    Emitter<ProductState> emit,
  ) async {
    emit(ProductLoading());
    try {
      final products = await _productRepository.getProducts();
      _categories = await _productRepository.getCategories();
      emit(ProductLoaded(products: products, categories: _categories));
    } catch (e) {
      emit(ProductError(e.toString()));
    }
  }

  Future<void> _onLoadProductsByCategory(
    LoadProductsByCategory event,
    Emitter<ProductState> emit,
  ) async {
    emit(ProductLoading());
    try {
      final products = await _productRepository.getProductsByCategory(
        event.category,
      );
      emit(
        ProductLoaded(
          products: products,
          categories: _categories,
          selectedCategory: event.category,
        ),
      );
    } catch (e) {
      emit(ProductError(e.toString()));
    }
  }

  Future<void> _onSearchProducts(
    SearchProducts event,
    Emitter<ProductState> emit,
  ) async {
    if (state is ProductLoaded) {
      final currentState = state as ProductLoaded;
      final filtered =
          currentState.products
              .where(
                (p) =>
                    p.title.toLowerCase().contains(event.query.toLowerCase()),
              )
              .toList();
      emit(
        ProductLoaded(
          products: filtered,
          categories: currentState.categories,
          selectedCategory: currentState.selectedCategory,
        ),
      );
    }
  }

  Future<void> _onRefreshProducts(
    RefreshProducts event,
    Emitter<ProductState> emit,
  ) async {
    add(LoadProducts());
  }
}
