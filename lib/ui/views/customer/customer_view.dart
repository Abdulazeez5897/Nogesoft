import 'package:flutter/material.dart';
import 'package:nogesoft/ui/views/customer/widget/customer_details_sheet.dart';
import 'package:nogesoft/ui/views/customer/widget/customer_table.dart';
import 'package:nogesoft/ui/views/customer/widget/new_customer_dialog.dart';
import 'package:stacked/stacked.dart';

import 'package:nogesoft/ui/common/ui_helpers.dart';

import 'customer_viewmodel.dart';

class CustomerView extends StackedView<CustomerViewModel> {
  const CustomerView({super.key});

  @override
  Widget builder(BuildContext context, CustomerViewModel viewModel, Widget? child) {
    // AppShell provides PrimaryScrollController; keep this page as a normal scrollable.
    return Material(
      color: Colors.transparent,
      child: CustomScrollView(
        primary: true,
        // physics: const BouncingScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(child: verticalSpace(110)),

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
      ),
    );
  }

  Future<void> _onNewCustomer(BuildContext context, CustomerViewModel viewModel) async {
    final result = await NewCustomerDialog.show(context);
    if (result != null) {
       await viewModel.addCustomer(
        name: result.name,
        address: result.address,
        phone: result.phone,
        initialDebt: result.initialDebt,
      );
    }
  }

  @override
  CustomerViewModel viewModelBuilder(BuildContext context) => CustomerViewModel();

  @override
  void onViewModelReady(CustomerViewModel viewModel) => viewModel.init();
}

class _StatsRow extends StatelessWidget {
  final int allCount;
  final int debtorCount;
  final VoidCallback onNewCustomer;

  const _StatsRow({
    required this.allCount,
    required this.debtorCount,
    required this.onNewCustomer,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Row(
      children: [
        _StatBlock(label: 'All Customers', value: allCount.toString()),
        const Spacer(),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Row(
              children: [
                Text(
                  'Debtors',
                  style: TextStyle(color: isDark ? Colors.white70 : Colors.black54, fontWeight: FontWeight.w700),
                ),
                horizontalSpace(8),
                Text(
                  debtorCount.toString(),
                  style: TextStyle(color: theme.textTheme.bodyMedium?.color, fontWeight: FontWeight.w900),
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
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(color: isDark ? Colors.white70 : Colors.black54, fontWeight: FontWeight.w700),
        ),
        verticalSpace(8),
        Text(
          value,
          style: TextStyle(color: theme.textTheme.bodyMedium?.color, fontSize: 26, fontWeight: FontWeight.w900),
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
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      height: 44,
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(12),
        border: isDark ? null : Border.all(color: Colors.black12),
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
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    // In light mode: selected = dark blue, unselected = grey
    // In dark mode: selected = orange, unselected = white70
    
    final textColor = selected 
        ? (isDark ? const Color(0xFFFFC24A) : Colors.black) 
        : (isDark ? Colors.white70 : Colors.black45);

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
          hintText: 'Search by name or phone...',
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
