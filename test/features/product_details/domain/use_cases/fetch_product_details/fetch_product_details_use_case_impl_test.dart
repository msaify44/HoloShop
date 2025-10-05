import 'package:flutter_test/flutter_test.dart';
import 'package:holo_shop/features/product_details/domain/use_cases/fetch_product_details/fetch_product_details_use_case_impl.dart';
import 'package:holo_shop/shared/product/domain/entity/product.dart';
import 'package:holo_shop/shared/product/domain/repository/product_repository.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../../../fixtures/test_fixtures.dart';
import '../../../../../mocks/mocks.mocks.dart';

@GenerateMocks([ProductRepository])
void main() {
  group('FetchProductDetailsUseCaseImpl', () {
    late FetchProductDetailsUseCaseImpl useCase;
    late MockProductRepository mockRepository;

    setUp(() {
      mockRepository = MockProductRepository();
      useCase = FetchProductDetailsUseCaseImpl(
        repository: mockRepository,
      );
    });

    group('call', () {
      test('should return product when repository call is successful', () async {
        // Arrange
        const productId = 1;
        when(mockRepository.fetchProductDetails(productId))
            .thenAnswer((_) async => TestFixtures.sampleProduct1);

        // Act
        final result = await useCase.call(productId);

        // Assert
        expect(result, isA<Product>());
        expect(result.id, equals(1));
        expect(result.title, equals('Test Product 1'));
        expect(result.description, equals('This is a test product description'));
        expect(result.price, equals(29.99));
        expect(result.category, equals('electronics'));
        expect(result.image, equals('https://example.com/image1.jpg'));

        verify(mockRepository.fetchProductDetails(productId)).called(1);
      });

      test('should return product without image when repository returns product without image', () async {
        // Arrange
        const productId = 3;
        when(mockRepository.fetchProductDetails(productId))
            .thenAnswer((_) async => TestFixtures.sampleProductWithoutImage);

        // Act
        final result = await useCase.call(productId);

        // Assert
        expect(result, isA<Product>());
        expect(result.id, equals(3));
        expect(result.title, equals('Test Product 3'));
        expect(result.description, equals('Test product without image'));
        expect(result.price, equals(19.99));
        expect(result.category, equals('books'));
        expect(result.image, isNull);

        verify(mockRepository.fetchProductDetails(productId)).called(1);
      });

      test('should throw exception when repository call fails with network error', () async {
        // Arrange
        const productId = 1;
        when(mockRepository.fetchProductDetails(productId))
            .thenThrow(Exception('Network error'));

        // Act & Assert
        expect(
          () => useCase.call(productId),
          throwsA(isA<Exception>()),
        );

        verify(mockRepository.fetchProductDetails(productId)).called(1);
      });
    });
  });
}
