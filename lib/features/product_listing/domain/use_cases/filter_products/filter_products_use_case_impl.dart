import 'package:holo_shop/features/product_listing/domain/use_cases/filter_products/filter_products_use_case.dart';
import 'package:holo_shop/features/product_listing/domain/entity/category.dart';
import 'package:holo_shop/shared/product/domain/entity/product.dart';

final class FilterProductsUseCaseImpl implements FilterProductsUseCase {
  @override
  List<Product> call({
    required List<Product> allProducts,
    Category? selectedCategory,
  }) {
    // If no category is selected, return all products
    if (selectedCategory == null) {
      return allProducts;
    }

    // Filter products by selected category
    return allProducts
        .where((product) => 
            product.category.toLowerCase().replaceAll(' ', '_') == selectedCategory.id)
        .toList();
  }
}
