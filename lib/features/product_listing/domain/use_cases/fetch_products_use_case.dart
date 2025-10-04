import 'package:holo_shop/shared/product/domain/entity/product.dart';

abstract class FetchProductsUseCase {
  Future<List<Product>> call();
}