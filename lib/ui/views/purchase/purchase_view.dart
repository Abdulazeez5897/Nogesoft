import 'package:flutter/material.dart';
import 'package:nogesoft/ui/views/purchase/widget/new_purchase_sheet.dart';
import 'package:nogesoft/ui/views/purchase/widget/purchase_card.dart';
import 'package:nogesoft/core/data/models/purchase.dart';
import 'package:nogesoft/ui/views/purchase/purchase_viewmodel.dart';
import 'package:stacked/stacked.dart';

import 'package:nogesoft/ui/common/ui_helpers.dart';

class PurchaseView extends StackedView<PurchaseViewModel> {
  const PurchaseView({super.key});

  @override
  PurchaseViewModel viewModelBuilder(BuildContext context) => PurchaseViewModel();

  @override
  Widget builder(BuildContext context, PurchaseViewModel viewModel, Widget? child) {
    return CustomScrollView(
      primary: true,
      physics: const BouncingScrollPhysics(),
      slivers: [
        SliverToBoxAdapter(child: verticalSpace(16)),

        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          sliver: SliverToBoxAdapter(
            child: _HeaderBlock(
              onAdd: () => _openNewPurchase(context, viewModel),
            ),
          ),
        ),

        SliverToBoxAdapter(child: verticalSpace(12)),

        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          sliver: SliverToBoxAdapter(
            child: _SearchBar(
              onChanged: viewModel.setQuery,
            ),
          ),
        ),

        SliverToBoxAdapter(child: verticalSpace(14)),

        SliverPadding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 22),
          sliver: viewModel.visiblePurchases.isEmpty
              ? const SliverToBoxAdapter(child: _EmptyState())
              : SliverList.separated(
            itemCount: viewModel.visiblePurchases.length,
            separatorBuilder: (_, __) => verticalSpace(14),
            itemBuilder: (_, i) {
              final p = viewModel.visiblePurchases[i];
              return PurchaseCard(
                purchase: p,
                money: viewModel.formatNaira,
                date: viewModel.formatDate,
              );
            },
          ),
        ),
      ],
    );
  }

  Future<void> _openNewPurchase(BuildContext context, PurchaseViewModel viewModel) async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => NewPurchaseSheet(
        suppliers: viewModel.suppliers,
        catalog: viewModel.catalog,
      ),
    );
  }
}
// ...
class _HeaderBlock extends StatelessWidget {
  final VoidCallback onAdd;
  const _HeaderBlock({required this.onAdd});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                'Purchases',
                style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w900),
              ),
              verticalSpaceTiny, // Wait, need to check if verticalSpaceTiny is const? It is const Widget. Can be used in children list. Actually in children: const [ ... ] I cannot use non-const if the list is const. verticalSpaceTiny is const. But verticalSpace(4) is not. existing was SizedBox(height: 4).
              // Let's use verticalSpaceTiny if it's defined (usually 5.0). 4.0 is close enough.
              Text(
                'Track all stock purchases',
                style: TextStyle(color: Colors.white60, fontWeight: FontWeight.w700),
              ),
            ],
          ),
        ),
        horizontalSpace(12),
        SizedBox(
// ...
          height: 42,
          child: ElevatedButton(
            onPressed: onAdd,
            style: ElevatedButton.styleFrom(
              elevation: 0,
              backgroundColor: const Color(0xFF38B24A),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              padding: const EdgeInsets.symmetric(horizontal: 16),
            ),
            child: const Text('+ Add Purchase', style: TextStyle(fontWeight: FontWeight.w900)),
          ),
        ),
      ],
    );
  }
}

class _SearchBar extends StatelessWidget {
  final ValueChanged<String> onChanged;
  const _SearchBar({required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 46,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: const Color(0xFF101A2B),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: TextField(
          onChanged: onChanged,
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
          decoration: const InputDecoration(
            border: InputBorder.none,
            hintText: 'Search by invoice number...',
            hintStyle: TextStyle(color: Colors.white38, fontWeight: FontWeight.w700),
          ),
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 26, horizontal: 14),
      decoration: BoxDecoration(
        color: const Color(0xFF101A2B),
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Center(
        child: Text(
          'No purchases found',
          style: TextStyle(color: Colors.white60, fontSize: 16, fontWeight: FontWeight.w800),
        ),
      ),
    );
  }
}
