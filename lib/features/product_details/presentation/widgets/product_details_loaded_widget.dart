import 'package:flutter/material.dart';
import 'package:holo_shop/core/design_system/atoms/dimensions.dart';
import 'package:holo_shop/shared/product/domain/entity/product.dart';

class ProductDetailsLoadedWidget extends StatelessWidget {
  final Product product;

  const ProductDetailsLoadedWidget({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(Dimensions.dp20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: Dimensions.dp24),
          _ProductImageSection(imageUrl: product.image),
          const SizedBox(height: Dimensions.dp24),
          _ProductInfoWidget(product: product),
          const SizedBox(height: Dimensions.dp24),
          _ProductDescriptionWidget(description: product.description),
        ],
      ),
    );
  }
}

class _ProductImageSection extends StatelessWidget {
  final String? imageUrl;

  const _ProductImageSection({super.key, this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFFFFD700), // Bright yellow background
        borderRadius: BorderRadius.circular(Dimensions.dp12),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(Dimensions.dp12),
        child: imageUrl != null
            ? Image.network(
                imageUrl!,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return _PlaceHolderImage();
                },
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return const Center(
                    child: CircularProgressIndicator(color: Colors.black),
                  );
                },
              )
            : _PlaceHolderImage(),
      ),
    );
  }
}

class _PlaceHolderImage extends StatelessWidget {
  const _PlaceHolderImage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFFFD700),
      child: const Center(
        child: Icon(Icons.headphones, size: 120, color: Colors.black54),
      ),
    );
  }
}

class _ProductInfoWidget extends StatelessWidget {
  final Product product;

  const _ProductInfoWidget({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Category tag
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: Dimensions.dp12,
            vertical: Dimensions.dp6,
          ),
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(Dimensions.dp16),
          ),
          child: Text(
            product.category.toUpperCase(),
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
        ),
        const SizedBox(height: Dimensions.dp12),

        // Product name
        Text(
          product.title,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: Dimensions.dp8),

        // Price
        Text(
          '\$${product.price.toStringAsFixed(2)}',
          style: const TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ],
    );
  }
}

class _ProductDescriptionWidget extends StatelessWidget {

  final String description;

  const _ProductDescriptionWidget({super.key, required this.description});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(Dimensions.dp20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(Dimensions.dp12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Product Description',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: Dimensions.dp12),
          Text(
            description,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.black87,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
