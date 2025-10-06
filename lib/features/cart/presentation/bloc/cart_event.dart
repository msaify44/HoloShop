import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:holo_shop/shared/product/domain/entity/product.dart';
import 'package:holo_shop/features/cart/domain/entity/cart.dart';

part 'cart_event.freezed.dart';

@freezed
class CartEvent with _$CartEvent {
  const factory CartEvent.addToCart(Product product) = _AddToCart;
  const factory CartEvent.decrementItem(int productId) = _DecrementItem;
  const factory CartEvent.removeFromCart(int productId) = _RemoveFromCart;
  const factory CartEvent.clearCart() = _ClearCart;
  const factory CartEvent.loadFromCache(Cart cart) = _LoadFromCache;
}


