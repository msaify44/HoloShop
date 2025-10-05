import 'package:flutter_test/flutter_test.dart';
import 'package:holo_shop/features/cart/domain/entity/cart_item.dart';
import 'package:holo_shop/features/cart/domain/entity/cart_price.dart';
import 'package:holo_shop/features/cart/domain/use_cases/calculate_cart_price/calculate_cart_price_use_case_impl.dart';
import 'package:holo_shop/shared/product/domain/entity/product.dart';

import '../../../../../fixtures/test_fixtures.dart';

void main() {
  late CalculateCartPriceUseCaseImpl useCase;

  setUp(() {
    useCase = CalculateCartPriceUseCaseImpl();
  });

  group('CalculateCartPriceUseCaseImpl', () {

    test('calculates price correctly for single item', () {
      // Arrange
      final items = [
        CartItem(product: TestFixtures.sampleProduct1, quantity: 1),
      ];

      // Act
      final result = useCase.call(items);

      // Assert
      expect(result.subtotal, 29.99);
      expect(result.tax, closeTo(2.3992, 0.01)); // 8% of 29.99
      expect(result.total, closeTo(32.3892, 0.01)); // 29.99 + 2.3992
    });

    test('calculates price correctly for multiple items', () {
      // Arrange
      final items = [
        CartItem(product: TestFixtures.sampleProduct1, quantity: 2), // 29.99 * 2 = 59.98
        CartItem(product: TestFixtures.sampleProduct2, quantity: 1), // 49.99 * 1 = 49.99
      ];

      // Act
      final result = useCase.call(items);

      // Assert
      expect(result.subtotal, closeTo(109.97, 0.01)); // 59.98 + 49.99
      expect(result.tax, closeTo(8.7976, 0.01)); // 8% of 109.97
      expect(result.total, closeTo(118.7676, 0.01)); // 109.97 + 8.7976
    });

    test('calculates price correctly for item with quantity > 1', () {
      // Arrange
      final items = [
        CartItem(product: TestFixtures.sampleProduct1, quantity: 3), // 29.99 * 3 = 89.97
      ];

      // Act
      final result = useCase.call(items);

      // Assert
      expect(result.subtotal, closeTo(89.97, 0.01));
      expect(result.tax, closeTo(7.1976, 0.01)); // 8% of 89.97
      expect(result.total, closeTo(97.1676, 0.01)); // 89.97 + 7.1976
    });

    test('calculates price correctly for mixed quantities', () {
      // Arrange
      final items = [
        CartItem(product: TestFixtures.sampleProduct1, quantity: 2), // 29.99 * 2 = 59.98
        CartItem(product: TestFixtures.sampleProduct2, quantity: 3), // 49.99 * 3 = 149.97
        CartItem(product: TestFixtures.sampleProductWithoutImage, quantity: 1), // 19.99 * 1 = 19.99
      ];

      // Act
      final result = useCase.call(items);

      // Assert
      expect(result.subtotal, closeTo(229.94, 0.01)); // 59.98 + 149.97 + 19.99
      expect(result.tax, closeTo(18.3952, 0.01)); // 8% of 229.94
      expect(result.total, closeTo(248.3352, 0.01)); // 229.94 + 18.3952
    });
  });
}
