import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:holo_shop/features/product_listing/domain/entity/category.dart';
import 'package:holo_shop/shared/product/domain/entity/product.dart';

part 'product_listing_state.freezed.dart';

@freezed
class ProductListingState with _$ProductListingState {
  const factory ProductListingState.loading() = Loading;
  
  const factory ProductListingState.loaded({
    required List<Category> categories,
    required List<Product> filteredProducts,
    required List<Product> allProducts,
    String? selectedCategoryId,
  }) = Loaded;
  
  const factory ProductListingState.empty() = Empty;
  
  const factory ProductListingState.error({
    required String message,
  }) = Error;
}
