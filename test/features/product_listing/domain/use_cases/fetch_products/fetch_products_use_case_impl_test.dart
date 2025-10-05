import 'package:flutter_test/flutter_test.dart';
import 'package:holo_shop/features/product_listing/domain/use_cases/fetch_products/fetch_products_use_case_impl.dart';
import 'package:holo_shop/shared/product/domain/entity/product.dart';
import 'package:holo_shop/shared/product/domain/repository/product_repository.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../../../fixtures/test_fixtures.dart';
import '../../../../../mocks/mocks.mocks.dart';

@GenerateMocks([ProductRepository])
void main() {
  group('FetchProductsUseCaseImpl', () {
    late FetchProductsUseCaseImpl useCase;
    late MockProductRepository mockRepository;

    setUp(() {
      mockRepository = MockProductRepository();
      useCase = FetchProductsUseCaseImpl(
        repository: mockRepository,
      );
    });

    group('call', () {
      test('should return list of products when repository call is successful', () async {
        // Arrange
        when(mockRepository.fetchProducts())
            .thenAnswer((_) async => TestFixtures.sampleProducts);

        // Act
        final result = await useCase.call();

        // Assert
        expect(result, isA<List<Product>>());
        expect(result.length, equals(3));
        expect(result[0].id, equals(1));
        expect(result[0].title, equals('Test Product 1'));
        expect(result[0].price, equals(29.99));
        expect(result[0].category, equals('electronics'));
        expect(result[0].image, equals('https://example.com/image1.jpg'));

        verify(mockRepository.fetchProducts()).called(1);
      });

      test('should return empty list when repository returns empty list', () async {
        // Arrange
        when(mockRepository.fetchProducts())
            .thenAnswer((_) async => <Product>[]);

        // Act
        final result = await useCase.call();

        // Assert
        expect(result, isA<List<Product>>());
        expect(result.length, equals(0));

        verify(mockRepository.fetchProducts()).called(1);
      });

      test('should throw exception when repository call fails', () async {
        // Arrange
        when(mockRepository.fetchProducts())
            .thenThrow(Exception('Repository error'));

        // Act & Assert
        expect(
          () => useCase.call(),
          throwsA(isA<Exception>()),
        );

        verify(mockRepository.fetchProducts()).called(1);
      });



      test('should handle server error exception', () async {
        // Arrange
        when(mockRepository.fetchProducts())
            .thenThrow(Exception('Server error'));

        // Act & Assert
        expect(
          () => useCase.call(),
          throwsA(isA<Exception>()),
        );

        verify(mockRepository.fetchProducts()).called(1);
      });
    });
  });
}
