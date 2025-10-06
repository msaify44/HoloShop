import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:holo_shop/core/di/injection_container.dart';
import 'package:holo_shop/features/product_details/presentation/screens/product_details_screen.dart';
import 'package:holo_shop/features/product_listing/presentation/bloc/product_listing_bloc.dart';
import 'package:holo_shop/features/product_listing/presentation/bloc/product_listing_event.dart';
import 'package:holo_shop/features/product_listing/presentation/bloc/product_listing_state.dart';
import 'package:holo_shop/features/product_listing/presentation/widgets/category_chips_widget.dart';
import 'package:holo_shop/features/product_listing/presentation/widgets/product_list_error_widget.dart';
import 'package:holo_shop/features/product_listing/presentation/widgets/product_list_loaded_widget.dart';
import 'package:holo_shop/features/product_listing/presentation/widgets/product_list_loading_widget.dart';
import 'package:holo_shop/features/product_listing/presentation/widgets/product_list_empty_widget.dart';
import 'package:holo_shop/shared/widgets/app_bar_widget.dart';


class ProductsListingScreen extends StatelessWidget {
  final Function(Locale)? onLanguageChanged;
  
  const ProductsListingScreen({
    super.key,
    this.onLanguageChanged,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          getIt<ProductListingBloc>()
            ..add(const ProductListingEvent.fetchProducts()),
      child: _ProductsListingView(onLanguageChanged: onLanguageChanged),
    );
  }
}

class _ProductsListingView extends StatelessWidget {
  final Function(Locale)? onLanguageChanged;
  
  const _ProductsListingView({this.onLanguageChanged});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBarWidget(onLanguageChanged: onLanguageChanged),
      body: SafeArea(
        child: BlocBuilder<ProductListingBloc, ProductListingState>(
          builder: (context, state) {
            return state.when(
              loading: () => ProductListLoadingWidget(),
              loaded: (categories, filteredProducts, _, selectedCategoryId) => Column(
                children: [
                  CategoryChipsWidget(
                    categories: categories,
                    selectedCategoryId: selectedCategoryId,
                    onCategorySelected: (categoryId) {
                      context.read<ProductListingBloc>().add(
                        ProductListingEvent.categoryChanged(categoryId),
                      );
                    },
                  ),
                  Expanded(
                    child: ProductListLoadedWidget(
                      products: filteredProducts,
                      onProductTap: (product) {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => ProductDetailsScreen(
                              productId: product.id,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
              empty: () => const ProductListEmptyWidget(),
              error: (message) =>
                  ProductListErrorWidget(errorMessage: message),
            );
          },
        ),
      ),
    );
  }
}
