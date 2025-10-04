import 'package:holo_shop/shared/product/data/datasource/remote/product_api_service.dart';
import 'package:holo_shop/shared/product/data/datasource/remote/product_remote_datasource.dart';
import 'package:holo_shop/shared/product/data/models/product_dto.dart';

final class ProductRemoteDatasourceImpl implements ProductRemoteDatasource {
  const ProductRemoteDatasourceImpl({
    required ProductApiService apiService,
  }) : _apiService = apiService;

  final ProductApiService _apiService;

  @override
  Future<List<ProductDto>> fetchProducts() async {
    try {
      return await _apiService.fetchProducts();
    } catch (e) {
      throw Exception('Failed to fetch products: $e');
    }
  }

  @override
  Future<ProductDto> fetchProductDetails(int id) async {
    try {
      return await _apiService.fetchProductDetails(id);
    } catch (e) {
      throw Exception('Failed to fetch product details with id $id: $e');
    }
  }
}