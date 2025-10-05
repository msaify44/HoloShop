import 'package:holo_shop/shared/product/domain/entity/product.dart';

abstract class FetchProductDetailsUseCase {
  Future<Product> call(int productId);
}
