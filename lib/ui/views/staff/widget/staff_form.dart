import 'package:flutter/material.dart';

import 'package:nogesoft/ui/common/ui_helpers.dart';
import '../model/staff_member.dart';

class StaffFormResult {
  final String name;
  final String email;
  final String password;
  final StaffRole role;
  final StaffStatus status;
  final bool isAdmin;
  final String? fileName;

  const StaffFormResult({
    required this.name,
    required this.email,
    required this.password,
    required this.role,
    required this.status,
    required this.isAdmin,
    this.fileName,
  });
}

class StaffFormDialog extends StatefulWidget {
  final String title;
  final String? initialName;
  final String? initialEmail;
  final StaffRole initialRole;
  final StaffStatus initialStatus;
  final bool initialIsAdmin;

  final bool isSaving;
  final Future<void> Function(StaffFormResult result) onSubmit;

  const StaffFormDialog({
    super.key,
    required this.title,
    required this.onSubmit,
    required this.isSaving,
    this.initialName,
    this.initialEmail,
    this.initialRole = StaffRole.staff,
    this.initialStatus = StaffStatus.active,
    this.initialIsAdmin = false,
  });

  static Future<void> show(
      BuildContext context, {
        required String title,
        required bool isSaving,
        required Future<void> Function(StaffFormResult result) onSubmit,
        String? initialName,
        String? initialEmail,
        StaffRole initialRole = StaffRole.staff,
        StaffStatus initialStatus = StaffStatus.active,
        bool initialIsAdmin = false,
      }) {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (_) => StaffFormDialog(
        title: title,
        isSaving: isSaving,
        onSubmit: onSubmit,
        initialName: initialName,
        initialEmail: initialEmail,
        initialRole: initialRole,
        initialStatus: initialStatus,
        initialIsAdmin: initialIsAdmin,
      ),
    );
  }

  @override
  State<StaffFormDialog> createState() => _StaffFormDialogState();
}

class _StaffFormDialogState extends State<StaffFormDialog> {
  late final TextEditingController _name;
  late final TextEditingController _email;
  late final TextEditingController _password;

  bool _obscure = true;
  bool _isAdmin = false;

  StaffRole _role = StaffRole.staff;
  StaffStatus _status = StaffStatus.active;

  String? _fileName;

  @override
  void initState() {
    super.initState();
    _name = TextEditingController(text: widget.initialName ?? '');
    _email = TextEditingController(text: widget.initialEmail ?? '');
    _password = TextEditingController();
    _role = widget.initialRole;
    _status = widget.initialStatus;
    _isAdmin = widget.initialIsAdmin;
  }

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  InputDecoration _dec(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: Colors.white38, fontWeight: FontWeight.w700),
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Colors.white10),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Color(0xFF2F6BFF), width: 2),
      ),
    );
  }

  Future<void> _submit() async {
    final name = _name.text.trim();
    final email = _email.text.trim();
    final pass = _password.text;

    if (name.isEmpty || email.isEmpty) return;

    await widget.onSubmit(
      StaffFormResult(
        name: name,
        email: email,
        password: pass,
        role: _role,
        status: _status,
        isAdmin: _isAdmin,
        fileName: _fileName,
      ),
    );

    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    // Match the video: dark modal with rounded corners.
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 22),
      backgroundColor: const Color(0xFF0E1626),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 14),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
// ... Inside build method
            Row(
              children: [
                Expanded(
                  child: Text(
                    widget.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ],
            ),
            verticalSpace(12),

            TextField(
              controller: _name,
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
              decoration: _dec('Name'),
              textInputAction: TextInputAction.next,
            ),
            verticalSpace(10),

            TextField(
              controller: _email,
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
              decoration: _dec('Email'),
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
            ),
            verticalSpace(10),

            TextField(
              controller: _password,
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
              decoration: _dec('Password').copyWith(
                suffixIcon: IconButton(
                  onPressed: () => setState(() => _obscure = !_obscure),
                  icon: Icon(
                    _obscure ? Icons.visibility : Icons.visibility_off,
                    color: Colors.white54,
                  ),
                ),
              ),
              obscureText: _obscure,
              textInputAction: TextInputAction.done,
            ),
            verticalSpace(10),

            _DropdownRow(
              value: _role,
              labelBuilder: (r) => r.label,
              items: StaffRole.values,
              onChanged: (v) => setState(() => _role = v),
            ),
            verticalSpace(10),

            _DropdownRow(
              value: _status,
              labelBuilder: (s) => s.label,
              items: StaffStatus.values,
              onChanged: (v) => setState(() => _status = v),
            ),

            verticalSpace(10),

            Row(
              children: [
                Checkbox(
                  value: _isAdmin,
                  onChanged: (v) => setState(() => _isAdmin = v ?? false),
                  side: const BorderSide(color: Colors.white54),
                  activeColor: const Color(0xFF38B24A),
                ),
                const Text(
                  'Is Admin',
                  style: TextStyle(color: Colors.white70, fontWeight: FontWeight.w700),
                ),
              ],
            ),

            // File picker row shown in video (UI only)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white10),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  SizedBox(
                    height: 36,
                    child: OutlinedButton(
                      onPressed: () {
                        // Video shows a file chosen; we keep UI only (no actual picker requested).
                        setState(() => _fileName = 'IMG_0318.jpeg');
                      },
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.white24),
                        foregroundColor: Colors.white70,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      child: const Text('Choose File'),
                    ),
                  ),
                  horizontalSpace(10),
                  Expanded(
                    child: Text(
                      _fileName ?? 'no file selected',
                      style: const TextStyle(color: Colors.white60, fontWeight: FontWeight.w700),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),

            verticalSpace(14),

            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SizedBox(
                  height: 44,
                  child: ElevatedButton(
                    onPressed: widget.isSaving ? null : () => Navigator.of(context).pop(),
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      backgroundColor: const Color(0xFF141E31),
                      foregroundColor: Colors.white70,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      padding: const EdgeInsets.symmetric(horizontal: 18),
                    ),
                    child: const Text('Cancel', style: TextStyle(fontWeight: FontWeight.w800)),
                  ),
                ),
                horizontalSpace(12),
                SizedBox(
// ...
                  height: 44,
                  child: ElevatedButton(
                    onPressed: widget.isSaving ? null : _submit,
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      backgroundColor: const Color(0xFF38B24A),
                      foregroundColor: Colors.white,
                      disabledBackgroundColor: const Color(0xFF2D7E39),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      padding: const EdgeInsets.symmetric(horizontal: 18),
                    ),
                    child: widget.isSaving
                        ? Row(
                      children: const [
                        SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                        ),
                        SizedBox(width: 10),
                        Text('Saving...', style: TextStyle(fontWeight: FontWeight.w900)),
                      ],
                    )
                        : const Text('Save', style: TextStyle(fontWeight: FontWeight.w900)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _DropdownRow<T> extends StatelessWidget {
  final T value;
  final List<T> items;
  final String Function(T) labelBuilder;
  final ValueChanged<T> onChanged;

  const _DropdownRow({
    required this.value,
    required this.items,
    required this.labelBuilder,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white10),
        borderRadius: BorderRadius.circular(10),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<T>(
          value: value,
          isExpanded: true,
          dropdownColor: const Color(0xFF0E1626),
          icon: const Icon(Icons.keyboard_arrow_down, color: Colors.white54),
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
          items: items
              .map((e) => DropdownMenuItem<T>(
            value: e,
            child: Text(labelBuilder(e)),
          ))
              .toList(),
          onChanged: (v) {
            if (v == null) return;
            onChanged(v);
          },
        ),
      ),
    );
  }
}
