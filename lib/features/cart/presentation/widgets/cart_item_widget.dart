import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:holo_shop/core/design_system/atoms/dimensions.dart';
import 'package:holo_shop/features/cart/domain/entity/cart_item.dart';
import 'package:holo_shop/features/cart/presentation/bloc/cart_bloc.dart';
import 'package:holo_shop/features/cart/presentation/bloc/cart_event.dart';

class CartItemWidget extends StatelessWidget {
  final CartItem item;

  const CartItemWidget({
    super.key,
    required this.item,
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
      child: Row(
        children: [
          // Product Image
          _buildProductImage(),
          const SizedBox(width: Dimensions.dp16),
          
          // Product Details
          Expanded(
            child: _buildProductDetails(),
          ),
          
          // Quantity Controls
          _buildQuantityControls(context),
          const SizedBox(width: Dimensions.dp16),
          
          // Delete Button
          _buildDeleteButton(context),
        ],
      ),
    );
  }

  Widget _buildProductImage() {
    return _ProductImageWidget(item: item);
  }

  Widget _buildProductDetails() {
    return _ProductDetailsWidget(item: item);
  }

  Widget _buildQuantityControls(BuildContext context) {
    return _QuantityControlsWidget(item: item);
  }

  Widget _buildDeleteButton(BuildContext context) {
    return _DeleteButtonWidget(item: item);
  }
}

class _ProductImageWidget extends StatelessWidget {
  final CartItem item;

  const _ProductImageWidget({required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(Dimensions.dp8),
        color: Colors.yellow[100], // Light yellow background like in design
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(Dimensions.dp8),
        child: item.product.image != null
            ? Image.network(
                item.product.image!,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => _PlaceholderImageWidget(),
              )
            : _PlaceholderImageWidget(),
      ),
    );
  }
}

class _PlaceholderImageWidget extends StatelessWidget {
  const _PlaceholderImageWidget();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[200],
      child: Icon(
        Icons.image,
        color: Colors.grey[400],
        size: 40,
      ),
    );
  }
}

class _ProductDetailsWidget extends StatelessWidget {
  final CartItem item;

  const _ProductDetailsWidget({required this.item});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Product Name
        Text(
          item.product.title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 4),
        
        // Category
        Text(
          item.product.category,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
          ),
        ),
        const SizedBox(height: 4),
        
        // Price
        Text(
          '\$${item.product.price.toStringAsFixed(2)}',
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ],
    );
  }
}

class _QuantityControlsWidget extends StatelessWidget {
  final CartItem item;

  const _QuantityControlsWidget({required this.item});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Decrease Button
        _QuantityButtonWidget(
          icon: Icons.remove,
          onPressed: () {
            context.read<CartBloc>().add(
              CartEvent.decrementItem(item.product.id),
            );
          },
        ),
        const SizedBox(width: Dimensions.dp8),
        
        // Quantity Display
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: Dimensions.dp8,
            vertical: 4,
          ),
          child: Text(
            item.quantity.toString(),
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
          ),
        ),
        const SizedBox(width: Dimensions.dp8),
        
        // Increase Button
        _QuantityButtonWidget(
          icon: Icons.add,
          onPressed: () {
            context.read<CartBloc>().add(
              CartEvent.addToCart(item.product),
            );
          },
        ),
      ],
    );
  }
}

class _QuantityButtonWidget extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;

  const _QuantityButtonWidget({
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: Colors.grey[200],
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          size: 18,
          color: Colors.black,
        ),
      ),
    );
  }
}

class _DeleteButtonWidget extends StatelessWidget {
  final CartItem item;

  const _DeleteButtonWidget({required this.item});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.read<CartBloc>().add(
          CartEvent.removeFromCart(item.product.id),
        );
      },
      child: Icon(
        Icons.delete_outline,
        color: Colors.red[400],
        size: 20,
      ),
    );
  }
}
