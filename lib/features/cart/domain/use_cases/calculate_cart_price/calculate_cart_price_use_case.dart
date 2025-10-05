import 'package:holo_shop/features/cart/domain/entity/cart.dart';
import 'package:holo_shop/features/cart/domain/entity/cart_item.dart';

abstract class CalculateCartPriceUseCase {
  Cart call(List<CartItem> items);
}
