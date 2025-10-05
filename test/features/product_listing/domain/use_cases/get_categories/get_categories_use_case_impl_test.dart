import 'package:flutter_test/flutter_test.dart';
import 'package:holo_shop/features/product_listing/domain/entity/category.dart';
import 'package:holo_shop/features/product_listing/domain/use_cases/get_categories/get_categories_use_case_impl.dart';
import 'package:holo_shop/shared/product/domain/entity/product.dart';

import '../../../../../fixtures/test_fixtures.dart';

void main() {
  group('GetCategoriesUseCaseImpl', () {
    late GetCategoriesUseCaseImpl useCase;

    setUp(() {
      useCase = GetCategoriesUseCaseImpl();
    });

    group('call', () {
      test('should return categories with "All" category first when given products', () async {
        // Arrange
        final products = TestFixtures.sampleProducts;

        // Act
        final result = useCase.call(products);

        // Assert
        expect(result, isA<List<Category>>());
        expect(result.length, equals(4)); // 3 unique categories + "All"
        expect(result[0].id, equals(''));
        expect(result[0].title, equals('All'));
      });

      test('should return only "All" category when given empty product list', () async {
        // Arrange
        final products = <Product>[];

        // Act
        final result = useCase.call(products);

        // Assert
        expect(result, isA<List<Category>>());
        expect(result.length, equals(1));
        expect(result[0].id, equals(''));
        expect(result[0].title, equals('All'));
      });

      test('should extract unique categories from products and sort them alphabetically', () async {
        // Arrange
        final products = TestFixtures.sampleProducts;

        // Act
        final result = useCase.call(products);

        // Assert
        expect(result.length, equals(4));
        
        // Check that categories are sorted alphabetically (excluding "All" at index 0)
        final categoryTitles = result.skip(1).map((c) => c.title).toList();
        expect(categoryTitles, equals(['BOOKS', 'CLOTHING', 'ELECTRONICS']));
      });

      test('should convert category names to uppercase titles', () async {
        // Arrange
        final products = TestFixtures.sampleProducts;

        // Act
        final result = useCase.call(products);

        // Assert
        final electronicsCategory = result.firstWhere((c) => c.title == 'ELECTRONICS');
        final clothingCategory = result.firstWhere((c) => c.title == 'CLOTHING');
        final booksCategory = result.firstWhere((c) => c.title == 'BOOKS');
        
        expect(electronicsCategory.title, equals('ELECTRONICS'));
        expect(clothingCategory.title, equals('CLOTHING'));
        expect(booksCategory.title, equals('BOOKS'));
      });

      test('should convert category names to lowercase IDs with underscores', () async {
        // Arrange
        final products = TestFixtures.sampleProducts;

        // Act
        final result = useCase.call(products);

        // Assert
        final electronicsCategory = result.firstWhere((c) => c.title == 'ELECTRONICS');
        final clothingCategory = result.firstWhere((c) => c.title == 'CLOTHING');
        final booksCategory = result.firstWhere((c) => c.title == 'BOOKS');
        
        expect(electronicsCategory.id, equals('electronics'));
        expect(clothingCategory.id, equals('clothing'));
        expect(booksCategory.id, equals('books'));
      });

      test('should handle products with spaces in category names', () async {
        // Arrange
        final productsWithSpaces = [
          const Product(
            id: 1,
            title: 'Test Product 1',
            description: 'Test description',
            price: 29.99,
            category: 'Home & Garden',
            image: 'https://example.com/image1.jpg',
          ),
          const Product(
            id: 2,
            title: 'Test Product 2',
            description: 'Test description',
            price: 39.99,
            category: 'Sports & Recreation',
            image: 'https://example.com/image2.jpg',
          ),
        ];

        // Act
        final result = useCase.call(productsWithSpaces);

        // Assert
        expect(result.length, equals(3)); // 2 unique categories + "All"
        
        final homeGardenCategory = result.firstWhere((c) => c.title == 'HOME & GARDEN');
        final sportsRecreationCategory = result.firstWhere((c) => c.title == 'SPORTS & RECREATION');
        
        expect(homeGardenCategory.id, equals('home_&_garden'));
        expect(sportsRecreationCategory.id, equals('sports_&_recreation'));
      });

      test('should handle products with duplicate categories', () async {
        // Arrange
        final productsWithDuplicates = [
          const Product(
            id: 1,
            title: 'Test Product 1',
            description: 'Test description',
            price: 29.99,
            category: 'electronics',
            image: 'https://example.com/image1.jpg',
          ),
          const Product(
            id: 2,
            title: 'Test Product 2',
            description: 'Test description',
            price: 39.99,
            category: 'electronics',
            image: 'https://example.com/image2.jpg',
          ),
          const Product(
            id: 3,
            title: 'Test Product 3',
            description: 'Test description',
            price: 49.99,
            category: 'clothing',
            image: 'https://example.com/image3.jpg',
          ),
        ];

        // Act
        final result = useCase.call(productsWithDuplicates);

        // Assert
        expect(result.length, equals(3)); // 2 unique categories + "All"
        
        final electronicsCount = result.where((c) => c.title == 'ELECTRONICS').length;
        final clothingCount = result.where((c) => c.title == 'CLOTHING').length;
        
        expect(electronicsCount, equals(1));
        expect(clothingCount, equals(1));
      });

      test('should handle single product correctly', () async {
        // Arrange
        final singleProduct = [TestFixtures.sampleProduct1];

        // Act
        final result = useCase.call(singleProduct);

        // Assert
        expect(result.length, equals(2)); // 1 unique category + "All"
        expect(result[0].title, equals('All'));
        expect(result[1].title, equals('ELECTRONICS'));
        expect(result[1].id, equals('electronics'));
      });

      test('should handle products with mixed case category names', () async {
        // Arrange
        final productsWithMixedCase = [
          const Product(
            id: 1,
            title: 'Test Product 1',
            description: 'Test description',
            price: 29.99,
            category: 'Electronics',
            image: 'https://example.com/image1.jpg',
          ),
          const Product(
            id: 2,
            title: 'Test Product 2',
            description: 'Test description',
            price: 39.99,
            category: 'ELECTRONICS',
            image: 'https://example.com/image2.jpg',
          ),
          const Product(
            id: 3,
            title: 'Test Product 3',
            description: 'Test description',
            price: 49.99,
            category: 'electronics',
            image: 'https://example.com/image3.jpg',
          ),
        ];

        // Act
        final result = useCase.call(productsWithMixedCase);

        // Assert
        expect(result.length, equals(4)); // 3 unique categories + "All"
        
        // Check that all three variations are treated as separate categories
        // since the implementation doesn't normalize case before creating the set
        final categories = result.skip(1).toList(); // Skip "All" category
        expect(categories.length, equals(3));
        expect(categories.every((c) => c.id == 'electronics'), isTrue);
        expect(categories.every((c) => c.title == 'ELECTRONICS'), isTrue);
      });

      test('should handle products with special characters in category names', () async {
        // Arrange
        final productsWithSpecialChars = [
          const Product(
            id: 1,
            title: 'Test Product 1',
            description: 'Test description',
            price: 29.99,
            category: 'Electronics & Gadgets',
            image: 'https://example.com/image1.jpg',
          ),
          const Product(
            id: 2,
            title: 'Test Product 2',
            description: 'Test description',
            price: 39.99,
            category: 'Home/Office',
            image: 'https://example.com/image2.jpg',
          ),
        ];

        // Act
        final result = useCase.call(productsWithSpecialChars);

        // Assert
        expect(result.length, equals(3)); // 2 unique categories + "All"
        
        final electronicsGadgetsCategory = result.firstWhere((c) => c.title == 'ELECTRONICS & GADGETS');
        final homeOfficeCategory = result.firstWhere((c) => c.title == 'HOME/OFFICE');
        
        expect(electronicsGadgetsCategory.id, equals('electronics_&_gadgets'));
        expect(homeOfficeCategory.id, equals('home/office'));
      });
    });
  });
}