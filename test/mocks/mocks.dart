import 'package:holo_shop/features/product_listing/domain/use_cases/fetch_products/fetch_products_use_case.dart';
import 'package:holo_shop/features/product_details/domain/use_cases/fetch_product_details/fetch_product_details_use_case.dart';
import 'package:holo_shop/features/product_listing/domain/use_cases/get_categories/get_categories_use_case.dart';
import 'package:holo_shop/features/product_listing/domain/use_cases/filter_products/filter_products_use_case.dart';
import 'package:holo_shop/shared/product/data/datasource/remote/product_remote_datasource.dart';
import 'package:holo_shop/shared/product/domain/repository/product_repository.dart';
import 'package:mockito/annotations.dart';

// Generate mocks for testing
@GenerateMocks([
  ProductRemoteDatasource,
  ProductRepository,
  FetchProductsUseCase,
  FetchProductDetailsUseCase,
  GetCategoriesUseCase,
  FilterProductsUseCase,
])
void main() {}
