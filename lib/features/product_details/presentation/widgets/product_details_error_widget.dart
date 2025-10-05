import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:holo_shop/core/design_system/atoms/dimensions.dart';
import 'package:holo_shop/generated/l10n.dart';
import 'package:holo_shop/features/product_details/presentation/bloc/product_details_bloc.dart';
import 'package:holo_shop/features/product_details/presentation/bloc/product_details_event.dart';

class ProductDetailsErrorWidget extends StatelessWidget {
  final String message;

  const ProductDetailsErrorWidget({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.error_outline,
            size: Dimensions.dp64,
            color: Colors.red,
          ),
          const SizedBox(height: Dimensions.dp16),
          Text(
            S.of(context).productDetailsErrorTitle,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: Dimensions.dp8),
          Text(
            message,
            style: const TextStyle(fontSize: 14, color: Colors.grey),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: Dimensions.dp24),
          ElevatedButton(
            onPressed: () {
              context.read<ProductDetailsBloc>().add(
                ProductDetailsEvent.refreshProductDetails(),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(
                horizontal: Dimensions.dp24,
                vertical: Dimensions.dp12,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(Dimensions.dp8),
              ),
            ),
            child: Text(S.of(context).retry),
          ),
        ],
      ),
    );
  }
}
