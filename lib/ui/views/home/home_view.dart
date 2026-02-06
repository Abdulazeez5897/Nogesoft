

import 'package:flutter/material.dart';
import 'package:nogesoft/ui/views/my_business/my_business_view.dart';
import 'package:nogesoft/ui/views/profile/profile_view.dart';
import 'package:nogesoft/ui/views/purchase/purchase_view.dart';
import 'package:nogesoft/ui/views/reports/widget/report_view.dart';
import 'package:nogesoft/ui/views/staff/staff_view.dart';
import 'package:nogesoft/ui/views/store/store_view.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import '../../../app/app.locator.dart';
import '../../../app/app.router.dart';
import '../../common/ui_helpers.dart';
import '../customer/customer_view.dart';
import 'home_viewmodel.dart';


// Pages
import '../dashboard/dashboard.dart';


// Global header widget
import 'widget/global_header.dart';

class HomeView extends StackedView<HomeViewModel> {
  const HomeView({super.key});

  @override
  Widget builder(
      BuildContext context,
      HomeViewModel viewModel,
      Widget? child,
      ) {
    return _CollapsingShellScaffold(viewModel: viewModel);
  }

  @override
  HomeViewModel viewModelBuilder(BuildContext context) =>
      HomeViewModel();
}

/// A stateful shell that keeps:
/// - ONE pinned header
/// - IndexedStack pages
/// - scroll-driven collapse (t: 0.0 -> 1.0)
class _CollapsingShellScaffold extends StatefulWidget {
  final HomeViewModel viewModel;

  const _CollapsingShellScaffold({required this.viewModel});

  @override
  State<_CollapsingShellScaffold> createState() =>
      _CollapsingShellScaffoldState();
}

class _CollapsingShellScaffoldState extends State<_CollapsingShellScaffold> {
  // Tune these to match the video feel
  static const double _expandedHeaderHeight = 92;
  static const double _collapsedHeaderHeight = 80;

  // How much scroll (in px) drives collapse from 0 -> 1.
  // Usually: expanded - collapsed + a little buffer for smoother feel.
  static const double _collapseRange = 28;

  // Snap behavior
  static const Duration _snapDuration = Duration(milliseconds: 180);
  static const Curve _snapCurve = Curves.easeOutCubic;

  late final List<ScrollController> _pageControllers;
  int _activeIndex = 0;

  // Collapse progress notifier (0 expanded -> 1 collapsed)
  final ValueNotifier<double> _t = ValueNotifier<double>(0);

