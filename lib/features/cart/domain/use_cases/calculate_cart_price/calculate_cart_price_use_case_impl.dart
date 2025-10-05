import 'package:holo_shop/features/cart/domain/entity/cart_item.dart';
import 'package:holo_shop/features/cart/domain/entity/cart_price.dart';
import 'package:holo_shop/features/cart/domain/use_cases/calculate_cart_price/calculate_cart_price_use_case.dart';

class CalculateCartPriceUseCaseImpl implements CalculateCartPriceUseCase {
  static const double _taxRate = 0.08; // 8% tax

  @override
  CartPrice call(List<CartItem> items) {
    if (items.isEmpty) {
      return const CartPrice();
    }

    final double subtotal = items.fold(
      0.0,
      (sum, item) => sum + (item.product.price * item.quantity),
    );

    final double tax = subtotal * _taxRate;
    final double total = subtotal + tax;

    return CartPrice(
      subtotal: subtotal,
      tax: tax,
      total: total,
    );
  }
}
