import 'package:flutter/material.dart';
import 'package:holo_shop/core/design_system/atoms/dimensions.dart';

import '../../generated/l10n.dart';

class AppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  final bool showBackButton;

  const AppBarWidget({super.key, this.showBackButton = false});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: Dimensions.dp20,
          vertical: Dimensions.dp16,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                if (showBackButton)
                  GestureDetector(
                    onTap: () => Navigator.of(context).maybePop(),
                    child: const Icon(
                      Icons.arrow_back,
                      size: 24,
                      color: Colors.black,
                    ),
                  )
                else
                  Container(
                    width: Dimensions.dp24,
                    height: Dimensions.dp24,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.black,
                        width: Dimensions.dp2,
                      ),
                      borderRadius: BorderRadius.circular(Dimensions.dp4),
                    ),
                    child: const Icon(
                      Icons.inventory_2_outlined,
                      size: 16,
                      color: Colors.black,
                    ),
                  ),
                const SizedBox(width: Dimensions.dp8),
                Text(
                  S.of(context).appTitle,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: Dimensions.dp16,
                vertical: Dimensions.dp8,
              ),
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(Dimensions.dp8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.shopping_cart_outlined,
                    color: Colors.white,
                    size: 18,
                  ),
                  const SizedBox(width: Dimensions.dp6),
                  Text(
                    S.of(context).viewCart,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(Dimensions.dp72);
}
