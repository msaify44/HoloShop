import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:holo_shop/core/design_system/atoms/dimensions.dart';
import 'package:holo_shop/features/product_listing/presentation/bloc/product_listing_bloc.dart';
import 'package:holo_shop/features/product_listing/presentation/bloc/product_listing_event.dart';
import 'package:holo_shop/features/product_listing/presentation/bloc/product_listing_state.dart';
import 'package:holo_shop/features/product_listing/presentation/widgets/category_chips_widget.dart';
import 'package:holo_shop/generated/l10n.dart';

class ProductListEmptyWidget extends StatelessWidget {
  const ProductListEmptyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Show category chips even when empty
        BlocBuilder<ProductListingBloc, ProductListingState>(
          builder: (context, state) {
            return state.maybeWhen(
              empty: () => const SizedBox.shrink(), // No categories to show
              loaded: (categories, _, __, selectedCategoryId) => CategoryChipsWidget(
                categories: categories,
                selectedCategoryId: selectedCategoryId,
                onCategorySelected: (categoryId) {
                  context.read<ProductListingBloc>().add(
                    ProductListingEvent.categoryChanged(categoryId),
                  );
                },
              ),
              orElse: () => const SizedBox.shrink(),
            );
          },
        ),
        
        // Empty state content
        Expanded(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Empty state icon
                Container(
                  width: Dimensions.dp80,
                  height: Dimensions.dp80,
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.inventory_2_outlined,
                    size: Dimensions.dp40,
                    color: Colors.grey[400],
                  ),
                ),
                
                const SizedBox(height: Dimensions.dp24),
                
                // Empty state title
                Text(
                  S.of(context).noProductsAvailable,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey,
                  ),
                  textAlign: TextAlign.center,
                ),
                
                const SizedBox(height: Dimensions.dp8),
                
                // Empty state subtitle
                Text(
                  'Try refreshing or check back later',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[500],
                  ),
                  textAlign: TextAlign.center,
                ),
                
                const SizedBox(height: Dimensions.dp24),
                
                // Refresh button
                ElevatedButton.icon(
                  onPressed: () {
                    context.read<ProductListingBloc>().add(
                      const ProductListingEvent.refreshProducts(),
                    );
                  },
                  icon: const Icon(Icons.refresh),
                  label: Text(S.of(context).retry),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: Dimensions.dp24,
                      vertical: Dimensions.dp12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(Dimensions.dp8),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
