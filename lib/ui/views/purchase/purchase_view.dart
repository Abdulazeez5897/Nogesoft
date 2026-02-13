import 'package:flutter/material.dart';
import 'package:nogesoft/ui/views/purchase/widget/new_purchase_sheet.dart';
import 'package:nogesoft/ui/views/purchase/widget/purchase_card.dart';
import 'package:nogesoft/ui/views/purchase/purchase_viewmodel.dart';
import 'package:stacked/stacked.dart';

import 'package:nogesoft/ui/common/ui_helpers.dart';

class PurchaseView extends StackedView<PurchaseViewModel> {
  const PurchaseView({super.key});

  @override
  PurchaseViewModel viewModelBuilder(BuildContext context) => PurchaseViewModel();

  @override
  Widget builder(BuildContext context, PurchaseViewModel viewModel, Widget? child) {
    return Material(
      color: Colors.transparent,
      child: CustomScrollView(
        primary: true,
        // physics: const BouncingScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(child: verticalSpace(108)),

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
      ),
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
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Purchases',
                style: TextStyle(
                  color: theme.textTheme.titleLarge?.color, 
                  fontSize: 24, 
                  fontWeight: FontWeight.w900
                ),
              ),
              verticalSpaceTiny,
              Text(
                'Track all stock purchases',
                style: TextStyle(
                  color: isDark ? Colors.white60 : Colors.black54, 
                  fontWeight: FontWeight.w700
                ),
              ),
            ],
          ),
        ),
        horizontalSpace(12),
        SizedBox(
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
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return SizedBox(
      height: 44,
      child: TextField(
        onChanged: onChanged,
        textAlignVertical: TextAlignVertical.center,
        style: TextStyle(
          color: theme.textTheme.bodyMedium?.color,
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
        decoration: InputDecoration(
          isDense: true,
          prefixIcon: Icon(Icons.search, color: isDark ? Colors.white54 : Colors.black45, size: 20),
          hintText: 'Search by invoice number...',
          hintStyle: TextStyle(
            color: isDark ? Colors.white38 : Colors.black38, 
            fontWeight: FontWeight.w700,
            fontSize: 13,
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 12),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: isDark ? Colors.white24 : Colors.black12, width: 1.6),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Color(0xFF38B24A), width: 1.6),
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
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 26, horizontal: 14),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Center(
        child: Text(
          'No purchases found',
          style: TextStyle(
            color: isDark ? Colors.white60 : Colors.black54, 
            fontSize: 16, 
            fontWeight: FontWeight.w800
          ),
        ),
      ),
    );
  }
}
