import 'package:holo_shop/features/product_details/domain/use_cases/fetch_product_details/fetch_product_details_use_case.dart';
import 'package:holo_shop/shared/product/domain/entity/product.dart';
import 'package:holo_shop/shared/product/domain/repository/product_repository.dart';

final class FetchProductDetailsUseCaseImpl implements FetchProductDetailsUseCase {
  const FetchProductDetailsUseCaseImpl({
    required ProductRepository repository,
  }) : _repository = repository;

  final ProductRepository _repository;

  @override
  Future<Product> call(int productId) async {
    try {
      return await _repository.fetchProductDetails(productId);
    } catch (e) {
      throw Exception('Failed to fetch product details for ID $productId: $e');
    }
  }
}
