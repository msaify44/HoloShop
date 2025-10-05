import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:holo_shop/core/design_system/atoms/dimensions.dart';
import 'package:holo_shop/generated/l10n.dart';
import 'package:holo_shop/features/cart/presentation/bloc/cart_bloc.dart';
import 'package:holo_shop/features/cart/presentation/bloc/cart_state.dart';


class ViewCartButton extends StatelessWidget {
  const ViewCartButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: Dimensions.dp16,
        vertical: Dimensions.dp8,
      ),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(Dimensions.dp8),
      ),
      child: BlocBuilder<CartBloc, CartState>(
        builder: (context, state) {
          final int itemCount = state.maybeWhen(
            loaded: (cart) => cart.totalItems,
            orElse: () => 0,
          );
          final String label = itemCount > 0
              ? '${S.of(context).viewCart} ($itemCount)'
              : S.of(context).viewCart;
          return Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.shopping_cart_outlined,
                color: Colors.white,
                size: Dimensions.dp18,
              ),
              const SizedBox(width: Dimensions.dp6),
              Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
