import 'package:flutter/material.dart';
import 'package:holo_shop/core/design_system/atoms/dimensions.dart';
import 'package:holo_shop/features/cart/domain/entity/cart.dart';
import 'package:holo_shop/generated/l10n.dart';

class CartSummaryWidget extends StatelessWidget {
  final Cart cart;

  const CartSummaryWidget({
    super.key,
    required this.cart,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(Dimensions.dp16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(Dimensions.dp8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Order Summary heading
          Text(
            S.of(context).orderSummary,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: Dimensions.dp16),
          
          // Price breakdown
          _buildPriceRow(
            S.of(context).subtotal,
            '\$${cart.price.subtotal.toStringAsFixed(2)}',
            isTotal: false,
          ),
          const SizedBox(height: Dimensions.dp8),
          
          _buildPriceRow(
            S.of(context).shipping,
            S.of(context).free,
            isTotal: false,
          ),
          const SizedBox(height: Dimensions.dp8),
          
          // Divider
          Container(
            height: 1,
            color: Colors.grey[300],
          ),
          const SizedBox(height: Dimensions.dp8),
          
          // Total
          _buildPriceRow(
            S.of(context).total,
            '\$${cart.price.total.toStringAsFixed(2)}',
            isTotal: true,
          ),
          const SizedBox(height: Dimensions.dp24),
          
          // Proceed to Checkout button
          _buildCheckoutButton(context),
        ],
      ),
    );
  }

  Widget _buildPriceRow(String label, String value, {required bool isTotal}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: isTotal ? 16 : 14,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            color: Colors.black,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: isTotal ? 16 : 14,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            color: Colors.black,
          ),
        ),
      ],
    );
  }

  Widget _buildCheckoutButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () => _handleCheckout(context),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(
            vertical: Dimensions.dp16,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(Dimensions.dp8),
          ),
        ),
        child: Text(
          S.of(context).proceedToCheckout,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  void _handleCheckout(BuildContext context) {
    // TODO: Implement checkout logic
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(S.of(context).checkoutNotImplemented),
        backgroundColor: Colors.orange,
      ),
    );
  }
}