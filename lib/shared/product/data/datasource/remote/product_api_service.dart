import 'package:dio/dio.dart';
import 'package:holo_shop/shared/product/data/models/product_dto.dart';
import 'package:retrofit/retrofit.dart';

part 'product_api_service.g.dart';

@RestApi(baseUrl: 'https://fakestoreapi.com')
abstract class ProductApiService {
  factory ProductApiService(Dio dio) {
    return _ProductApiService(
      dio,
    );
  }

  @GET('/products')
  Future<List<ProductDto>> fetchProducts();

  @GET('/products/{id}')
  Future<ProductDto> fetchProductDetails(@Path('id') int id);
}