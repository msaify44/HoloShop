import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:holo_shop/features/cart/presentation/bloc/cart_event.dart';
import 'package:holo_shop/features/cart/presentation/bloc/cart_state.dart';
import 'package:holo_shop/features/cart/domain/entity/cart_item.dart';
import 'package:holo_shop/features/cart/domain/entity/cart.dart';
import 'package:holo_shop/features/cart/domain/use_cases/calculate_cart_price/calculate_cart_price_use_case.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  final CalculateCartPriceUseCase _calculateCartPriceUseCase;

  CartBloc({
    required CalculateCartPriceUseCase calculateCartPriceUseCase,
  }) : _calculateCartPriceUseCase = calculateCartPriceUseCase,
       super(const CartState.empty()) {
    on<CartEvent>((event, emit) {
      event.when(
        addToCart: (product) {
          final List<CartItem> currentItems = state.maybeWhen(
            loaded: (cart) => List.of(cart.items),
            orElse: () => <CartItem>[],
          );
          final index = currentItems.indexWhere((i) => i.product.id == product.id);
          if (index >= 0) {
            final existing = currentItems[index];
            currentItems[index] = existing.copyWith(quantity: existing.quantity + 1);
          } else {
            currentItems.add(CartItem(product: product, quantity: 1));
          }
          final cart = _calculateCartPriceUseCase(currentItems);
          emit(CartState.loaded(cart: cart));
        },
        decrementItem: (productId) {
          state.maybeWhen(
            loaded: (cart) {
              final List<CartItem> updated = List.of(cart.items);
              final index = updated.indexWhere((i) => i.product.id == productId);
              if (index >= 0) {
                final existing = updated[index];
                if (existing.quantity > 1) {
                  updated[index] = existing.copyWith(quantity: existing.quantity - 1);
                  final newCart = _calculateCartPriceUseCase(updated);
                  emit(CartState.loaded(cart: newCart));
                } else {
                  updated.removeAt(index);
                  if (updated.isEmpty) {
                    emit(const CartState.empty());
                  } else {
                    final newCart = _calculateCartPriceUseCase(updated);
                    emit(CartState.loaded(cart: newCart));
                  }
                }
              }
            },
            orElse: () {},
          );
        },
        removeFromCart: (productId) {
          state.maybeWhen(
            loaded: (cart) {
              final updated = cart.items.where((i) => i.product.id != productId).toList();
              if (updated.isEmpty) {
                emit(const CartState.empty());
              } else {
                final newCart = _calculateCartPriceUseCase(updated);
                emit(CartState.loaded(cart: newCart));
              }
            },
            orElse: () {},
          );
        },
        clearCart: () {
          emit(const CartState.empty());
        },
      );
    });
  }
}


