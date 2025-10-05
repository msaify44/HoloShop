import 'package:holo_shop/features/product_listing/domain/entity/category.dart';
import 'package:holo_shop/shared/product/domain/entity/product.dart';

abstract class FilterProductsUseCase {
  List<Product> call({
    required List<Product> allProducts,
    Category? selectedCategory,
  });
}