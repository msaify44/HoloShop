import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'package:holo_shop/features/cart/domain/entity/cart.dart';
import 'package:holo_shop/features/cart/domain/entity/cart_item.dart';
import 'package:holo_shop/features/cart/domain/entity/cart_price.dart';
import 'package:holo_shop/features/cart/presentation/bloc/cart_bloc.dart';
import 'package:holo_shop/features/cart/presentation/bloc/cart_event.dart';
import 'package:holo_shop/features/cart/presentation/bloc/cart_state.dart';

import '../../../../fixtures/test_fixtures.dart';
import '../../../../mocks/mocks.mocks.dart';

void main() {
  late CartBloc bloc;
  late MockCalculateCartPriceUseCase mockCalculateCartPriceUseCase;
  late MockCartRepository mockCartRepository;

  setUp(() {
    mockCalculateCartPriceUseCase = MockCalculateCartPriceUseCase();
    mockCartRepository = MockCartRepository();
    
    // Mock repository methods to return successful futures
    when(mockCartRepository.saveCart(any)).thenAnswer((_) async {});
    when(mockCartRepository.loadCart()).thenAnswer((_) async => null);
    when(mockCartRepository.clearCart()).thenAnswer((_) async {});
    
    bloc = CartBloc(
      calculateCartPriceUseCase: mockCalculateCartPriceUseCase,
      cartRepository: mockCartRepository,
    );
  });

  tearDown(() {
    bloc.close();
  });

  group('CartBloc', () {
    test('initial state is empty', () {
      expect(bloc.state, const CartState.empty());
    });

    group('AddToCart', () {
      blocTest<CartBloc, CartState>(
        'emits loaded with single item when adding first product',
        build: () {
          when(mockCalculateCartPriceUseCase.call(any)).thenReturn(
            const CartPrice(
              subtotal: 29.99,
              tax: 2.40,
              total: 32.39,
            ),
          );
          return bloc;
        },
        act: (bloc) => bloc.add(CartEvent.addToCart(TestFixtures.sampleProduct1)),
        expect: () => [
          const CartState.loaded(
            cart: Cart(
              items: [CartItem(product: TestFixtures.sampleProduct1, quantity: 1)],
              price: CartPrice(
                subtotal: 29.99,
                tax: 2.40,
                total: 32.39,
              ),
            ),
          ),
        ],
        verify: (_) {
          verify(mockCalculateCartPriceUseCase.call(any)).called(1);
          verify(mockCartRepository.saveCart(any)).called(1);
        },
      );

      blocTest<CartBloc, CartState>(
        'increments quantity when adding same product again',
        build: () {
          int callCount = 0;
          when(mockCalculateCartPriceUseCase.call(any)).thenAnswer((_) {
            callCount++;
            if (callCount == 1) {
              return const CartPrice(
                subtotal: 29.99,
                tax: 2.40,
                total: 32.39,
              );
            } else {
              return const CartPrice(
                subtotal: 59.98,
                tax: 4.80,
                total: 64.78,
              );
            }
          });
          return bloc;
        },
        act: (bloc) {
          bloc.add(CartEvent.addToCart(TestFixtures.sampleProduct1));
          bloc.add(CartEvent.addToCart(TestFixtures.sampleProduct1));
        },
        expect: () => [
          const CartState.loaded(
            cart: Cart(
              items: [CartItem(product: TestFixtures.sampleProduct1, quantity: 1)],
              price: CartPrice(
                subtotal: 29.99,
                tax: 2.40,
                total: 32.39,
              ),
            ),
          ),
          const CartState.loaded(
            cart: Cart(
              items: [CartItem(product: TestFixtures.sampleProduct1, quantity: 2)],
              price: CartPrice(
                subtotal: 59.98,
                tax: 4.80,
                total: 64.78,
              ),
            ),
          ),
        ],
        verify: (_) {
          verify(mockCalculateCartPriceUseCase.call(any)).called(2);
          verify(mockCartRepository.saveCart(any)).called(2);
        },
      );

      blocTest<CartBloc, CartState>(
        'adds different product to existing cart',
        build: () {
          int callCount = 0;
          when(mockCalculateCartPriceUseCase.call(any)).thenAnswer((_) {
            callCount++;
            if (callCount == 1) {
              return const CartPrice(
                subtotal: 29.99,
                tax: 2.40,
                total: 32.39,
              );
            } else {
              return const CartPrice(
                subtotal: 79.98,
                tax: 6.40,
                total: 86.38,
              );
            }
          });
          return bloc;
        },
        act: (bloc) {
          bloc.add(CartEvent.addToCart(TestFixtures.sampleProduct1));
          bloc.add(CartEvent.addToCart(TestFixtures.sampleProduct2));
        },
        expect: () => [
          const CartState.loaded(
            cart: Cart(
              items: [CartItem(product: TestFixtures.sampleProduct1, quantity: 1)],
              price: CartPrice(
                subtotal: 29.99,
                tax: 2.40,
                total: 32.39,
              ),
            ),
          ),
          const CartState.loaded(
            cart: Cart(
              items: [
                CartItem(product: TestFixtures.sampleProduct1, quantity: 1),
                CartItem(product: TestFixtures.sampleProduct2, quantity: 1),
              ],
              price: CartPrice(
                subtotal: 79.98,
                tax: 6.40,
                total: 86.38,
              ),
            ),
          ),
        ],
        verify: (_) {
          verify(mockCalculateCartPriceUseCase.call(any)).called(2);
          verify(mockCartRepository.saveCart(any)).called(2);
        },
      );
    });

    group('DecrementItem', () {
      blocTest<CartBloc, CartState>(
        'does nothing when cart is empty',
        build: () => bloc,
        act: (bloc) => bloc.add(CartEvent.decrementItem(TestFixtures.sampleProduct1.id)),
        expect: () => [],
      );

      blocTest<CartBloc, CartState>(
        'decrements quantity when item has quantity > 1',
        build: () {
          int callCount = 0;
          when(mockCalculateCartPriceUseCase.call(any)).thenAnswer((_) {
            callCount++;
            if (callCount == 1) {
              return const CartPrice(
                subtotal: 29.99,
                tax: 2.40,
                total: 32.39,
              );
            } else if (callCount == 2) {
              return const CartPrice(
                subtotal: 59.98,
                tax: 4.80,
                total: 64.78,
              );
            } else {
              return const CartPrice(
                subtotal: 29.99,
                tax: 2.40,
                total: 32.39,
              );
            }
          });
          return bloc;
        },
        act: (bloc) {
          bloc.add(CartEvent.addToCart(TestFixtures.sampleProduct1));
          bloc.add(CartEvent.addToCart(TestFixtures.sampleProduct1));
          bloc.add(CartEvent.decrementItem(TestFixtures.sampleProduct1.id));
        },
        expect: () => [
          const CartState.loaded(
            cart: Cart(
              items: [CartItem(product: TestFixtures.sampleProduct1, quantity: 1)],
              price: CartPrice(
                subtotal: 29.99,
                tax: 2.40,
                total: 32.39,
              ),
            ),
          ),
          const CartState.loaded(
            cart: Cart(
              items: [CartItem(product: TestFixtures.sampleProduct1, quantity: 2)],
              price: CartPrice(
                subtotal: 59.98,
                tax: 4.80,
                total: 64.78,
              ),
            ),
          ),
          const CartState.loaded(
            cart: Cart(
              items: [CartItem(product: TestFixtures.sampleProduct1, quantity: 1)],
              price: CartPrice(
                subtotal: 29.99,
                tax: 2.40,
                total: 32.39,
              ),
            ),
          ),
        ],
        verify: (_) {
          verify(mockCalculateCartPriceUseCase.call(any)).called(3);
          verify(mockCartRepository.saveCart(any)).called(3);
        },
      );
    });

    group('ClearCart', () {
      blocTest<CartBloc, CartState>(
        'clears all items from cart',
        build: () {
          int callCount = 0;
          when(mockCalculateCartPriceUseCase.call(any)).thenAnswer((_) {
            callCount++;
            if (callCount == 1) {
              return const CartPrice(
                subtotal: 29.99,
                tax: 2.40,
                total: 32.39,
              );
            } else {
              return const CartPrice(
                subtotal: 79.98,
                tax: 6.40,
                total: 86.38,
              );
            }
          });
          return bloc;
        },
        act: (bloc) {
          bloc.add(CartEvent.addToCart(TestFixtures.sampleProduct1));
          bloc.add(CartEvent.addToCart(TestFixtures.sampleProduct2));
          bloc.add(CartEvent.clearCart());
        },
        expect: () => [
          const CartState.loaded(
            cart: Cart(
              items: [CartItem(product: TestFixtures.sampleProduct1, quantity: 1)],
              price: CartPrice(
                subtotal: 29.99,
                tax: 2.40,
                total: 32.39,
              ),
            ),
          ),
          const CartState.loaded(
            cart: Cart(
              items: [
                CartItem(product: TestFixtures.sampleProduct1, quantity: 1),
                CartItem(product: TestFixtures.sampleProduct2, quantity: 1),
              ],
              price: CartPrice(
                subtotal: 79.98,
                tax: 6.40,
                total: 86.38,
              ),
            ),
          ),
          const CartState.empty(),
        ],
        verify: (_) {
          verify(mockCalculateCartPriceUseCase.call(any)).called(2);
          verify(mockCartRepository.saveCart(any)).called(2);
          verify(mockCartRepository.clearCart()).called(1);
        },
      );
    });

    group('LoadFromCache', () {
      blocTest<CartBloc, CartState>(
        'loads cart from cache',
        build: () => bloc,
        act: (bloc) {
          final cachedCart = Cart(
            items: [CartItem(product: TestFixtures.sampleProduct1, quantity: 2)],
            price: const CartPrice(
              subtotal: 59.98,
              tax: 4.80,
              total: 64.78,
            ),
          );
          bloc.add(CartEvent.loadFromCache(cachedCart));
        },
        expect: () => [
          CartState.loaded(
            cart: Cart(
              items: [CartItem(product: TestFixtures.sampleProduct1, quantity: 2)],
              price: const CartPrice(
                subtotal: 59.98,
                tax: 4.80,
                total: 64.78,
              ),
            ),
          ),
        ],
      );
    });
  });
}