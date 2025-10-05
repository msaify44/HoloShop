import 'package:flutter/material.dart';
import 'package:holo_shop/generated/l10n.dart';
import 'package:holo_shop/features/product_listing/domain/entity/category.dart';
import '../../../../core/design_system/atoms/dimensions.dart';

class CategoryChipsWidget extends StatelessWidget {
  final List<Category> categories;
  final String? selectedCategoryId;
  final Function(String categoryId) onCategorySelected;

  const CategoryChipsWidget({
    super.key,
    required this.categories,
    required this.onCategorySelected,
    this.selectedCategoryId,
  });

  @override
  Widget build(BuildContext context) {
    if (categories.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: Dimensions.dp16,
        vertical: Dimensions.dp12,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Categories chips with horizontal scrolling
          SizedBox(
            height: Dimensions.dp50, // Max height for two rows (50px per row)
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Wrap(
                direction: Axis.horizontal,
                spacing: Dimensions.dp8,
                runSpacing: Dimensions.dp8,
                children: categories.map((category) {
                  final isSelected = selectedCategoryId == category.id;
                  return _CategoryChip(
                    category: category,
                    isSelected: isSelected,
                    onTap: () => onCategorySelected(category.id),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CategoryChip extends StatelessWidget {
  final Category category;
  final bool isSelected;
  final VoidCallback onTap;

  const _CategoryChip({
    required this.category,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(
          horizontal: Dimensions.dp16,
          vertical: Dimensions.dp8,
        ),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue : Colors.grey[100],
          borderRadius: BorderRadius.circular(Dimensions.dp20),
          border: Border.all(
            color: isSelected ? Colors.blue : Colors.grey[300]!,
            width: 1,
          ),
        ),
        child: Text(
          category.id.isEmpty ? S.of(context).all : category.title,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.grey[700],
            fontSize: 14,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
