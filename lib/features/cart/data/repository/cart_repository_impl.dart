import 'package:holo_shop/features/cart/domain/repository/cart_repository.dart';
import 'package:holo_shop/features/cart/domain/entity/cart.dart';
import 'package:holo_shop/features/cart/data/datasource/cart_local_datasource.dart';

class CartRepositoryImpl implements CartRepository {
  final CartLocalDatasource _cartLocalDatasource;

  CartRepositoryImpl({required CartLocalDatasource cartLocalDatasource})
      : _cartLocalDatasource = cartLocalDatasource;

  @override
  Future<void> saveCart(Cart cart) async {
    await _cartLocalDatasource.saveCart(cart);
  }

  @override
  Future<Cart?> loadCart() async {
    return await _cartLocalDatasource.loadCart();
  }

  @override
  Future<void> clearCart() async {
    await _cartLocalDatasource.clearCart();
  }
}
