import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stacked/stacked.dart';

import 'dashboard_viewmodel.dart';

// Your dashboard widgets
import 'package:nogesoft/ui/views/dashboard/widget/dashboard_kpi_grid.dart';
import 'package:nogesoft/ui/views/dashboard/widget/dashboard_sales_analytics.dart';
import 'package:nogesoft/ui/views/dashboard/widget/dashboard_top_selling.dart';
import 'package:nogesoft/ui/views/dashboard/widget/dashboard_recent_transaction.dart';

class DashboardView extends StackedView<DashboardViewModel> {
  const DashboardView({super.key});

  @override
  Widget builder(BuildContext context, DashboardViewModel viewModel, Widget? child) {
    // This view is "content only" because your AppShell owns the global header/drawer.
    // BUT: it still must provide Material + scrolling for Ink/Dropdown to work safely.

    return Material(
      color: Colors.transparent,
      child: viewModel.isBusy 
          ? const Center(child: CircularProgressIndicator(color: Color(0xFF38B24A))) 
          : SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// ------- TITLE ROW (Dashboard + Refresh button) -------
            Row(
              children: [
                Text(
                  'Dashboard',
                  style: GoogleFonts.redHatDisplay(
                    fontSize: 30,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                  ),
                ),
                const Spacer(),
                SizedBox(
                  height: 42,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF38B24A),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                    ),
                    onPressed: viewModel.refresh,
                    child: Text(
                      'Refresh',
                      style: GoogleFonts.redHatDisplay(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            /// ------- KPI GRID -------
            DashboardKpiGrid(
              stats: viewModel.stats,
              onLowStockTap: viewModel.viewLowStockItems,
            ),

            const SizedBox(height: 16),

            /// ------- SALES ANALYTICS -------
            DashboardSalesAnalytics(
              selectedRange: viewModel.selectedSalesRange,
              ranges: viewModel.salesRanges,
              onRangeChanged: viewModel.setSalesRange,
              spots: viewModel.salesSpots,
              bottomTitles: viewModel.salesBottomTitles,
            ),

            const SizedBox(height: 16),

            /// ------- TOP SELLING -------
            DashboardTopSelling(
              products: viewModel.topSellingProducts,
            ),

            const SizedBox(height: 16),

            /// ------- RECENT TRANSACTIONS -------
            DashboardRecentTransactions(
              transactions: viewModel.recentTransactions,
              onViewAll: viewModel.viewAllTransactions,
            ),
          ],
        ),
      ),
    );
  }

  @override
  void onViewModelReady(DashboardViewModel viewModel) => viewModel.init();

  @override
  DashboardViewModel viewModelBuilder(BuildContext context) => DashboardViewModel();
}
