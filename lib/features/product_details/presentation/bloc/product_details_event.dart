import 'package:freezed_annotation/freezed_annotation.dart';

part 'product_details_event.freezed.dart';

@freezed
class ProductDetailsEvent with _$ProductDetailsEvent {
  const factory ProductDetailsEvent.fetchProductDetails(int productId) = _FetchProductDetails;
  
  const factory ProductDetailsEvent.refreshProductDetails() = _RefreshProductDetails;
}