  @override
  void initState() {
    super.initState();

    _activeIndex = widget.viewModel.pageIndex;

    _pageControllers = List.generate(
      AppShellPage.values.length,
          (_) => ScrollController(),
    );

    // Keep header synced even if page changes via viewModel update.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _syncActiveIndexFromViewModel();
      _updateCollapseFromController();
    });
  }

  @override
  void didUpdateWidget(covariant _CollapsingShellScaffold oldWidget) {
    super.didUpdateWidget(oldWidget);
    _syncActiveIndexFromViewModel();
  }

  @override
  void dispose() {
    for (final c in _pageControllers) {
      c.dispose();
    }
    _t.dispose();
    super.dispose();
  }

  void _syncActiveIndexFromViewModel() {
    final idx = widget.viewModel.pageIndex;
    if (_activeIndex != idx) {
      setState(() => _activeIndex = idx);
      _updateCollapseFromController();
    }
  }

  ScrollController get _activeController => _pageControllers[_activeIndex];

  void _updateCollapseFromController() {
    if (!_activeController.hasClients) {
      _t.value = 0;
      return;
    }
    final pixels = _activeController.position.pixels;
    _t.value = _pixelsToT(pixels);
  }

  double _pixelsToT(double pixels) {
    // Collapse starts immediately as you scroll down.
    final raw = pixels / _collapseRange;
    return raw.clamp(0.0, 1.0);
  }

  bool _onScrollNotification(ScrollNotification n, int pageIndex) {
    // Ignore notifications from inactive pages (IndexedStack keeps them alive).
    if (pageIndex != _activeIndex) return false;
    if (n.metrics.axis != Axis.vertical) return false;

    if (n is ScrollUpdateNotification || n is OverscrollNotification) {
      _t.value = _pixelsToT(n.metrics.pixels);
    }

    // Snap on scroll end (bonus)
    if (n is ScrollEndNotification) {
      _snapHeaderIfNeeded();
    }

    return false;
  }

  void _snapHeaderIfNeeded() {
    final controller = _activeController;
    if (!controller.hasClients) return;

    final position = controller.position;

    // If user is at top (or overscrolling), don't snap.
    if (position.pixels <= 0) {
      _t.value = 0;
      return;
    }

    final t = _t.value;
    final targetPixels = (t >= 0.5) ? _collapseRange : 0.0;

    // Only snap if we're not already basically there.
    if ((position.pixels - targetPixels).abs() < 2) return;

    // Clamp to valid scroll range to avoid exceptions.
    final minPx = position.minScrollExtent;
    final maxPx = position.maxScrollExtent;
    final clamped = targetPixels.clamp(minPx, maxPx);

    controller.animateTo(
      clamped,
      duration: _snapDuration,
      curve: _snapCurve,
    );
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = widget.viewModel;
    final isDark = viewModel.isDarkMode;

    // Keep current index synced with VM (in case VM updated by drawer).
    _syncActiveIndexFromViewModel();

    return Material(
      color: Colors.transparent,
      child: Scaffold(
        backgroundColor: const Color(0xFF0B1220),
        endDrawer: _AppDrawer(viewModel: viewModel),
        body: SafeArea(
          bottom: false,
          child: Column(
            children: [
              // ✅ Pinned, animated global header (only this rebuilds on scroll)
              ValueListenableBuilder<double>(
                valueListenable: _t,
                builder: (_, t, __) {
                  return Builder(
                    builder: (ctx) => GlobalHeader(
                      isDarkMode: isDark,
                      t: t,
                      expandedHeight: _expandedHeaderHeight,
                      collapsedHeight: _collapsedHeaderHeight,
                      onToggleTheme: viewModel.toggleTheme,
                      onOpenDrawer: () => Scaffold.of(ctx).openEndDrawer(),
                    ),
                  );
                },
              ),

              // ✅ Only page content scrolls
              Expanded(
                child: IndexedStack(
                  index: _activeIndex,
                  children: [
                    _ShellPageHost(
                      controller: _pageControllers[0],
                      onScrollNotification: (n) => _onScrollNotification(n, 0),
                      child: const DashboardView(),
                    ),
                    _ShellPageHost(
                      controller: _pageControllers[1],
                      onScrollNotification: (n) => _onScrollNotification(n, 1),
                      child: const StoreView(),
                    ),
                    _ShellPageHost(
                      controller: _pageControllers[2],
                      onScrollNotification: (n) => _onScrollNotification(n, 2),
                      child: const ReportsView()
                    ),
                    _ShellPageHost(
                      controller: _pageControllers[3],
                      onScrollNotification: (n) => _onScrollNotification(n, 3),
                      child: const CustomerView()
                    ),
                    _ShellPageHost(
                      controller: _pageControllers[4],
                      onScrollNotification: (n) => _onScrollNotification(n, 4),
                      child: const PurchaseView()
                    ),
                    _ShellPageHost(
                      controller: _pageControllers[5],
                      onScrollNotification: (n) => _onScrollNotification(n, 5),
                      child: const StaffView(),
                    ),
                    _ShellPageHost(
                      controller: _pageControllers[6],
                      onScrollNotification: (n) => _onScrollNotification(n, 6),
                      child: const ProfileView(),
                    ),
                    _ShellPageHost(
                      controller: _pageControllers[7],
                      onScrollNotification: (n) => _onScrollNotification(n, 7),
                      child: const MyBusinessView(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Provides a PrimaryScrollController for a page and forwards scroll notifications.
/// This is the clean pattern that lets each page stay “normal” (ListView etc.) while
/// the shell reacts globally.
class _ShellPageHost extends StatelessWidget {
  final ScrollController controller;
  final Widget child;
  final bool Function(ScrollNotification) onScrollNotification;

  const _ShellPageHost({
    required this.controller,
    required this.child,
    required this.onScrollNotification,
  });

  @override
  Widget build(BuildContext context) {
    return PrimaryScrollController(
      controller: controller,
      child: NotificationListener<ScrollNotification>(
        onNotification: onScrollNotification,
        child: child,
      ),
    );
  }
}

/// Simple placeholder so enum/page count matches IndexedStack.
/// Not a redesign; just prevents crashes/mismatch.


/// ---------------- DRAWER ----------------
class _AppDrawer extends StatelessWidget {
  _AppDrawer({required this.viewModel});

  final HomeViewModel viewModel;
  final NavigationService _nav = locator<NavigationService>();

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: const Color(0xFF0C1524),
      child: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  const Text(
                    'Menu',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  verticalSpace(16),

                  _drawerItem(
                    context: context,
                    title: 'Home',
                    selected: viewModel.page == AppShellPage.home,
                    onTap: () => _setPage(context, AppShellPage.home),
                  ),
                  _drawerItem(
                    context: context,
                    title: 'Store',
                    selected: viewModel.page == AppShellPage.store,
                    onTap: () => _setPage(context, AppShellPage.store),
                  ),
                  _drawerItem(
                    context: context,
                    title: 'Report',
                    selected: viewModel.page == AppShellPage.report,
                    onTap: () => _setPage(context, AppShellPage.report),
                  ),
                  _drawerItem(
                    context: context,
                    title: 'Customer',
                    selected: viewModel.page == AppShellPage.customer,
                    onTap: () => _setPage(context, AppShellPage.customer),
                  ),
                  _drawerItem(
                    context: context,
                    title: 'Purchase',
                    selected: viewModel.page == AppShellPage.purchase,
                    onTap: () => _setPage(context, AppShellPage.purchase),
                  ),
                  _drawerItem(
                    context: context,
                    title: 'Staff',
                    selected: viewModel.page == AppShellPage.staff,
                    onTap: () => _setPage(context, AppShellPage.staff),
                  ),
                  _drawerItem(
                    context: context,
                    title: 'My Profile',
                    selected: viewModel.page == AppShellPage.profile,
                    onTap: () => _setPage(context, AppShellPage.profile),
                  ),
                  _drawerItem(
                    context: context,
                    title: 'My Business',
                    selected: viewModel.page == AppShellPage.business,
                    onTap: () => _setPage(context, AppShellPage.business),
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: _logoutButton(
                onTap: () {
                  Navigator.of(context).pop();
                  _nav.clearStackAndShow(Routes.loginView);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _setPage(BuildContext context, AppShellPage page) {
    Navigator.of(context).pop();
    viewModel.setPage(page);
  }

  Widget _drawerItem({
    required BuildContext context,
    required String title,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return Material(
      color: selected ? const Color(0xFF111C2E) : Colors.transparent,
      borderRadius: BorderRadius.circular(12),
      child: ListTile(
        onTap: onTap,
        title: Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  Widget _logoutButton({required VoidCallback onTap}) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Container(
          height: 54,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: const Color(0xFFFFD54A),
              width: 1.6,
            ),
          ),
          child: const Text(
            'Logout',
            style: TextStyle(
              color: Color(0xFFFFD54A),
              fontSize: 16,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.3,
            ),
          ),
        ),
      ),
    );
  }
}
