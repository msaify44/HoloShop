import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:holo_shop/shared/product/domain/entity/product.dart';

part 'cart_event.freezed.dart';

@freezed
class CartEvent with _$CartEvent {
  const factory CartEvent.addToCart(Product product) = _AddToCart;
  const factory CartEvent.decrementItem(int productId) = _DecrementItem;
  const factory CartEvent.removeFromCart(int productId) = _RemoveFromCart;
  const factory CartEvent.clearCart() = _ClearCart;
}


