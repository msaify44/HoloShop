import 'package:holo_shop/features/product_listing/domain/use_cases/fetch_products_use_case.dart';
import 'package:holo_shop/shared/product/domain/entity/product.dart';
import 'package:holo_shop/shared/product/domain/repository/product_repository.dart';

final class FetchProductsUseCaseImpl implements FetchProductsUseCase {
  const FetchProductsUseCaseImpl({
    required ProductRepository repository,
  }) : _repository = repository;

  final ProductRepository _repository;

  @override
  Future<List<Product>> call() async {
    try {
      return await _repository.fetchProducts();
    } catch (e) {
      throw Exception('Failed to fetch products in use case: $e');
    }
  }
}