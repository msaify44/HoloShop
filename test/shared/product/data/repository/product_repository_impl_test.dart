import 'package:flutter_test/flutter_test.dart';
import 'package:holo_shop/shared/product/data/datasource/remote/product_remote_datasource.dart';
import 'package:holo_shop/shared/product/data/models/product_dto.dart';
import 'package:holo_shop/shared/product/data/repository/product_repository_impl.dart';
import 'package:holo_shop/shared/product/domain/entity/product.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../../fixtures/test_fixtures.dart';
import '../../../../mocks/mocks.mocks.dart';

@GenerateMocks([ProductRemoteDatasource])
void main() {
  group('ProductRepositoryImpl', () {
    late ProductRepositoryImpl repository;
    late MockProductRemoteDatasource mockRemoteDatasource;

    setUp(() {
      mockRemoteDatasource = MockProductRemoteDatasource();
      repository = ProductRepositoryImpl(
        remoteDatasource: mockRemoteDatasource,
      );
    });

    group('fetchProducts', () {
      test('should return list of products when datasource call is successful', () async {
        // Arrange
        when(mockRemoteDatasource.fetchProducts())
            .thenAnswer((_) async => TestFixtures.sampleProductDtos);

        // Act
        final result = await repository.fetchProducts();

        // Assert
        expect(result, isA<List<Product>>());
        expect(result.length, equals(3));
        expect(result[0].id, equals(1));
        expect(result[0].title, equals('Test Product 1'));
        expect(result[0].price, equals(29.99));
        expect(result[0].category, equals('electronics'));
        expect(result[0].image, equals('https://example.com/image1.jpg'));

        verify(mockRemoteDatasource.fetchProducts()).called(1);
      });

      test('should return empty list when datasource returns empty list', () async {
        // Arrange
        when(mockRemoteDatasource.fetchProducts())
            .thenAnswer((_) async => <ProductDto>[]);

        // Act
        final result = await repository.fetchProducts();

        // Assert
        expect(result, isA<List<Product>>());
        expect(result.length, equals(0));

        verify(mockRemoteDatasource.fetchProducts()).called(1);
      });

      test('should throw exception when datasource call fails', () async {
        // Arrange
        when(mockRemoteDatasource.fetchProducts())
            .thenThrow(Exception('Network error'));

        // Act & Assert
        expect(
          () => repository.fetchProducts(),
          throwsA(isA<Exception>()),
        );

        verify(mockRemoteDatasource.fetchProducts()).called(1);
      });

      test('should handle products without images correctly', () async {
        // Arrange
        when(mockRemoteDatasource.fetchProducts())
            .thenAnswer((_) async => [TestFixtures.sampleProductDtoWithoutImage]);

        // Act
        final result = await repository.fetchProducts();

        // Assert
        expect(result.length, equals(1));
        expect(result[0].image, isNull);
        expect(result[0].title, equals('Test Product 3'));

        verify(mockRemoteDatasource.fetchProducts()).called(1);
      });
    });

    group('fetchProductDetails', () {
      test('should return product when datasource call is successful', () async {
        // Arrange
        const productId = 1;
        when(mockRemoteDatasource.fetchProductDetails(productId))
            .thenAnswer((_) async => TestFixtures.sampleProductDto1);

        // Act
        final result = await repository.fetchProductDetails(productId);

        // Assert
        expect(result, isA<Product>());
        expect(result.id, equals(1));
        expect(result.title, equals('Test Product 1'));
        expect(result.price, equals(29.99));
        expect(result.category, equals('electronics'));
        expect(result.image, equals('https://example.com/image1.jpg'));

        verify(mockRemoteDatasource.fetchProductDetails(productId)).called(1);
      });

      test('should return product without image when datasource returns product without image', () async {
        // Arrange
        const productId = 3;
        when(mockRemoteDatasource.fetchProductDetails(productId))
            .thenAnswer((_) async => TestFixtures.sampleProductDtoWithoutImage);

        // Act
        final result = await repository.fetchProductDetails(productId);

        // Assert
        expect(result, isA<Product>());
        expect(result.id, equals(3));
        expect(result.title, equals('Test Product 3'));
        expect(result.image, isNull);

        verify(mockRemoteDatasource.fetchProductDetails(productId)).called(1);
      });

      test('should throw exception when datasource call fails', () async {
        // Arrange
        const productId = 999;
        when(mockRemoteDatasource.fetchProductDetails(productId))
            .thenThrow(Exception('Product not found'));

        // Act & Assert
        expect(
          () => repository.fetchProductDetails(productId),
          throwsA(isA<Exception>()),
        );

        verify(mockRemoteDatasource.fetchProductDetails(productId)).called(1);
      });

      test('should handle different product IDs correctly', () async {
        // Arrange
        when(mockRemoteDatasource.fetchProductDetails(1))
            .thenAnswer((_) async => TestFixtures.sampleProductDto1);
        when(mockRemoteDatasource.fetchProductDetails(2))
            .thenAnswer((_) async => TestFixtures.sampleProductDto2);

        // Act
        final result1 = await repository.fetchProductDetails(1);
        final result2 = await repository.fetchProductDetails(2);

        // Assert
        expect(result1.id, equals(1));
        expect(result1.title, equals('Test Product 1'));
        expect(result2.id, equals(2));
        expect(result2.title, equals('Test Product 2'));

        verify(mockRemoteDatasource.fetchProductDetails(1)).called(1);
        verify(mockRemoteDatasource.fetchProductDetails(2)).called(1);
      });
    });
  });
}
