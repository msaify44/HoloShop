import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:holo_shop/features/product_listing/domain/use_cases/fetch_products/fetch_products_use_case.dart';
import 'package:holo_shop/features/product_listing/domain/use_cases/fetch_products/fetch_products_use_case_impl.dart';
import 'package:holo_shop/features/product_listing/domain/use_cases/get_categories/get_categories_use_case.dart';
import 'package:holo_shop/features/product_listing/domain/use_cases/get_categories/get_categories_use_case_impl.dart';
import 'package:holo_shop/features/product_listing/domain/use_cases/filter_products/filter_products_use_case.dart';
import 'package:holo_shop/features/product_listing/domain/use_cases/filter_products/filter_products_use_case_impl.dart';
import 'package:holo_shop/features/product_listing/presentation/bloc/product_listing_bloc.dart';
import 'package:holo_shop/features/product_details/domain/use_cases/fetch_product_details/fetch_product_details_use_case.dart';
import 'package:holo_shop/features/product_details/domain/use_cases/fetch_product_details/fetch_product_details_use_case_impl.dart';
import 'package:holo_shop/features/product_details/presentation/bloc/product_details_bloc.dart';
import 'package:holo_shop/shared/product/data/datasource/remote/product_api_service.dart';
import 'package:holo_shop/shared/product/data/datasource/remote/product_remote_datasource.dart';
import 'package:holo_shop/shared/product/data/datasource/remote/product_remote_datasource_impl.dart';
import 'package:holo_shop/shared/product/data/repository/product_repository_impl.dart';
import 'package:holo_shop/shared/product/domain/repository/product_repository.dart';

final GetIt getIt = GetIt.instance;

/// Initialize all dependencies for the application
Future<void> initializeDependencies() async {
  // Initialize core dependencies
  await _initializeCore();
  
  // Initialize feature modules
  await _initializeFeatures();
}

/// Initialize core dependencies
Future<void> _initializeCore() async {
  // Register Dio instance
  getIt.registerLazySingleton<Dio>(() => Dio());
  
  // Register API services
  getIt.registerLazySingleton<ProductApiService>(
    () => ProductApiService(getIt<Dio>()),
  );
  
  // Register datasources
  getIt.registerLazySingleton<ProductRemoteDatasource>(
    () => ProductRemoteDatasourceImpl(
      apiService: getIt<ProductApiService>(),
    ),
  );
  
  // Register repositories
  getIt.registerLazySingleton<ProductRepository>(
    () => ProductRepositoryImpl(
      remoteDatasource: getIt<ProductRemoteDatasource>(),
    ),
  );
}

/// Initialize feature module dependencies
Future<void> _initializeFeatures() async {
  // Register use cases
  getIt.registerLazySingleton<FetchProductsUseCase>(
    () => FetchProductsUseCaseImpl(
      repository: getIt<ProductRepository>(),
    ),
  );
  
  getIt.registerLazySingleton<GetCategoriesUseCase>(
    () => GetCategoriesUseCaseImpl(),
  );
  
  getIt.registerLazySingleton<FilterProductsUseCase>(
    () => FilterProductsUseCaseImpl(),
  );
  
  getIt.registerLazySingleton<FetchProductDetailsUseCase>(
    () => FetchProductDetailsUseCaseImpl(
      repository: getIt<ProductRepository>(),
    ),
  );
  
  // Register BLoCs
  getIt.registerFactory<ProductListingBloc>(
    () => ProductListingBloc(
      fetchProductsUseCase: getIt<FetchProductsUseCase>(),
      getCategoriesUseCase: getIt<GetCategoriesUseCase>(),
      filterProductsUseCase: getIt<FilterProductsUseCase>(),
    ),
  );
  
  getIt.registerFactory<ProductDetailsBloc>(
    () => ProductDetailsBloc(
      fetchProductDetailsUseCase: getIt<FetchProductDetailsUseCase>(),
    ),
  );
}
