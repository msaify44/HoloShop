import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:holo_shop/shared/product/domain/entity/product.dart';

part 'cart_item.freezed.dart';

@freezed
class CartItem with _$CartItem {
  const factory CartItem({
    required Product product,
    @Default(1) int quantity,
  }) = _CartItem;
}


