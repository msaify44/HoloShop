import 'package:freezed_annotation/freezed_annotation.dart';

part 'cart_price.freezed.dart';

@freezed
class CartPrice with _$CartPrice {
  const factory CartPrice({
    @Default(0.0) double subtotal,
    @Default(0.0) double tax,
    @Default(0.0) double total,
  }) = _CartPrice;
}
