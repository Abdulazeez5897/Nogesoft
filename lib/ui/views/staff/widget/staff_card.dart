import 'package:flutter/material.dart';

import '../model/staff_member.dart';
import 'staff_badge.dart';

import 'package:nogesoft/ui/common/ui_helpers.dart';

class StaffCard extends StatelessWidget {
// ...
          _RowKV(
            label: 'User',
            labelColor: textMuted,
            child: Row(
              children: [
                _Avatar(name: member.name),
                horizontalSpace(10),
                Expanded(
                  child: Text(
                    member.name,
                    style: TextStyle(
                      color: textPrimary,
                      fontWeight: FontWeight.w800,
                      fontSize: 16,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          verticalSpace(12),
          _RowKV(
            label: 'Email',
            labelColor: textMuted,
            child: Text(
              member.email,
              style: TextStyle(
                color: textMuted,
                fontWeight: FontWeight.w700,
                fontSize: 14,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          verticalSpace(12),
          _RowKV(
            label: 'Role',
            labelColor: textMuted,
            child: Align(alignment: Alignment.centerRight, child: roleBadge),
          ),
          verticalSpace(12),
          _RowKV(
            label: 'Status',
            labelColor: textMuted,
            child: Align(alignment: Alignment.centerRight, child: statusBadge),
          ),
          verticalSpace(14),

          // Actions: Edit (blue) Delete (red), aligned right
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              GestureDetector(
                onTap: onEdit,
                child: const Text(
                  'Edit',
                  style: TextStyle(
                    color: Color(0xFF2F6BFF),
                    fontWeight: FontWeight.w800,
                    fontSize: 16,
                  ),
                ),
              ),
              horizontalSpace(18),
              GestureDetector(
                onTap: onDelete,
                child: const Text(
                  'Delete',
                // ...
// (Stopping here to keep chunk manageable, will rely on `endLine` to clip the rest correctly or user verify. Actually I should complete the replacement content to match the target content exactly or use ReplaceFileContent on smaller chunks)
                  style: TextStyle(
                    color: Color(0xFFE04B5A),
                    fontWeight: FontWeight.w800,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _roleBadge(StaffMember m, bool isDark) {
    // Matches the vibe from the video: owner neutral, admin blue-ish, staff neutral.
    switch (m.role) {
      case StaffRole.owner:
        return StaffBadge(
          text: m.role.label,
          background: isDark ? Colors.white12 : Colors.black12,
          foreground: isDark ? Colors.white70 : Colors.black87,
        );
      case StaffRole.admin:
        return StaffBadge(
          text: m.role.label,
          background: isDark ? const Color(0xFF1E3A8A) : const Color(0xFFD6E3FF),
          foreground: isDark ? Colors.white : const Color(0xFF1E3A8A),
        );
      case StaffRole.staff:
        return StaffBadge(
          text: m.role.label,
          background: isDark ? Colors.white12 : Colors.black12,
          foreground: isDark ? Colors.white70 : Colors.black87,
        );
    }
  }

  Widget _statusBadge(StaffMember m, bool isDark) {
    switch (m.status) {
      case StaffStatus.active:
        return StaffBadge(
          text: m.status.label,
          background: isDark ? const Color(0xFF0E3B22) : const Color(0xFFD8F4E3),
          foreground: isDark ? const Color(0xFF52E08A) : const Color(0xFF167C3A),
        );
      case StaffStatus.inactive:
        return StaffBadge(
          text: m.status.label,
          background: isDark ? const Color(0xFF3B0E18) : const Color(0xFFFFE0E5),
          foreground: isDark ? const Color(0xFFFF8593) : const Color(0xFFB00020),
        );
    }
  }
}

class _RowKV extends StatelessWidget {
// ...
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: 72,
          child: Text(
            label,
            style: TextStyle(
              color: labelColor,
              fontWeight: FontWeight.w700,
              fontSize: 14,
            ),
          ),
        ),
        horizontalSpace(10),
        Expanded(child: child),
      ],
    );
  }
}

class _Avatar extends StatelessWidget {
  final String name;
  const _Avatar({required this.name});

  String _initials() {
    final parts = name.trim().split(RegExp(r'\s+')).where((e) => e.isNotEmpty).toList();
    if (parts.isEmpty) return '?';
    if (parts.length == 1) return parts.first.characters.take(1).toString().toUpperCase();
    return (parts.first.characters.take(1).toString() +
        parts.last.characters.take(1).toString())
        .toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 16,
      backgroundColor: const Color(0xFF2F6BFF).withOpacity(0.25),
      child: Text(
        _initials(),
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w900,
          fontSize: 12,
        ),
      ),
    );
  }
}
