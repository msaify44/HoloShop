import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:holo_shop/core/design_system/atoms/dimensions.dart';
import 'package:holo_shop/features/cart/presentation/bloc/cart_bloc.dart';
import 'package:holo_shop/features/cart/presentation/bloc/cart_state.dart';
import 'package:holo_shop/features/cart/presentation/widgets/cart_item_widget.dart';
import 'package:holo_shop/features/cart/presentation/widgets/cart_summary_widget.dart';
import 'package:holo_shop/generated/l10n.dart';
import 'package:holo_shop/shared/widgets/app_bar_widget.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBarWidget(showBackButton: true, showViewCartButton: false),
      body: BlocBuilder<CartBloc, CartState>(
        builder: (context, state) {
          return state.when(
            empty: () => _buildEmptyCart(context),
            loaded: (cart) => _buildCartContent(context, cart),
          );
        },
      ),
    );
  }

  Widget _buildEmptyCart(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.shopping_cart_outlined, size: 80, color: Colors.grey[400]),
          const SizedBox(height: Dimensions.dp16),
          Text(
            S.of(context).cartEmpty,
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(color: Colors.grey[400]),
          ),
          const SizedBox(height: Dimensions.dp8),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(
                horizontal: Dimensions.dp24,
                vertical: Dimensions.dp16,
              ),
            ),
            child: Text(S.of(context).continueShopping),
          ),
        ],
      ),
    );
  }

  Widget _buildCartContent(BuildContext context, cart) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(Dimensions.dp16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Continue Shopping button
          _buildContinueShopping(context),
          const SizedBox(height: Dimensions.dp24),

          // Shopping Cart heading
          Text(
            S.of(context).shoppingCart,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: Dimensions.dp16),

          // Cart items
          ...cart.items.map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: Dimensions.dp16),
              child: CartItemWidget(item: item),
            ),
          ),

          const SizedBox(height: Dimensions.dp24),

          // Order Summary
          CartSummaryWidget(cart: cart),
        ],
      ),
    );
  }

  Widget _buildContinueShopping(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.of(context).pop(),
      child: Row(
        children: [
          Icon(Icons.inventory_2, color: Colors.black, size: 20),
          const SizedBox(width: Dimensions.dp8),
          Text(
            S.of(context).continueShopping,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: Colors.black,
              decoration: TextDecoration.underline,
            ),
          ),
        ],
      ),
    );
  }
}
