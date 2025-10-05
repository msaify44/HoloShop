import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:holo_shop/features/cart/domain/entity/cart_item.dart';
import 'package:holo_shop/features/cart/domain/entity/cart_price.dart';

part 'cart.freezed.dart';

@freezed
class Cart with _$Cart {
  const factory Cart({
    @Default(<CartItem>[]) List<CartItem> items,
    required CartPrice price,
  }) = _Cart;

  const Cart._();

  int get totalItems => items.fold(0, (sum, item) => sum + item.quantity);
}
