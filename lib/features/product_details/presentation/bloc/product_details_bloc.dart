import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:holo_shop/features/product_details/domain/use_cases/fetch_product_details/fetch_product_details_use_case.dart';
import 'package:holo_shop/features/product_details/presentation/bloc/product_details_event.dart';
import 'package:holo_shop/features/product_details/presentation/bloc/product_details_state.dart';

class ProductDetailsBloc
    extends Bloc<ProductDetailsEvent, ProductDetailsState> {
  
  ProductDetailsBloc({
    required FetchProductDetailsUseCase fetchProductDetailsUseCase,
  }) : _fetchProductDetailsUseCase = fetchProductDetailsUseCase,
       super(const ProductDetailsState.loading()) {
    on<ProductDetailsEvent>(_onEvent);
  }

  final FetchProductDetailsUseCase _fetchProductDetailsUseCase;
  int? _currentProductId;

  Future<void> _onEvent(
    ProductDetailsEvent event,
    Emitter<ProductDetailsState> emit,
  ) async {
    await event.when(
      fetchProductDetails: (productId) => _fetchProductDetails(productId, emit),
      refreshProductDetails: () => _refreshProductDetails(emit),
    );
  }

  Future<void> _fetchProductDetails(
    int productId,
    Emitter<ProductDetailsState> emit,
  ) async {
    emit(const ProductDetailsState.loading());
    _currentProductId = productId;
    
    try {
      final product = await _fetchProductDetailsUseCase(productId);
      emit(ProductDetailsState.loaded(product: product));
    } catch (e) {
      emit(ProductDetailsState.error(message: e.toString()));
    }
  }

  Future<void> _refreshProductDetails(
    Emitter<ProductDetailsState> emit,
  ) async {
    if (_currentProductId == null) {
      emit(const ProductDetailsState.error(
        message: 'No product ID available for refresh',
      ));
      return;
    }
    
    emit(const ProductDetailsState.loading());
    
    try {
      final product = await _fetchProductDetailsUseCase(_currentProductId!);
      emit(ProductDetailsState.loaded(product: product));
    } catch (e) {
      emit(ProductDetailsState.error(message: e.toString()));
    }
  }
}
