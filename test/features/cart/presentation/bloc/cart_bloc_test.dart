import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'package:holo_shop/features/cart/domain/entity/cart.dart';
import 'package:holo_shop/features/cart/domain/entity/cart_item.dart';
import 'package:holo_shop/features/cart/presentation/bloc/cart_bloc.dart';
import 'package:holo_shop/features/cart/presentation/bloc/cart_event.dart';
import 'package:holo_shop/features/cart/presentation/bloc/cart_state.dart';
import 'package:holo_shop/shared/product/domain/entity/product.dart';

import '../../../../fixtures/test_fixtures.dart';
import '../../../../mocks/mocks.mocks.dart';

void main() {
  late CartBloc bloc;
  late MockCalculateCartPriceUseCase mockCalculateCartPriceUseCase;

  const Product product1 = TestFixtures.sampleProduct1;
  const Product product2 = TestFixtures.sampleProduct2;

  setUp(() {
    mockCalculateCartPriceUseCase = MockCalculateCartPriceUseCase();
    bloc = CartBloc(calculateCartPriceUseCase: mockCalculateCartPriceUseCase);
  });

  tearDown(() async {
    await bloc.close();
  });

  test('initial state is empty', () {
    expect(bloc.state, const CartState.empty());
  });

  group('AddToCart', () {
    blocTest<CartBloc, CartState>(
      'emits loaded with single item when adding first product',
      build: () {
        when(mockCalculateCartPriceUseCase.call(any)).thenReturn(
          const Cart(
            items: [CartItem(product: product1, quantity: 1)],
            subtotal: 29.99,
            tax: 2.40,
            total: 32.39,
          ),
        );
        return bloc;
      },
      act: (bloc) => bloc.add(CartEvent.addToCart(product1)),
      expect: () => [
        const CartState.loaded(
          cart: Cart(
            items: [CartItem(product: product1, quantity: 1)],
            subtotal: 29.99,
            tax: 2.40,
            total: 32.39,
          ),
        ),
      ],
      verify: (_) {
        verify(mockCalculateCartPriceUseCase.call(any)).called(1);
      },
    );

    blocTest<CartBloc, CartState>(
      'increments quantity when adding same product again',
      build: () {
        when(mockCalculateCartPriceUseCase.call(any)).thenReturn(
          const Cart(
            items: [CartItem(product: product1, quantity: 2)],
            subtotal: 59.98,
            tax: 4.80,
            total: 64.78,
          ),
        );
        return bloc;
      },
      act: (bloc) {
        bloc.add(CartEvent.addToCart(product1));
        bloc.add(CartEvent.addToCart(product1));
      },
      expect: () => [
        const CartState.loaded(
          cart: Cart(
            items: [CartItem(product: product1, quantity: 2)],
            subtotal: 59.98,
            tax: 4.80,
            total: 64.78,
          ),
        ),
        const CartState.loaded(
          cart: Cart(
            items: [CartItem(product: product1, quantity: 2)],
            subtotal: 59.98,
            tax: 4.80,
            total: 64.78,
          ),
        ),
      ],
      verify: (_) {
        verify(mockCalculateCartPriceUseCase.call(any)).called(2);
      },
    );

    blocTest<CartBloc, CartState>(
      'adds different product to existing cart',
      build: () {
        when(mockCalculateCartPriceUseCase.call(any)).thenReturn(
          const Cart(
            items: [
              CartItem(product: product1, quantity: 1),
              CartItem(product: product2, quantity: 1),
            ],
            subtotal: 79.98,
            tax: 6.40,
            total: 86.38,
          ),
        );
        return bloc;
      },
      act: (bloc) {
        bloc.add(CartEvent.addToCart(product1));
        bloc.add(CartEvent.addToCart(product2));
      },
      expect: () => [
        const CartState.loaded(
          cart: Cart(
            items: [
              CartItem(product: product1, quantity: 1),
              CartItem(product: product2, quantity: 1),
            ],
            subtotal: 79.98,
            tax: 6.40,
            total: 86.38,
          ),
        ),
        const CartState.loaded(
          cart: Cart(
            items: [
              CartItem(product: product1, quantity: 1),
              CartItem(product: product2, quantity: 1),
            ],
            subtotal: 79.98,
            tax: 6.40,
            total: 86.38,
          ),
        ),
      ],
      verify: (_) {
        verify(mockCalculateCartPriceUseCase.call(any)).called(2);
      },
    );
  });

  group('DecrementItem', () {
    blocTest<CartBloc, CartState>(
      'does nothing when cart is empty',
      build: () => bloc,
      act: (bloc) => bloc.add(CartEvent.decrementItem(product1.id)),
      expect: () => [],
    );

    blocTest<CartBloc, CartState>(
      'decrements quantity when item has quantity > 1',
      build: () {
        when(mockCalculateCartPriceUseCase.call(any)).thenReturn(
          const Cart(
            items: [CartItem(product: product1, quantity: 1)],
            subtotal: 29.99,
            tax: 2.40,
            total: 32.39,
          ),
        );
        return bloc;
      },
      act: (bloc) {
        bloc.add(CartEvent.addToCart(product1));
        bloc.add(CartEvent.addToCart(product1));
        bloc.add(CartEvent.decrementItem(product1.id));
      },
      expect: () => [
        const CartState.loaded(
          cart: Cart(
            items: [CartItem(product: product1, quantity: 1)],
            subtotal: 29.99,
            tax: 2.40,
            total: 32.39,
          ),
        ),
        const CartState.loaded(
          cart: Cart(
            items: [CartItem(product: product1, quantity: 1)],
            subtotal: 29.99,
            tax: 2.40,
            total: 32.39,
          ),
        ),
        const CartState.loaded(
          cart: Cart(
            items: [CartItem(product: product1, quantity: 1)],
            subtotal: 29.99,
            tax: 2.40,
            total: 32.39,
          ),
        ),
      ],
      verify: (_) {
        verify(mockCalculateCartPriceUseCase.call(any)).called(3);
      },
    );
  });

  group('ClearCart', () {
    blocTest<CartBloc, CartState>(
      'clears all items from cart',
      build: () {
        when(mockCalculateCartPriceUseCase.call(any)).thenReturn(
          const Cart(
            items: [
              CartItem(product: product1, quantity: 1),
              CartItem(product: product2, quantity: 1),
            ],
            subtotal: 79.98,
            tax: 6.40,
            total: 86.38,
          ),
        );
        return bloc;
      },
      act: (bloc) {
        bloc.add(CartEvent.addToCart(product1));
        bloc.add(CartEvent.addToCart(product2));
        bloc.add(CartEvent.clearCart());
      },
      expect: () => [
        const CartState.loaded(
          cart: Cart(
            items: [
              CartItem(product: product1, quantity: 1),
              CartItem(product: product2, quantity: 1),
            ],
            subtotal: 79.98,
            tax: 6.40,
            total: 86.38,
          ),
        ),
        const CartState.loaded(
          cart: Cart(
            items: [
              CartItem(product: product1, quantity: 1),
              CartItem(product: product2, quantity: 1),
            ],
            subtotal: 79.98,
            tax: 6.40,
            total: 86.38,
          ),
        ),
        const CartState.empty(),
      ],
      verify: (_) {
        verify(mockCalculateCartPriceUseCase.call(any)).called(2);
      },
    );
  });
}
