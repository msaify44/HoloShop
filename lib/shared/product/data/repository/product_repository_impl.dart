import 'package:holo_shop/shared/product/data/datasource/remote/product_remote_datasource.dart';
import 'package:holo_shop/shared/product/domain/entity/product.dart';
import 'package:holo_shop/shared/product/domain/repository/product_repository.dart';

final class ProductRepositoryImpl implements ProductRepository {
  const ProductRepositoryImpl({
    required ProductRemoteDatasource remoteDatasource,
  }) : _remoteDatasource = remoteDatasource;

  final ProductRemoteDatasource _remoteDatasource;

  @override
  Future<List<Product>> fetchProducts() async {
    try {
      final productDtos = await _remoteDatasource.fetchProducts();
      return productDtos.map((dto) => Product.fromDto(dto)).toList();
    } catch (e) {
      throw Exception('Failed to fetch products from repository: $e');
    }
  }

  @override
  Future<Product> fetchProductDetails(int id) async {
    try {
      final productDto = await _remoteDatasource.fetchProductDetails(id);
      return Product.fromDto(productDto);
    } catch (e) {
      throw Exception('Failed to fetch product details with id $id from repository: $e');
    }
  }
}