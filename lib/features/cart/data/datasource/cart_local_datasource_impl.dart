import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:holo_shop/features/cart/data/datasource/cart_local_datasource.dart';
import 'package:holo_shop/features/cart/domain/entity/cart.dart';

class CartLocalDatasourceImpl implements CartLocalDatasource {
  static const String _cartKey = 'cached_cart';
  
  @override
  Future<void> saveCart(Cart cart) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cartJson = _cartToJson(cart);
      await prefs.setString(_cartKey, cartJson);
    } catch (e) {
      // Handle error silently or log it
      debugPrint('Error saving cart: $e');
    }
  }
  
  @override
  Future<Cart?> loadCart() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cartJson = prefs.getString(_cartKey);
      
      if (cartJson == null) {
        return null;
      }
      
      return _cartFromJson(cartJson);
    } catch (e) {
      // Handle error silently or log it
      debugPrint('Error loading cart: $e');
      return null;
    }
  }
  
  @override
  Future<void> clearCart() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_cartKey);
    } catch (e) {
      debugPrint('Error clearing cart: $e');
    }
  }
  
  /// Convert Cart to JSON string
  String _cartToJson(Cart cart) {
    return jsonEncode(cart.toJson());
  }
  
  /// Convert JSON string to Cart
  Cart _cartFromJson(String cartJson) {
    final Map<String, dynamic> map = jsonDecode(cartJson);
    return Cart.fromJson(map);
  }
}
