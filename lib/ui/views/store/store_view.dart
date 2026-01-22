import 'package:flutter/material.dart';
import 'package:nogesoft/ui/views/store/widget/store_product_card.dart';
import 'package:nogesoft/ui/views/store/widget/store_product_dialog.dart';
import 'package:stacked/stacked.dart';

import 'model/store_product.dart';
import 'store_viewmodel.dart';

class StoreView extends StackedView<StoreViewModel> {
  const StoreView({super.key});

  @override
  Widget builder(BuildContext context, StoreViewModel viewModel, Widget? child) {
    // IMPORTANT:
    // AppShell supplies the PrimaryScrollController for each page.
    // So we keep this as a "normal scrollable" and it will drive the global header.
    return CustomScrollView(
      primary: true,
      physics: const BouncingScrollPhysics(),
      slivers: [
        const SliverToBoxAdapter(child: SizedBox(height: 14)),

        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          sliver: SliverToBoxAdapter(
            child: _TopRow(
              onAdd: () => _openCreateDialog(context, viewModel),
            ),
          ),
        ),

        const SliverToBoxAdapter(child: SizedBox(height: 14)),

        SliverPadding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 18),
          sliver: SliverList.separated(
            itemCount: viewModel.products.length,
            separatorBuilder: (_, __) => const SizedBox(height: 14),
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
    );
  }

  Future<void> _openCreateDialog(
      BuildContext context,
      StoreViewModel viewModel,
      ) async {
    final res = await StoreProductDialog.show(
      context,
      title: 'Create Product',
      initialDimension: 'pcs',
    );

    if (res == null) return;

    viewModel.createProduct(
      name: res.name,
      category: res.category,
      price: res.price,
      stock: res.stock,
      dimension: res.dimension,
    );
  }

  Future<void> _openEditDialog(
      BuildContext context,
      StoreViewModel viewModel,
      StoreProduct product,
      ) async {
    final res = await StoreProductDialog.show(
      context,
      title: 'Create Product', // video only shows "Create Product"
      initialName: product.name,
      initialCategory: product.category,
      initialPrice: product.price,
      initialStock: product.stock,
      initialDimension: product.dimension,
    );

    if (res == null) return;

    viewModel.updateProduct(
      product.copyWith(
        name: res.name,
        category: res.category,
        price: res.price,
        stock: res.stock,
        dimension: res.dimension,
      ),
    );
  }

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
