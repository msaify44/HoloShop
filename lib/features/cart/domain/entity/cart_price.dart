import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:holo_shop/features/cart/domain/entity/cart_item.dart';

part 'cart_price.freezed.dart';

@freezed
class CartPrice with _$CartPrice {
  const factory CartPrice({
    @Default(0.0) double subtotal,
    @Default(0.0) double tax,
    @Default(0.0) double total,
  }) = _CartPrice;
}
