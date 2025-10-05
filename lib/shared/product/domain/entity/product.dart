import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:holo_shop/shared/product/data/models/product_dto.dart';

part 'product.freezed.dart';

@freezed
class Product with _$Product {
  const Product._();

  const factory Product({
    required int id,
    required String title,
    required String description,
    required double price,
    required String category,
    String? image,
  }) = _Product;

  /// Creates a Product from a ProductDto
  factory Product.fromDto(ProductDto dto) {
    return Product(
      id: dto.id,
      title: dto.title,
      description: dto.description,
      price: dto.price,
      category: dto.category,
      image: dto.image,
    );
  }
}