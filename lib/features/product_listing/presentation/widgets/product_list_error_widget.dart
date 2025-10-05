import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:holo_shop/core/design_system/atoms/dimensions.dart';
import 'package:holo_shop/features/product_listing/presentation/bloc/product_listing_bloc.dart';
import 'package:holo_shop/features/product_listing/presentation/bloc/product_listing_event.dart';
import 'package:holo_shop/generated/l10n.dart';

class ProductListErrorWidget extends StatelessWidget {
  final String errorMessage;

  const ProductListErrorWidget({super.key, required this.errorMessage});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.error_outline,
            size: Dimensions.dp66,
            color: Colors.red,
          ),
          const SizedBox(height: 16),
          Text(
            S.of(context).error(errorMessage),
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.red),
          ),
          const SizedBox(height: Dimensions.dp16),
          ElevatedButton(
            onPressed: () {
              context.read<ProductListingBloc>().add(
                const ProductListingEvent.fetchProducts(),
              );
            },
            child: Text(S.of(context).retry),
          ),
        ],
      ),
    );
  }
}
