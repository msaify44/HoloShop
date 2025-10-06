import 'package:holo_shop/features/cart/domain/entity/cart.dart';

abstract class CartLocalDatasource {
  /// Save cart data to local storage
  Future<void> saveCart(Cart cart);
  
  /// Load cart data from local storage
  Future<Cart?> loadCart();
  
  /// Clear cart data from local storage
  Future<void> clearCart();
}
