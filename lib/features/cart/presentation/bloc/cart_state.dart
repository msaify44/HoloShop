import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:holo_shop/features/cart/domain/entity/cart.dart';

part 'cart_state.freezed.dart';

@freezed
class CartState with _$CartState {
  const factory CartState.empty() = _Empty;
  const factory CartState.loaded({required Cart cart}) = _Loaded;
}


