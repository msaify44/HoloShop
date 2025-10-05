import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:holo_shop/features/cart/presentation/bloc/cart_bloc.dart';
import 'package:holo_shop/features/cart/presentation/bloc/cart_event.dart';
import 'package:holo_shop/features/product_details/presentation/bloc/product_details_bloc.dart';
import 'package:holo_shop/features/product_details/presentation/bloc/product_details_state.dart';
import 'package:holo_shop/generated/l10n.dart';

class AddToCartFooter extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductDetailsBloc, ProductDetailsState>(
      builder: (context, state) {
        final isLoaded = state.maybeWhen(loaded: (_) => true, orElse: () => false);
        if (!isLoaded) return const SizedBox.shrink();

        return SafeArea(
          top: false,
          child: Container(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.06),
                  blurRadius: 12,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: () {
                  state.when(
                    loading: () {},
                    error: (_) {},
                    loaded: (product) {
                      context.read<CartBloc>().add(CartEvent.addToCart(product));
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(S.of(context).addedToCart)),
                      );
                    },
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  S.of(context).addToCart,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
