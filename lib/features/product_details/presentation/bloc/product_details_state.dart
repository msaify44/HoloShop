import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:holo_shop/shared/product/domain/entity/product.dart';

part 'product_details_state.freezed.dart';

@freezed
class ProductDetailsState with _$ProductDetailsState {
  const factory ProductDetailsState.loading() = Loading;
  
  const factory ProductDetailsState.loaded({
    required Product product,
  }) = Loaded;
  
  const factory ProductDetailsState.error({
    required String message,
  }) = Error;
}
