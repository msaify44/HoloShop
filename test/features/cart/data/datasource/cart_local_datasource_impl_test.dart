import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:holo_shop/features/cart/data/datasource/cart_local_datasource_impl.dart';
import 'package:holo_shop/features/cart/domain/entity/cart.dart';
import 'package:holo_shop/features/cart/domain/entity/cart_item.dart';
import 'package:holo_shop/features/cart/domain/entity/cart_price.dart';
import 'package:holo_shop/shared/product/domain/entity/product.dart';

import '../../../../fixtures/test_fixtures.dart';
import '../../../../mocks/mocks.mocks.dart';

void main() {
  late CartLocalDatasourceImpl cartLocalDatasource;
  late MockSharedPreferences mockSharedPreferences;

  setUp(() {
    mockSharedPreferences = MockSharedPreferences();
    cartLocalDatasource = CartLocalDatasourceImpl();
    
    // Mock SharedPreferences.getInstance() to return our mock
    SharedPreferences.setMockInitialValues({});
  });

  group('CartLocalDatasourceImpl', () {
    group('saveCart', () {
      test('saves cart data to SharedPreferences', () async {
        // Arrange
        final cart = Cart(
          items: [
            CartItem(product: TestFixtures.sampleProduct1, quantity: 2),
            CartItem(product: TestFixtures.sampleProduct2, quantity: 1),
          ],
          price: const CartPrice(
            subtotal: 109.97,
            tax: 8.80,
            total: 118.77,
          ),
        );

        // Act
        await cartLocalDatasource.saveCart(cart);

        // Assert
        final prefs = await SharedPreferences.getInstance();
        final savedData = prefs.getString('cached_cart');
        expect(savedData, isNotNull);
        
        // Verify the saved data contains expected content
        expect(savedData, contains('"id":1')); // sampleProduct1.id
        expect(savedData, contains('"id":2')); // sampleProduct2.id
        expect(savedData, contains('"quantity":2'));
        expect(savedData, contains('"quantity":1'));
        expect(savedData, contains('"subtotal":109.97'));
        expect(savedData, contains('"tax":8.8')); // JSON removes trailing zero
        expect(savedData, contains('"total":118.77'));
      });

      test('handles single item cart correctly', () async {
        // Arrange
        final singleItemCart = Cart(
          items: [CartItem(product: TestFixtures.sampleProduct1, quantity: 1)],
          price: const CartPrice(
            subtotal: 29.99,
            tax: 2.40,
            total: 32.39,
          ),
        );

        // Act
        await cartLocalDatasource.saveCart(singleItemCart);

        // Assert
        final prefs = await SharedPreferences.getInstance();
        final savedData = prefs.getString('cached_cart');
        expect(savedData, isNotNull);
        expect(savedData, contains('"id":1'));
        expect(savedData, contains('"quantity":1'));
        expect(savedData, contains('"subtotal":29.99'));
      });
    });

    group('loadCart', () {

      test('loads cart data correctly from SharedPreferences', () async {
        // Arrange
        final expectedCart = Cart(
          items: [
            CartItem(product: TestFixtures.sampleProduct1, quantity: 2),
            CartItem(product: TestFixtures.sampleProduct2, quantity: 1),
          ],
          price: const CartPrice(
            subtotal: 109.97,
            tax: 8.80,
            total: 118.77,
          ),
        );

        // Save cart first
        await cartLocalDatasource.saveCart(expectedCart);

        // Act
        final result = await cartLocalDatasource.loadCart();

        // Assert
        expect(result, isNotNull);
        expect(result!.items.length, 2);
        expect(result.items[0].product.id, TestFixtures.sampleProduct1.id);
        expect(result.items[0].quantity, 2);
        expect(result.items[1].product.id, TestFixtures.sampleProduct2.id);
        expect(result.items[1].quantity, 1);
        expect(result.price.subtotal, 109.97);
        expect(result.price.tax, 8.80);
        expect(result.price.total, 118.77);
      });

      test('loads empty cart correctly', () async {
        // Arrange
        final emptyCart = Cart(
          items: [],
          price: const CartPrice(
            subtotal: 0.0,
            tax: 0.0,
            total: 0.0,
          ),
        );
        await cartLocalDatasource.saveCart(emptyCart);

        // Act
        final result = await cartLocalDatasource.loadCart();

        // Assert
        expect(result, isNotNull);
        expect(result!.items, isEmpty);
        expect(result.price.subtotal, 0.0);
        expect(result.price.tax, 0.0);
        expect(result.price.total, 0.0);
      });
    });

    group('clearCart', () {
      test('removes cart data from SharedPreferences', () async {
        // Arrange
        final cart = Cart(
          items: [CartItem(product: TestFixtures.sampleProduct1, quantity: 1)],
          price: const CartPrice(
            subtotal: 29.99,
            tax: 2.40,
            total: 32.39,
          ),
        );
        await cartLocalDatasource.saveCart(cart);

        // Verify cart exists
        final prefs = await SharedPreferences.getInstance();
        expect(prefs.getString('cached_cart'), isNotNull);

        // Act
        await cartLocalDatasource.clearCart();

        // Assert
        expect(prefs.getString('cached_cart'), isNull);
      });
    });
  });
}
