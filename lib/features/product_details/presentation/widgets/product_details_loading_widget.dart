import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:holo_shop/core/design_system/atoms/dimensions.dart';

class ProductDetailsLoadingWidget extends StatelessWidget {
  const ProductDetailsLoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(Dimensions.dp20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: Dimensions.dp24),
          _ShimmerBox(height: 300, width: double.infinity, borderRadius: Dimensions.dp12),
          const SizedBox(height: Dimensions.dp24),
          Row(
            children: [
              _ShimmerBox(height: 24, width: 80, borderRadius: Dimensions.dp12),
            ],
          ),
          const SizedBox(height: Dimensions.dp12),
          _ShimmerBox(height: 28, width: 220, borderRadius: Dimensions.dp8),
          const SizedBox(height: Dimensions.dp8),
          _ShimmerBox(height: 36, width: 120, borderRadius: Dimensions.dp8),
          const SizedBox(height: Dimensions.dp24),
          Container(
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
              children: const [
                _ShimmerBox(height: 20, width: 180, borderRadius: Dimensions.dp6),
                SizedBox(height: Dimensions.dp12),
                _ShimmerLineParagraph(lines: 4),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ShimmerBox extends StatelessWidget {
  final double height;
  final double width;
  final double borderRadius;

  const _ShimmerBox({
    required this.height,
    required this.width,
    this.borderRadius = 8,
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
    );
  }
}

class _ShimmerLineParagraph extends StatelessWidget {
  final int lines;
  const _ShimmerLineParagraph({this.lines = 3});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(lines, (index) {
        final double width = index == lines - 1 ? MediaQuery.of(context).size.width * 0.6 : double.infinity;
        return Padding(
          padding: EdgeInsets.only(bottom: index == lines - 1 ? 0 : Dimensions.dp8),
          child: _ShimmerBox(height: 14, width: width, borderRadius: Dimensions.dp6),
        );
      }),
    );
  }
}
