import 'package:flutter/material.dart';
import 'package:nogesoft/ui/views/reports/widget/product_breakdown_card.dart';
import 'package:nogesoft/ui/views/reports/widget/report_metric_card.dart';
import 'package:nogesoft/ui/views/reports/widget/sales_chart.dart';
import 'package:stacked/stacked.dart';

import '../reports_viewmodel.dart';

import 'package:nogesoft/ui/common/ui_helpers.dart';

class ReportsView extends StackedView<ReportsViewModel> {
  const ReportsView({super.key});
// ...
  @override
  Widget builder(BuildContext context, ReportsViewModel viewModel, Widget? child) {
    // Shell provides PrimaryScrollController; keep this as normal scrollable.
    return Material(
      color: Colors.transparent,
      child: CustomScrollView(
        primary: true,
        // physics: const BouncingScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(child: verticalSpace(108)), // 92 (Header) + 16 (Padding)

          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverToBoxAdapter(
              child: _TopRow(
                title: 'Purchase Report',
                isRefreshing: viewModel.isRefreshing,
                onRefresh: viewModel.refresh,
              ),
            ),
          ),

        SliverToBoxAdapter(child: verticalSpace(14)),

        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          sliver: SliverToBoxAdapter(
            child: _ActionButtonsRow(
              onLatest: viewModel.onLatestPurchase,
              onPdf: viewModel.onExportPdf,
              onCsv: viewModel.onExportCsv,
            ),
          ),
        ),

        SliverToBoxAdapter(child: verticalSpace(18)),

        if (viewModel.statusMessage.isNotEmpty)
          SliverToBoxAdapter(
            child: Center(
              child: Text(
                viewModel.statusMessage,
                style: const TextStyle(color: Colors.white60, fontSize: 18, fontWeight: FontWeight.w700),
              ),
            ),
          ),

        SliverToBoxAdapter(child: verticalSpace(18)),

        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          sliver: SliverGrid(
            delegate: SliverChildBuilderDelegate(
                  (context, index) => ReportMetricCard(metric: viewModel.metrics[index]),
              childCount: viewModel.metrics.length,
            ),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 14,
              crossAxisSpacing: 14,
              childAspectRatio: 1.55,
            ),
          ),
        ),

        SliverToBoxAdapter(child: verticalSpace(18)),

        if (viewModel.weeklySales.isNotEmpty) ...[
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverToBoxAdapter(
             child: SalesChart(weeklySales: viewModel.weeklySales),
            ),
          ),
          SliverToBoxAdapter(child: verticalSpace(18)),
        ],

        SliverPadding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 22),
          sliver: SliverToBoxAdapter(
            child: ProductBreakdownCard(
              query: viewModel.productQuery,
              onQueryChanged: viewModel.setProductQuery,
              item: viewModel.selectedProduct,
              isDark: Theme.of(context).brightness == Brightness.dark,
            ),
          ),
        ),
      ],
      ),
    );
  }

  @override
  void onViewModelReady(ReportsViewModel viewModel) => viewModel.init();

  @override
  ReportsViewModel viewModelBuilder(BuildContext context) => ReportsViewModel();
}

class _TopRow extends StatelessWidget {
  final String title;
  final bool isRefreshing;
  final Future<void> Function() onRefresh;

  const _TopRow({
    required this.title,
    required this.isRefreshing,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 26,
            fontWeight: FontWeight.w900,
          ),
        ),
        const Spacer(),
        SizedBox(
          height: 44,
          child: ElevatedButton(
            onPressed: isRefreshing ? null : onRefresh,
            style: ElevatedButton.styleFrom(
              elevation: 0,
              backgroundColor: const Color(0xFF38B24A),
              disabledBackgroundColor: const Color(0xFF2D7E39),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              padding: const EdgeInsets.symmetric(horizontal: 18),
            ),
            child: isRefreshing
                ? const Row(
              children: [
                SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                ),
                SizedBox(width: 10),
                Text('Refresh', style: TextStyle(fontWeight: FontWeight.w900)),
              ],
            )
                : const Text('Refresh', style: TextStyle(fontWeight: FontWeight.w900)),
          ),
        ),
      ],
    );
  }
}

class _ActionButtonsRow extends StatelessWidget {
  final VoidCallback onLatest;
  final VoidCallback onPdf;
  final VoidCallback onCsv;

  const _ActionButtonsRow({
    required this.onLatest,
    required this.onPdf,
    required this.onCsv,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _OutlineButton(
            label: 'Latest Purchase',
            borderColor: Colors.white24,
            textColor: Colors.white70,
            onTap: onLatest,
            // no minWidth here
          ),
        ),
        horizontalSpace(12),

        SizedBox(
          width: 86,
          child: _OutlineButton(
            label: 'PDF',
            borderColor: const Color(0xFFFFC24A),
            textColor: const Color(0xFFFFC24A),
            onTap: onPdf,
            // no minWidth here
          ),
        ),
        horizontalSpace(12),

        SizedBox(
          width: 86,
          child: _OutlineButton(
            label: 'CSV',
            borderColor: const Color(0xFFFFC24A),
            textColor: const Color(0xFFFFC24A),
            onTap: onCsv,
            // no minWidth here
          ),
        ),
      ],
    );
  }

}

class _OutlineButton extends StatelessWidget {
  final String label;
  final Color borderColor;
  final Color textColor;
  final VoidCallback onTap;

  const _OutlineButton({
    required this.label,
    required this.borderColor,
    required this.textColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 44,
      child: OutlinedButton(
        onPressed: onTap,
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: borderColor, width: 1.6),
          foregroundColor: textColor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          padding: const EdgeInsets.symmetric(horizontal: 16),
        ),
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(label, style: const TextStyle(fontWeight: FontWeight.w900)),
        ),
      ),
    );
  }
}
