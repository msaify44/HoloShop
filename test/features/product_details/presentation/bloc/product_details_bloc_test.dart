import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'package:holo_shop/features/product_details/domain/use_cases/fetch_product_details/fetch_product_details_use_case.dart';
import 'package:holo_shop/features/product_details/presentation/bloc/product_details_bloc.dart';
import 'package:holo_shop/features/product_details/presentation/bloc/product_details_event.dart';
import 'package:holo_shop/features/product_details/presentation/bloc/product_details_state.dart';
import 'package:holo_shop/shared/product/domain/entity/product.dart';

import '../../../../fixtures/test_fixtures.dart';
import '../../../../mocks/mocks.mocks.dart';

void main() {
  late MockFetchProductDetailsUseCase mockFetchProductDetailsUseCase;
  late ProductDetailsBloc bloc;

  const int productId = 1;
  const Product product = TestFixtures.sampleProduct1;

  setUp(() {
    mockFetchProductDetailsUseCase = MockFetchProductDetailsUseCase();
    bloc = ProductDetailsBloc(
      fetchProductDetailsUseCase: mockFetchProductDetailsUseCase,
    );
  });

  tearDown(() async {
    await bloc.close();
  });

  test('initial state is loading', () {
    expect(bloc.state, const ProductDetailsState.loading());
  });

  blocTest<ProductDetailsBloc, ProductDetailsState>(
    'emits [loading, loaded] when fetchProductDetails succeeds',
    build: () {
      when(mockFetchProductDetailsUseCase.call(productId))
          .thenAnswer((_) async => product);
      return bloc;
    },
    act: (bloc) => bloc.add(const ProductDetailsEvent.fetchProductDetails(productId)),
    expect: () => [
      const ProductDetailsState.loading(),
      const ProductDetailsState.loaded(product: product),
    ],
    verify: (_) {
      verify(mockFetchProductDetailsUseCase.call(productId)).called(1);
    },
  );

  blocTest<ProductDetailsBloc, ProductDetailsState>(
    'emits [loading, error] when fetchProductDetails throws',
    build: () {
      when(mockFetchProductDetailsUseCase.call(productId))
          .thenThrow(Exception('boom'));
      return bloc;
    },
    act: (bloc) => bloc.add(const ProductDetailsEvent.fetchProductDetails(productId)),
    expect: () => [
      const ProductDetailsState.loading(),
      isA<ProductDetailsState>()
          .having((s) => s, 'type', isA<Error>())
          .having((s) => (s as Error).message, 'message', contains('Exception')),
    ],
  );

  blocTest<ProductDetailsBloc, ProductDetailsState>(
    'refresh after successful fetch emits [loading, loaded]',
    build: () {
      when(mockFetchProductDetailsUseCase.call(productId))
          .thenAnswer((_) async => product);
      return bloc;
    },
    act: (bloc) async {
      bloc.add(const ProductDetailsEvent.fetchProductDetails(productId));
      await Future<void>.delayed(const Duration(milliseconds: 10));
      bloc.add(const ProductDetailsEvent.refreshProductDetails());
    },
    expect: () => [
      const ProductDetailsState.loading(),
      const ProductDetailsState.loaded(product: product),
      const ProductDetailsState.loading(),
      const ProductDetailsState.loaded(product: product),
    ],
    verify: (_) {
      verify(mockFetchProductDetailsUseCase.call(productId)).called(2);
    },
  );
}


