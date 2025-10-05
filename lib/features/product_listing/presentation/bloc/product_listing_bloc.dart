import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:holo_shop/features/product_listing/domain/use_cases/fetch_products/fetch_products_use_case.dart';
import 'package:holo_shop/features/product_listing/domain/use_cases/get_categories/get_categories_use_case.dart';
import 'package:holo_shop/features/product_listing/domain/use_cases/filter_products/filter_products_use_case.dart';
import 'package:holo_shop/features/product_listing/domain/entity/category.dart';
import 'package:holo_shop/features/product_listing/presentation/bloc/product_listing_event.dart';
import 'package:holo_shop/features/product_listing/presentation/bloc/product_listing_state.dart';

class ProductListingBloc
    extends Bloc<ProductListingEvent, ProductListingState> {
  
  ProductListingBloc({
    required FetchProductsUseCase fetchProductsUseCase,
    required GetCategoriesUseCase getCategoriesUseCase,
    required FilterProductsUseCase filterProductsUseCase,
  }) : _fetchProductsUseCase = fetchProductsUseCase,
       _getCategoriesUseCase = getCategoriesUseCase,
       _filterProductsUseCase = filterProductsUseCase,
       super(const ProductListingState.loading()) {
    on<ProductListingEvent>(_onEvent);
  }

  final FetchProductsUseCase _fetchProductsUseCase;
  final GetCategoriesUseCase _getCategoriesUseCase;
  final FilterProductsUseCase _filterProductsUseCase;

  Future<void> _onEvent(
    ProductListingEvent event,
    Emitter<ProductListingState> emit,
  ) async {
    await event.when(
      fetchProducts: () => _fetchProducts(emit),
      refreshProducts: () => _refreshProducts(emit),
      categoryChanged: (categoryId) => _categoryChanged(categoryId, emit),
    );
  }

  Future<void> _fetchProducts(Emitter<ProductListingState> emit) async {
    emit(const ProductListingState.loading());

    try {
      final products = await _fetchProductsUseCase();
      final categories = _getCategoriesUseCase(products);
      
      if (products.isEmpty) {
        emit(
          ProductListingState.empty(),
        );
      } else {
        emit(
          ProductListingState.loaded(
            categories: categories,
            allProducts: products,
            filteredProducts: products,
          ),
        );
      }
    } catch (e) {
      emit(ProductListingState.error(message: e.toString()));
    }
  }

  Future<void> _refreshProducts(Emitter<ProductListingState> emit) async {
    emit(const ProductListingState.loading());
    try {
      final products = await _fetchProductsUseCase();
      final categories = _getCategoriesUseCase(products);
      
      if (products.isEmpty) {
        emit(ProductListingState.empty(),);
      } else {
        emit(
          ProductListingState.loaded(
            categories: categories,
            allProducts: products,
            filteredProducts: products,
          ),
        );
      }
    } catch (e) {
      emit(ProductListingState.error(message: e.toString()));
    }
  }

  Future<void> _categoryChanged(
    String categoryId,
    Emitter<ProductListingState> emit,
  ) async {
    final currentState = state;
    
    // Handle category change for Loaded state
    if (currentState is Loaded) {
      // Find the selected category from the categories list
      Category? selectedCategory;
      if (categoryId.isNotEmpty) {
        selectedCategory = currentState.categories
            .where((category) => category.id == categoryId)
            .firstOrNull;
      }

      // Use FilterProductsUseCase to filter products
      final filteredProducts = _filterProductsUseCase.call(
        allProducts: currentState.allProducts,
        selectedCategory: selectedCategory,
      );

      emit(
        currentState.copyWith(
          selectedCategoryId: categoryId.isEmpty ? null : categoryId,
          filteredProducts: filteredProducts,
        ),
      );
    }
  }
}
