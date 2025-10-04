import 'package:holo_shop/shared/product/domain/entity/product.dart';

abstract class ProductRepository {
  Future<List<Product>> fetchProducts();
  Future<Product> fetchProductDetails(int id);
}