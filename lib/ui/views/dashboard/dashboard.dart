import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stacked/stacked.dart';

import 'dashboardViewModel.dart';

// Your dashboard widgets
import 'package:nogesoft/ui/views/dashboard/widget/dashboard_kpi_grid.dart';
import 'package:nogesoft/ui/views/dashboard/widget/dashboard_sales_analytics.dart';
import 'package:nogesoft/ui/views/dashboard/widget/dashboard_top_selling.dart';
import 'package:nogesoft/ui/views/dashboard/widget/dashboard_recent_transaction.dart';

class DashboardView extends StackedView<DashboardViewModel> {
  const DashboardView({super.key});

  @override
  Widget builder(BuildContext context, DashboardViewModel viewModel, Widget? child) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      endDrawer: const _DashboardDrawer(),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF0B1220), Color(0xFF0F1B2D)],
          ),
        ),
        child: SafeArea(
          bottom: false,
          child: Builder(
            // ✅ Builder gives a context under this Scaffold so openEndDrawer works
            builder: (scaffoldContext) {
              return CustomScrollView(
                slivers: [
                  /// ✅ ONE pinned header (flat at top, rounded when scrolled)
                  SliverPersistentHeader(
                    pinned: true,
                    delegate: _NogesoftHeaderDelegate(
                      height: 70,
                      onMoonPressed: viewModel.toggleThemeIcon,
                      onMenuPressed: () => Scaffold.of(scaffoldContext).openEndDrawer(),
                    ),
                  ),

                  /// ---------------- CONTENT ----------------
                  const SliverToBoxAdapter(child: SizedBox(height: 16)),

                  const SliverPadding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    sliver: SliverToBoxAdapter(child: DashboardKpiGrid()),
                  ),

                  const SliverToBoxAdapter(child: SizedBox(height: 16)),

                  /// ❌ NOT const (needs viewModel values)
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    sliver: SliverToBoxAdapter(
                      child: DashboardSalesAnalytics(
                        selectedRange: viewModel.selectedPeriodLabel,
                        ranges: viewModel.periodRanges,
                        onRangeChanged: viewModel.setPeriodRange,
                      ),
                    ),
                  ),

                  const SliverToBoxAdapter(child: SizedBox(height: 16)),

                  const SliverPadding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    sliver: SliverToBoxAdapter(child: DashboardTopSelling()),
                  ),

                  const SliverToBoxAdapter(child: SizedBox(height: 16)),

                  SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    sliver: SliverToBoxAdapter(
                      child: DashboardRecentTransactions(
                        onViewAll: viewModel.viewAllTransactions,
                      ),
                    ),
                  ),


                  const SliverToBoxAdapter(child: SizedBox(height: 24)),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  @override
  DashboardViewModel viewModelBuilder(BuildContext context) => DashboardViewModel();
}

/// Drawer
class _DashboardDrawer extends StatelessWidget {
  const _DashboardDrawer();

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: const Color(0xFF0C1524),
      child: SafeArea(
        child: Column(
          children: [
            /// ---------------- MENU LIST ----------------
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  Text(
                    'Menu',
                    style: GoogleFonts.redHatDisplay(
                      color: Colors.white,
                      fontSize: 25,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 12),

                  ListTile(
                    title: const Text('Home', style: TextStyle(color: Colors.white)),
                    onTap: () => Navigator.pop(context),
                  ),
                  ListTile(
                    title: const Text('Store', style: TextStyle(color: Colors.white)),
                    onTap: () => Navigator.pop(context),
                  ),
                  ListTile(
                    title: const Text('Report', style: TextStyle(color: Colors.white)),
                    onTap: () => Navigator.pop(context),
                  ),
                  ListTile(
                    title: const Text('Customer', style: TextStyle(color: Colors.white)),
                    onTap: () => Navigator.pop(context),
                  ),
                  ListTile(
                    title: const Text('Purchase', style: TextStyle(color: Colors.white)),
                    onTap: () => Navigator.pop(context),
                  ),
                  ListTile(
                    title: const Text('Staff', style: TextStyle(color: Colors.white)),
                    onTap: () => Navigator.pop(context),
                  ),
                  ListTile(
                    title: const Text('My Profile', style: TextStyle(color: Colors.white)),
                    onTap: () => Navigator.pop(context),
                  ),
                  ListTile(
                    title: const Text('My Business', style: TextStyle(color: Colors.white)),
                    onTap: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),

            /// ---------------- LOGOUT BUTTON ----------------
            Padding(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                width: double.infinity,
                height: 48,
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    // TODO: call logout logic here
                  },
                  style: OutlinedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    side: const BorderSide(
                      color: Color(0xFFFFD54A), // yellow border
                      width: 1.4,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'Logout',
                    style: GoogleFonts.redHatDisplay(
                      color: const Color(0xFFFFD54A), // yellow text
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// ✅ Pinned header delegate: flat at top, rounded when scrolled
class _NogesoftHeaderDelegate extends SliverPersistentHeaderDelegate {
  final double height;
  final VoidCallback onMoonPressed;
  final VoidCallback onMenuPressed;

  _NogesoftHeaderDelegate({
    required this.height,
    required this.onMoonPressed,
    required this.onMenuPressed,
  });

  @override
  double get minExtent => height;

  @override
  double get maxExtent => height;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    // ✅ With fixed height headers, overlapsContent is the reliable signal
    final bool isScrolled = overlapsContent;

    return SizedBox.expand(
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOut,
        decoration: BoxDecoration(
          color: const Color(0xFF0C1524),
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(isScrolled ? 22 : 0),
          ),
          boxShadow: isScrolled
              ? [
            BoxShadow(
              color: Colors.black.withOpacity(0.35),
              blurRadius: 18,
              offset: const Offset(0, 10),
            )
          ]
              : const [],
        ),
        child: SafeArea(
          bottom: false,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Text(
                  'Nogesoft',
                  style: GoogleFonts.redHatDisplay(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                const Spacer(),

                Container(
                  margin: const EdgeInsets.only(right: 10),
                  decoration: BoxDecoration(
                    color: const Color(0xFF111C2E),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: IconButton(
                    onPressed: onMoonPressed,
                    icon: const Icon(
                      Icons.nights_stay_rounded,
                      color: Color(0xFFFFD54A),
                    ),
                  ),
                ),

                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF111C2E),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: IconButton(
                    onPressed: onMenuPressed,
                    icon: const Icon(Icons.menu, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  bool shouldRebuild(covariant _NogesoftHeaderDelegate oldDelegate) {
    // ✅ If callbacks change, rebuild
    return oldDelegate.height != height ||
        oldDelegate.onMoonPressed != onMoonPressed ||
        oldDelegate.onMenuPressed != onMenuPressed;
  }
}
