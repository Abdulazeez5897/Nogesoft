import 'package:flutter/material.dart';

import 'package:nogesoft/ui/common/ui_helpers.dart';
import 'package:nogesoft/ui/common/app_colors.dart';
import '../../../../state.dart';
import '../../../components/text_field_widget.dart';
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
    return ValueListenableBuilder<AppUiModes>(
      valueListenable: uiMode,
      builder: (context, mode, child) {
        final isDark = mode == AppUiModes.dark;
        final bgColor = isDark ? const Color(0xFF0E1626) : kcWhiteColor;
        final textColor = isDark ? kcWhiteColor : kcBlackColor;
        final borderColor = isDark ? Colors.white10 : kcBlackColor.withOpacity(0.1);

        return Dialog(
          insetPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 22),
          backgroundColor: bgColor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 14),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        widget.title,
                        style: TextStyle(
                          color: textColor,
                          fontSize: 20,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                  ],
                ),
                verticalSpace(12),
    
                TextFieldWidget(
                  controller: _name,
                  hint: 'Name',
                  textInputAction: TextInputAction.next,
                ),
                verticalSpace(10),
    
                TextFieldWidget(
                  controller: _email,
                  hint: 'Email',
                  inputType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                ),
                verticalSpace(10),
    
                TextFieldWidget(
                  controller: _password,
                  hint: 'Password',
                  textInputAction: TextInputAction.done,
                  suffix: IconButton(
                    onPressed: () => setState(() => _obscure = !_obscure),
                    icon: Icon(
                      _obscure ? Icons.visibility : Icons.visibility_off,
                      color: isDark ? Colors.white54 : Colors.grey,
                    ),
                  ),
                  obscureText: _obscure,
                ),
                verticalSpace(10),
    
                _DropdownRow(
                  value: _role,
                  labelBuilder: (r) => r.label,
                  items: StaffRole.values,
                  onChanged: (v) => setState(() => _role = v),
                  isDark: isDark,
                  textColor: textColor,
                  borderColor: borderColor,
                  dropdownColor: isDark ? const Color(0xFF0E1626) : kcWhiteColor,
                ),
                verticalSpace(10),
    
                _DropdownRow(
                  value: _status,
                  labelBuilder: (s) => s.label,
                  items: StaffStatus.values,
                  onChanged: (v) => setState(() => _status = v),
                  isDark: isDark,
                  textColor: textColor,
                  borderColor: borderColor,
                   dropdownColor: isDark ? const Color(0xFF0E1626) : kcWhiteColor,
                ),
    
                verticalSpace(10),
    
                Row(
                  children: [
                    Checkbox(
                      value: _isAdmin,
                      onChanged: (v) => setState(() => _isAdmin = v ?? false),
                      side: BorderSide(color: isDark ? Colors.white54 : Colors.grey),
                      activeColor: const Color(0xFF38B24A),
                    ),
                    Text(
                      'Is Admin',
                      style: TextStyle(color: isDark ? Colors.white70 : Colors.black54, fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
    
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  decoration: BoxDecoration(
                    border: Border.all(color: borderColor),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      SizedBox(
                        height: 36,
                        child: OutlinedButton(
                          onPressed: () {
                            setState(() => _fileName = 'IMG_0318.jpeg');
                          },
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(color: isDark ? Colors.white24 : Colors.grey.withOpacity(0.5)),
                            foregroundColor: isDark ? Colors.white70 : Colors.black54,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                          child: const Text('Choose File'),
                        ),
                      ),
                      horizontalSpace(10),
                      Expanded(
                        child: Text(
                          _fileName ?? 'no file selected',
                          style: TextStyle(color: isDark ? Colors.white60 : Colors.black45, fontWeight: FontWeight.w700),
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
                          backgroundColor: isDark ? const Color(0xFF141E31) : Colors.grey[200],
                          foregroundColor: isDark ? Colors.white70 : Colors.black87,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          padding: const EdgeInsets.symmetric(horizontal: 18),
                        ),
                        child: const Text('Cancel', style: TextStyle(fontWeight: FontWeight.w800)),
                      ),
                    ),
                    horizontalSpace(12),
                    SizedBox(
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
                            ? const Row(
                          children: [
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
      },
    );
  }
}

class _DropdownRow<T> extends StatelessWidget {
  final T value;
  final List<T> items;
  final String Function(T) labelBuilder;
  final ValueChanged<T> onChanged;

  final Color? borderColor;
  final Color? textColor;
  final Color? dropdownColor;
  final bool isDark;

  const _DropdownRow({
    required this.value,
    required this.items,
    required this.labelBuilder,
    required this.onChanged,
    this.borderColor,
    this.textColor,
    this.dropdownColor,
    this.isDark = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
      decoration: BoxDecoration(
        border: Border.all(color: borderColor ?? Colors.white10),
        borderRadius: BorderRadius.circular(10),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<T>(
          value: value,
          isExpanded: true,
          dropdownColor: dropdownColor ?? const Color(0xFF0E1626),
          icon: Icon(Icons.keyboard_arrow_down, color: isDark ? Colors.white54 : Colors.grey),
          style: TextStyle(color: textColor ?? Colors.white, fontWeight: FontWeight.w700),
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
