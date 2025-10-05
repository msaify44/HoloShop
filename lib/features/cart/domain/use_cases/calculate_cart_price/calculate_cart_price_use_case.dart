import 'package:holo_shop/features/cart/domain/entity/cart_item.dart';
import 'package:holo_shop/features/cart/domain/entity/cart_price.dart';

abstract class CalculateCartPriceUseCase {
  CartPrice call(List<CartItem> items);
}
