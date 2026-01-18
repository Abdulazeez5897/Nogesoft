import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stacked/stacked.dart';

import 'dashboardViewModel.dart';


class DashboardView extends StackedView<DashboardViewModel> {
  const DashboardView({super.key});

  @override
  Widget builder(BuildContext context, DashboardViewModel viewModel,
      Widget? child,
      ) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF0B1220),
              Color(0xFF0F1B2D),
            ],
          ),
        ),
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFF0B1220),
                Color(0xFF0F1B2D),
              ],
            ),
          ),
        ),
      ),

    );
  }

  @override
  DashboardViewModel viewModelBuilder(BuildContext context) =>
      DashboardViewModel();
}
class _Header extends StatelessWidget {
  final DashboardViewModel viewModel;

  const _Header(this.viewModel);

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            const CircleAvatar(radius: 22),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                '${viewModel.newJobsCount} new remote roles match you',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            IconButton(
              icon: const Icon(Icons.notifications_none),
              onPressed: () {},
            )
          ],
        ),
      ),
    );
  }
}
class _QuickActions extends StatelessWidget {
  final DashboardViewModel viewModel;

  const _QuickActions(this.viewModel);

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _ActionItem(
              icon: Icons.search,
              label: 'Find Jobs',
              onTap: viewModel.navigateToJobs,
            ),
            _ActionItem(
              icon: Icons.person_outline,
              label: 'Profile ${viewModel.profileCompletion}%',
              onTap: viewModel.navigateToProfile,
            ),
            _ActionItem(
              icon: Icons.track_changes,
              label: 'Applications',
              onTap: viewModel.navigateToApplications,
            ),
          ],
        ),
      ),
    );
  }
}
class _ActionItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _ActionItem({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Column(
        children: [
          CircleAvatar(
            radius: 24,
            child: Icon(icon),
          ),
          const SizedBox(height: 6),
          Text(label, style: Theme.of(context).textTheme.bodySmall),
        ],
      ),
    );
  }
}
class _RecommendedJobs extends StatelessWidget {
  final DashboardViewModel viewModel;

  const _RecommendedJobs(this.viewModel);

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.all(16),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          childCount: viewModel.recommendedJobs.length,
              (context, index) {
            final job = viewModel.recommendedJobs[index];
            return _JobCard(job);
          },
        ),
      ),
    );
  }
}
class _JobCard extends StatelessWidget {
  final JobItem job;

  const _JobCard(this.job);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(job.title, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 4),
            Text('${job.company} • ${job.location}',
                style: Theme.of(context).textTheme.bodySmall),
            const SizedBox(height: 8),
            Row(
              children: [
                Chip(label: Text(job.type)),
                const SizedBox(width: 8),
                Chip(label: Text(job.salary)),
                const Spacer(),
                const Icon(Icons.bookmark_border),
              ],
            )
          ],
        ),
      ),
    );
  }
}


