import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:holo_shop/features/product_listing/presentation/widgets/product_tile_widget.dart';
import 'package:holo_shop/shared/product/domain/entity/product.dart';

import '../bloc/product_listing_bloc.dart';
import '../bloc/product_listing_event.dart';

class ProductListLoadedWidget extends StatelessWidget {
  final Function(Product product) onProductTap;
  final List<Product> products;

  const ProductListLoadedWidget({
    super.key,
    required this.products,
    required this.onProductTap,
  });

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        context.read<ProductListingBloc>().add(
          const ProductListingEvent.refreshProducts(),
        );
      },
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];
          return ProductTileWidget(product: product, onTap: onProductTap);
        },
      ),
    );
  }
}
