import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:holo_shop/core/di/injection_container.dart';
import 'package:holo_shop/core/design_system/atoms/dimensions.dart';
import 'package:holo_shop/features/product_details/presentation/bloc/product_details_bloc.dart';
import 'package:holo_shop/features/product_details/presentation/bloc/product_details_event.dart';
import 'package:holo_shop/features/product_details/presentation/bloc/product_details_state.dart';
import 'package:holo_shop/features/product_details/presentation/widgets/add_to_cart_footer.dart';
import 'package:holo_shop/features/product_details/presentation/widgets/product_details_error_widget.dart';
import 'package:holo_shop/features/product_details/presentation/widgets/product_details_loaded_widget.dart';
import 'package:holo_shop/features/product_details/presentation/widgets/product_details_loading_widget.dart';
import 'package:holo_shop/shared/widgets/app_bar_widget.dart';
import 'package:holo_shop/generated/l10n.dart';

class ProductDetailsScreen extends StatelessWidget {
  final int productId;

  const ProductDetailsScreen({super.key, required this.productId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          getIt<ProductDetailsBloc>()
            ..add(ProductDetailsEvent.fetchProductDetails(productId)),
        child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBarWidget(showBackButton: true),
        body: BlocBuilder<ProductDetailsBloc, ProductDetailsState>(
          builder: (context, state) {
            return state.when(
              loading: () => ProductDetailsLoadingWidget(),
              loaded: (product) => ProductDetailsLoadedWidget(product: product),
              error: (message) => ProductDetailsErrorWidget(message: message),
            );
          },
        ),
          bottomNavigationBar: AddToCartFooter(),
      ),
    );
  }
}
