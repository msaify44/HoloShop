import 'package:holo_shop/shared/product/data/models/product_dto.dart';

abstract class ProductRemoteDatasource {
  Future<List<ProductDto>> fetchProducts();
  Future<ProductDto> fetchProductDetails(int id);
}