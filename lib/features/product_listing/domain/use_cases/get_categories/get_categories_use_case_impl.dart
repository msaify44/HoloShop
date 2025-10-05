import 'package:holo_shop/features/product_listing/domain/use_cases/get_categories/get_categories_use_case.dart';
import 'package:holo_shop/features/product_listing/domain/entity/category.dart';
import 'package:holo_shop/shared/product/domain/entity/product.dart';

final class GetCategoriesUseCaseImpl implements GetCategoriesUseCase {
  @override
  List<Category> call(List<Product> products) {
    // Extract unique categories from products
    final Set<String> uniqueCategoryNames = products
        .map((product) => product.category)
        .toSet();

    // Convert to Category entities with unique IDs
    final categories =
        uniqueCategoryNames
            .map(
              (categoryName) => Category(
                id: categoryName.toLowerCase().replaceAll(' ', '_'),
                title: categoryName.toUpperCase(),
              ),
            )
            .toList()
          ..sort((a, b) => a.title.compareTo(b.title));

    categories.insert(0, const Category(id: '', title: 'All'));
    return categories;
  }
}
