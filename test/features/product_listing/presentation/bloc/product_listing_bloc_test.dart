import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:holo_shop/features/product_listing/domain/entity/category.dart';
import 'package:holo_shop/features/product_listing/domain/use_cases/fetch_products/fetch_products_use_case.dart';
import 'package:holo_shop/features/product_listing/domain/use_cases/get_categories/get_categories_use_case.dart';
import 'package:holo_shop/features/product_listing/domain/use_cases/filter_products/filter_products_use_case.dart';
import 'package:holo_shop/features/product_listing/presentation/bloc/product_listing_bloc.dart';
import 'package:holo_shop/features/product_listing/presentation/bloc/product_listing_event.dart';
import 'package:holo_shop/features/product_listing/presentation/bloc/product_listing_state.dart';
import 'package:holo_shop/shared/product/domain/entity/product.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../../fixtures/test_fixtures.dart';
import '../../../../mocks/mocks.mocks.dart';

@GenerateMocks([
  FetchProductsUseCase,
  GetCategoriesUseCase,
  FilterProductsUseCase,
])
void main() {
  group('ProductListingBloc', () {
    late ProductListingBloc bloc;
    late MockFetchProductsUseCase mockFetchProductsUseCase;
    late MockGetCategoriesUseCase mockGetCategoriesUseCase;
    late MockFilterProductsUseCase mockFilterProductsUseCase;

    setUp(() {
      mockFetchProductsUseCase = MockFetchProductsUseCase();
      mockGetCategoriesUseCase = MockGetCategoriesUseCase();
      mockFilterProductsUseCase = MockFilterProductsUseCase();
      
      bloc = ProductListingBloc(
        fetchProductsUseCase: mockFetchProductsUseCase,
        getCategoriesUseCase: mockGetCategoriesUseCase,
        filterProductsUseCase: mockFilterProductsUseCase,
      );
    });

    tearDown(() {
      bloc.close();
    });

    group('initial state', () {
      test('should have initial state as loading', () {
        expect(bloc.state, equals(const ProductListingState.loading()));
      });
    });

    group('FetchProducts', () {
      blocTest<ProductListingBloc, ProductListingState>(
        'should emit [loading, loaded] when fetchProducts is successful',
        build: () {
          when(mockFetchProductsUseCase()).thenAnswer((_) async => TestFixtures.sampleProducts);
          when(mockGetCategoriesUseCase(any)).thenReturn([
            const Category(id: '', title: 'All'),
            const Category(id: 'books', title: 'BOOKS'),
            const Category(id: 'clothing', title: 'CLOTHING'),
            const Category(id: 'electronics', title: 'ELECTRONICS'),
          ]);
          return bloc;
        },
        act: (bloc) => bloc.add(const ProductListingEvent.fetchProducts()),
        expect: () => [
          const ProductListingState.loading(),
          ProductListingState.loaded(
            categories: [
              const Category(id: '', title: 'All'),
              const Category(id: 'books', title: 'BOOKS'),
              const Category(id: 'clothing', title: 'CLOTHING'),
              const Category(id: 'electronics', title: 'ELECTRONICS'),
            ],
            allProducts: TestFixtures.sampleProducts,
            filteredProducts: TestFixtures.sampleProducts,
          ),
        ],
        verify: (_) {
          verify(mockFetchProductsUseCase()).called(1);
          verify(mockGetCategoriesUseCase(TestFixtures.sampleProducts)).called(1);
        },
      );

      blocTest<ProductListingBloc, ProductListingState>(
        'should emit [loading, error] when fetchProducts fails',
        build: () {
          when(mockFetchProductsUseCase()).thenThrow(Exception('Network error'));
          return bloc;
        },
        act: (bloc) => bloc.add(const ProductListingEvent.fetchProducts()),
        expect: () => [
          const ProductListingState.loading(),
          const ProductListingState.error(message: 'Exception: Network error'),
        ],
        verify: (_) {
          verify(mockFetchProductsUseCase()).called(1);
          verifyNever(mockGetCategoriesUseCase(any));
        },
      );

      blocTest<ProductListingBloc, ProductListingState>(
        'should emit [loading, empty] with empty products when fetchProducts returns empty list',
        build: () {
          when(mockFetchProductsUseCase()).thenAnswer((_) async => <Product>[]);
          when(mockGetCategoriesUseCase(any)).thenReturn([
            const Category(id: '', title: 'All'),
          ]);
          return bloc;
        },
        act: (bloc) => bloc.add(const ProductListingEvent.fetchProducts()),
        expect: () => [
          const ProductListingState.loading(),
          const ProductListingState.empty(),
        ],
        verify: (_) {
          verify(mockFetchProductsUseCase()).called(1);
          verify(mockGetCategoriesUseCase(<Product>[])).called(1);
        },
      );
    });

    group('RefreshProducts', () {
      blocTest<ProductListingBloc, ProductListingState>(
        'should emit [loading, loaded] when refreshProducts is successful',
        build: () {
          when(mockFetchProductsUseCase()).thenAnswer((_) async => TestFixtures.sampleProducts);
          when(mockGetCategoriesUseCase(any)).thenReturn([
            const Category(id: '', title: 'All'),
            const Category(id: 'books', title: 'BOOKS'),
            const Category(id: 'clothing', title: 'CLOTHING'),
            const Category(id: 'electronics', title: 'ELECTRONICS'),
          ]);
          return bloc;
        },
        act: (bloc) => bloc.add(const ProductListingEvent.refreshProducts()),
        expect: () => [
          const ProductListingState.loading(),
          ProductListingState.loaded(
            categories: [
              const Category(id: '', title: 'All'),
              const Category(id: 'books', title: 'BOOKS'),
              const Category(id: 'clothing', title: 'CLOTHING'),
              const Category(id: 'electronics', title: 'ELECTRONICS'),
            ],
            allProducts: TestFixtures.sampleProducts,
            filteredProducts: TestFixtures.sampleProducts,
          ),
        ],
        verify: (_) {
          verify(mockFetchProductsUseCase()).called(1);
          verify(mockGetCategoriesUseCase(TestFixtures.sampleProducts)).called(1);
        },
      );
    });

    group('CategoryChanged', () {
      blocTest<ProductListingBloc, ProductListingState>(
        'should emit updated state when category is changed',
        build: () {
          when(mockFetchProductsUseCase()).thenAnswer((_) async => TestFixtures.sampleProducts);
          when(mockGetCategoriesUseCase(any)).thenReturn([
            const Category(id: '', title: 'All'),
            const Category(id: 'books', title: 'BOOKS'),
            const Category(id: 'clothing', title: 'CLOTHING'),
            const Category(id: 'electronics', title: 'ELECTRONICS'),
          ]);
          when(mockFilterProductsUseCase.call(
            allProducts: anyNamed('allProducts'),
            selectedCategory: anyNamed('selectedCategory'),
          )).thenReturn([TestFixtures.sampleProduct1]);
          return bloc;
        },
        seed: () => ProductListingState.loaded(
          categories: [
            const Category(id: '', title: 'All'),
            const Category(id: 'books', title: 'BOOKS'),
            const Category(id: 'clothing', title: 'CLOTHING'),
            const Category(id: 'electronics', title: 'ELECTRONICS'),
          ],
          allProducts: TestFixtures.sampleProducts,
          filteredProducts: TestFixtures.sampleProducts,
        ),
        act: (bloc) => bloc.add(const ProductListingEvent.categoryChanged('electronics')),
        expect: () => [
          ProductListingState.loaded(
            categories: [
              const Category(id: '', title: 'All'),
              const Category(id: 'books', title: 'BOOKS'),
              const Category(id: 'clothing', title: 'CLOTHING'),
              const Category(id: 'electronics', title: 'ELECTRONICS'),
            ],
            allProducts: TestFixtures.sampleProducts,
            filteredProducts: [TestFixtures.sampleProduct1],
            selectedCategoryId: 'electronics',
          ),
        ],
        verify: (_) {
          verify(mockFilterProductsUseCase.call(
            allProducts: TestFixtures.sampleProducts,
            selectedCategory: const Category(id: 'electronics', title: 'ELECTRONICS'),
          )).called(1);
        },
      );

      blocTest<ProductListingBloc, ProductListingState>(
        'should emit updated state when category is changed to empty string (All)',
        build: () {
          when(mockFetchProductsUseCase()).thenAnswer((_) async => TestFixtures.sampleProducts);
          when(mockGetCategoriesUseCase(any)).thenReturn([
            const Category(id: '', title: 'All'),
            const Category(id: 'books', title: 'BOOKS'),
            const Category(id: 'clothing', title: 'CLOTHING'),
            const Category(id: 'electronics', title: 'ELECTRONICS'),
          ]);
          when(mockFilterProductsUseCase.call(
            allProducts: anyNamed('allProducts'),
            selectedCategory: anyNamed('selectedCategory'),
          )).thenReturn(TestFixtures.sampleProducts);
          return bloc;
        },
        seed: () => ProductListingState.loaded(
          categories: [
            const Category(id: '', title: 'All'),
            const Category(id: 'books', title: 'BOOKS'),
            const Category(id: 'clothing', title: 'CLOTHING'),
            const Category(id: 'electronics', title: 'ELECTRONICS'),
          ],
          allProducts: TestFixtures.sampleProducts,
          filteredProducts: [TestFixtures.sampleProduct1],
          selectedCategoryId: 'electronics',
        ),
        act: (bloc) => bloc.add(const ProductListingEvent.categoryChanged('')),
        expect: () => [
          ProductListingState.loaded(
            categories: [
              const Category(id: '', title: 'All'),
              const Category(id: 'books', title: 'BOOKS'),
              const Category(id: 'clothing', title: 'CLOTHING'),
              const Category(id: 'electronics', title: 'ELECTRONICS'),
            ],
            allProducts: TestFixtures.sampleProducts,
            filteredProducts: TestFixtures.sampleProducts,
            selectedCategoryId: null,
          ),
        ],
        verify: (_) {
          verify(mockFilterProductsUseCase.call(
            allProducts: TestFixtures.sampleProducts,
            selectedCategory: null,
          )).called(1);
        },
      );
    });
  });
}
