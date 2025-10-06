import 'package:flutter/material.dart';
import 'package:holo_shop/core/design_system/atoms/dimensions.dart';
import 'package:holo_shop/features/cart/presentation/widgets/view_cart_button.dart';
import 'package:holo_shop/shared/widgets/language_switcher_widget.dart';

import '../../generated/l10n.dart';

class AppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  final bool showBackButton;
  final bool showViewCartButton;
  final Function(Locale)? onLanguageChanged;

  const AppBarWidget({
    super.key,
    this.showBackButton = false,
    this.showViewCartButton = true,
    this.onLanguageChanged,
  });

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
                    child: Icon(
                      Directionality.of(context) == TextDirection.rtl
                          ? Icons.arrow_forward_ios
                          : Icons.arrow_back_ios,
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
            Row(
              children: [
                if (onLanguageChanged != null) ...[
                  LanguageSwitcher(onLanguageChanged: onLanguageChanged!),
                  SizedBox(width: Dimensions.dp8),
                ],
                if (showViewCartButton) ViewCartButton(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(Dimensions.dp72);
}
