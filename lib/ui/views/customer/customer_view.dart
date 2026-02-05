import 'package:flutter/material.dart';
import 'package:nogesoft/ui/views/customer/widget/customer_details_sheet.dart';
import 'package:nogesoft/ui/views/customer/widget/customer_table.dart';
import 'package:nogesoft/ui/views/customer/widget/new_customer_dialog.dart';
import 'package:stacked/stacked.dart';

import 'package:nogesoft/ui/common/ui_helpers.dart';

import 'customer_viewmodel.dart';
// ...
// Replace builder content
  @override
  Widget builder(BuildContext context, CustomerViewModel viewModel, Widget? child) {
    // AppShell provides PrimaryScrollController; keep this page as a normal scrollable.
    return CustomScrollView(
      primary: true,
      physics: const BouncingScrollPhysics(),
      slivers: [
        SliverToBoxAdapter(child: verticalSpace(18)),

        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          sliver: SliverToBoxAdapter(
            child: _StatsRow(
              allCount: viewModel.allCount,
              debtorCount: viewModel.debtorCount,
              onNewCustomer: () => _onNewCustomer(context, viewModel),
            ),
          ),
        ),

        SliverToBoxAdapter(child: verticalSpace(12)),

        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          sliver: SliverToBoxAdapter(
            child: _SegmentedTabs(
              tab: viewModel.tab,
              onTab: viewModel.setTab,
            ),
          ),
        ),

        SliverToBoxAdapter(child: verticalSpace(10)),

        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          sliver: SliverToBoxAdapter(
            child: _SearchField(
              onChanged: viewModel.setQuery,
            ),
          ),
        ),

        SliverToBoxAdapter(child: verticalSpace(12)),

        SliverPadding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 22),
          sliver: SliverToBoxAdapter(
            child: CustomerTable(
              customers: viewModel.visibleCustomers,
              onView: (c) => CustomerDetailsSheet.show(context, c),
            ),
          ),
        ),
      ],
    );
  }
// ...
// Replace _StatsRow
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _StatBlock(label: 'All Customers', value: allCount.toString()),
        const Spacer(),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Row(
              children: [
                const Text(
                  'Debtors',
                  style: TextStyle(color: Colors.white70, fontWeight: FontWeight.w700),
                ),
                horizontalSpace(8),
                Text(
                  debtorCount.toString(),
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900),
                ),
              ],
            ),
            verticalSpace(10),
            SizedBox(
              height: 42,
              child: ElevatedButton(
                onPressed: onNewCustomer,
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  backgroundColor: const Color(0xFF38B24A),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                ),
                child: const Text(
                  '+ New Customer',
                  style: TextStyle(fontWeight: FontWeight.w900),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _StatBlock extends StatelessWidget {
  final String label;
  final String value;

  const _StatBlock({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(color: Colors.white70, fontWeight: FontWeight.w700),
        ),
        verticalSpace(8),
        Text(
          value,
          style: const TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.w900),
        ),
      ],
    );
  }
}

class _SegmentedTabs extends StatelessWidget {
  final CustomerTab tab;
  final ValueChanged<CustomerTab> onTab;

  const _SegmentedTabs({required this.tab, required this.onTab});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44,
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: const Color(0xFF101A2B),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          _SegItem(
            label: 'All Customers',
            selected: tab == CustomerTab.all,
            onTap: () => onTab(CustomerTab.all),
          ),
          _SegItem(
            label: 'Debtors',
            selected: tab == CustomerTab.debtors,
            onTap: () => onTab(CustomerTab.debtors),
          ),
        ],
      ),
    );
  }
}

class _SegItem extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _SegItem({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final textColor = selected ? const Color(0xFFFFC24A) : Colors.white70;

    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: textColor,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
      ),
    );
  }
}

class _SearchField extends StatelessWidget {
  final ValueChanged<String> onChanged;

  const _SearchField({required this.onChanged});

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
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(
            border: InputBorder.none,
            hintText: 'Search by name or phone...',
            hintStyle: TextStyle(color: Colors.white38, fontWeight: FontWeight.w700),
          ),
        ),
      ),
    );
  }
}
