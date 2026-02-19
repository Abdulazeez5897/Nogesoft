import 'package:flutter/material.dart';
import 'package:nogesoft/ui/views/staff/widget/staff_card.dart';
import 'package:nogesoft/ui/views/staff/widget/staff_form.dart';
import 'package:stacked/stacked.dart';

import 'model/staff_member.dart';
import 'staff_viewmodel.dart';

import 'package:nogesoft/ui/common/ui_helpers.dart';

class StaffView extends StackedView<StaffViewModel> {
  const StaffView({super.key});

  @override
  Widget builder(BuildContext context, StaffViewModel viewModel, Widget? child) {
    // Important: AppShell provides PrimaryScrollController so this scroll drives the global header.
    // Important: AppShell provides PrimaryScrollController so this scroll drives the global header.
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
              child: _TopRow(
                onAdd: () => _openAddDialog(context, viewModel),
              ),
            ),
          ),

          SliverToBoxAdapter(child: verticalSpace(14)),

          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 22),
            sliver: viewModel.staff.isEmpty
                ? const SliverToBoxAdapter(child: _EmptyState())
                : SliverList.separated(
              itemCount: viewModel.staff.length,
              separatorBuilder: (_, __) => verticalSpace(14),
              itemBuilder: (_, i) {
                final m = viewModel.staff[i];
                return StaffCard(
                  member: m,
                  onEdit: () => _openEditDialog(context, viewModel, m),
                  onDelete: () => _delete(context, viewModel, m.id),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _openAddDialog(BuildContext context, StaffViewModel vm) {
    return StaffFormDialog.show(
      context,
      title: 'Add Staff',
      isSaving: vm.isSaving,
      onSubmit: (result) async {
        await vm.addStaff(
          name: result.name,
          email: result.email,
          password: result.password,
          role: result.role,
          status: result.status,
          isAdmin: result.isAdmin,
          pickedFileName: result.fileName,
          imageFile: result.imageFile,
        );
      },
    );
  }

  Future<void> _openEditDialog(BuildContext context, StaffViewModel vm, StaffMember member) {
    return StaffFormDialog.show(
      context,
      title: 'Edit Staff',
      isSaving: vm.isSaving,
      initialName: member.name,
      initialEmail: member.email,
      initialRole: member.role,
      initialStatus: member.status,
      initialIsAdmin: member.isAdmin,
      onSubmit: (result) async {
        await vm.updateStaff(
          member.copyWith(
            name: result.name,
            email: result.email,
            role: result.role,
            status: result.status,
            isAdmin: result.isAdmin,
          ),
        );
      },
    );
  }

  Future<void> _delete(BuildContext context, StaffViewModel vm, String id) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF0E1626),
        title: const Text('Delete Staff', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        content: const Text(
          'Are you sure you want to delete this staff member?',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Cancel', style: TextStyle(color: Colors.white60)),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Delete', style: TextStyle(color: Color(0xFFE04B5A), fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      vm.deleteStaff(id);
    }
  }

  @override
  void onViewModelReady(StaffViewModel viewModel) => viewModel.init();

  @override
  StaffViewModel viewModelBuilder(BuildContext context) => StaffViewModel();
}

class _TopRow extends StatelessWidget {
  final VoidCallback onAdd;
  const _TopRow({required this.onAdd});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Row(
      children: [
        Text(
          'Staff & Users',
          style: TextStyle(
            color: theme.textTheme.titleLarge?.color,
            fontSize: 24,
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
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              padding: const EdgeInsets.symmetric(horizontal: 16),
            ),
            child: const Text(
              '+ Add Staff',
              style: TextStyle(fontWeight: FontWeight.w900),
            ),
          ),
        ),
      ],
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
          'No staff found',
          style: TextStyle(
            color: isDark ? Colors.white60 : Colors.black54,
            fontSize: 16,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }
}
