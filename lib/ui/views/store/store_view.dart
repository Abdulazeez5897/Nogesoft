import 'package:flutter/material.dart';
import 'package:nogesoft/ui/views/store/widget/store_product_card.dart';
import 'package:nogesoft/ui/views/store/widget/store_product_dialog.dart';
import 'package:stacked/stacked.dart';

import 'package:nogesoft/core/data/models/product.dart';
import 'package:nogesoft/ui/common/ui_helpers.dart';
import 'store_viewmodel.dart';

class StoreView extends StackedView<StoreViewModel> {
  const StoreView({super.key});

  @override
  Widget builder(BuildContext context, StoreViewModel viewModel, Widget? child) {
    // IMPORTANT:
    // AppShell supplies the PrimaryScrollController for each page.
    // So we keep this as a "normal scrollable" and it will drive the global header.
    return Material(
      color: Colors.transparent,
      child: CustomScrollView(
        primary: true,
        // physics: const BouncingScrollPhysics(), // Match Dashboard (use default Platform physics)
        slivers: [
          SliverToBoxAdapter(child: verticalSpace(106)),

          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverToBoxAdapter(
              child: _TopRow(
                onAdd: () => _openCreateDialog(context, viewModel),
              ),
            ),
          ),

          SliverToBoxAdapter(child: verticalSpace(14)),

          if (viewModel.isBusy)
             const SliverFillRemaining(
               child: Center(child: CircularProgressIndicator(color: Color(0xFF38B24A))),
             )
          else
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 18),
              sliver: SliverList.separated(
                itemCount: viewModel.products.length,
                separatorBuilder: (_, __) => verticalSpace(14),
                itemBuilder: (ctx, i) {
                  final p = viewModel.products[i];
                  return StoreProductCard(
                    product: p,
                    onEdit: () => _openEditDialog(context, viewModel, p),
                    onDelete: () => viewModel.deleteProduct(p.id),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }

  Future<void> _openCreateDialog(
      BuildContext context,
      StoreViewModel viewModel,
      ) async {
    final res = await StoreProductDialog.show(
      context,
      title: 'Create Product',
      initialUnit: 'pcs',
    );

    if (res == null) return;

    viewModel.createProduct(
      name: res.name,
      category: res.category,
      price: res.price,
      stock: res.stock,
      unit: res.unit,
      dimensions: res.dimensions,
      date: res.date,
    );
  }

  Future<void> _openEditDialog(
      BuildContext context,
      StoreViewModel viewModel,
      Product product,
      ) async {
    final res = await StoreProductDialog.show(
      context,
      title: 'Edit Product',
      initialName: product.name,
      initialCategory: product.category,
      initialPrice: product.price.toInt(),
      initialStock: product.stockQuantity,
      initialUnit: product.unit,
      initialDimensions: product.dimensions,
      initialDate: product.expiryDate,
    );

    if (res == null) return;

    viewModel.updateProduct(
      product.copyWith(
        name: res.name,
        category: res.category,
        price: res.price.toDouble(),
        stockQuantity: res.stock,
        unit: res.unit,
        dimensions: res.dimensions,
        expiryDate: res.date,
      ),
    );
  }

  @override
  void onViewModelReady(StoreViewModel viewModel) => viewModel.init();

  @override
  StoreViewModel viewModelBuilder(BuildContext context) => StoreViewModel();
}

class _TopRow extends StatelessWidget {
  final VoidCallback onAdd;

  const _TopRow({required this.onAdd});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Text(
          'Products',
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.w900,
          ),
        ),
        const Spacer(),
        SizedBox(
          height: 42,
          child: ElevatedButton(
            onPressed: onAdd,
            style: ElevatedButton.styleFrom(
              elevation: 0,
              backgroundColor: const Color(0xFF38B24A),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16),
            ),
            child: const Text(
              '+ Add Product',
              style: TextStyle(fontWeight: FontWeight.w800),
            ),
          ),
        ),
      ],
    );
  }
}
