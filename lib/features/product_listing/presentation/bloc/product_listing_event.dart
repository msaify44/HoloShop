import 'package:freezed_annotation/freezed_annotation.dart';

part 'product_listing_event.freezed.dart';

@freezed
class ProductListingEvent with _$ProductListingEvent {
  const factory ProductListingEvent.fetchProducts() = _FetchProducts;
  
  const factory ProductListingEvent.refreshProducts() = _RefreshProducts;
  
  const factory ProductListingEvent.categoryChanged(String categoryId) = _CategoryChanged;
}
