import 'package:holo_shop/features/product_listing/domain/entity/category.dart';
import 'package:holo_shop/shared/product/domain/entity/product.dart';

abstract class GetCategoriesUseCase {
  List<Category> call(List<Product> products);
}