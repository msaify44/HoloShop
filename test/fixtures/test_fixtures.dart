import 'package:holo_shop/shared/product/data/models/product_dto.dart';
import 'package:holo_shop/shared/product/domain/entity/product.dart';

class TestFixtures {
  static const ProductDto sampleProductDto1 = ProductDto(
    id: 1,
    name: 'Test Product 1',
    description: 'This is a test product description',
    price: 29.99,
    category: 'electronics',
    image: 'https://example.com/image1.jpg',
  );

  static const ProductDto sampleProductDto2 = ProductDto(
    id: 2,
    name: 'Test Product 2',
    description: 'Another test product description',
    price: 49.99,
    category: 'clothing',
    image: 'https://example.com/image2.jpg',
  );

  static const ProductDto sampleProductDtoWithoutImage = ProductDto(
    id: 3,
    name: 'Test Product 3',
    description: 'Test product without image',
    price: 19.99,
    category: 'books',
    image: null,
  );

  static const Product sampleProduct1 = Product(
    id: 1,
    name: 'Test Product 1',
    description: 'This is a test product description',
    price: 29.99,
    category: 'electronics',
    image: 'https://example.com/image1.jpg',
  );

  static const Product sampleProduct2 = Product(
    id: 2,
    name: 'Test Product 2',
    description: 'Another test product description',
    price: 49.99,
    category: 'clothing',
    image: 'https://example.com/image2.jpg',
  );

  static const Product sampleProductWithoutImage = Product(
    id: 3,
    name: 'Test Product 3',
    description: 'Test product without image',
    price: 19.99,
    category: 'books',
    image: null,
  );

  static List<ProductDto> get sampleProductDtos => [
        sampleProductDto1,
        sampleProductDto2,
        sampleProductDtoWithoutImage,
      ];

  static List<Product> get sampleProducts => [
        sampleProduct1,
        sampleProduct2,
        sampleProductWithoutImage,
      ];
}
