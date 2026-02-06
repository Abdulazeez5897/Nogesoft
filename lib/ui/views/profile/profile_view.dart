import 'package:flutter/material.dart';
import 'package:nogesoft/ui/views/profile/profile_viewmodel.dart';
import 'package:stacked/stacked.dart';

import 'package:nogesoft/ui/common/ui_helpers.dart';

// Actually original was "import 'model/user_profile.dart';" which implies it's in the same folder?
// Let's stick to relative if it was working or assume standard. 
// "import 'model/user_profile.dart';" was line 7 in original.

class ProfileView extends StackedView<ProfileViewModel> {
  const ProfileView({super.key});

  @override
  ProfileViewModel viewModelBuilder(BuildContext context) => ProfileViewModel();

  @override
  void onViewModelReady(ProfileViewModel viewModel) {
    viewModel.initialise();
  }

  @override
  Widget builder(
      BuildContext context, ProfileViewModel viewModel, Widget? child) {
    if (viewModel.isBusy) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    return _ProfileViewBody(viewModel: viewModel);
  }
}

class _ProfileViewBody extends StatefulWidget {
  final ProfileViewModel viewModel;
  const _ProfileViewBody({required this.viewModel});

  @override
  State<_ProfileViewBody> createState() => _ProfileViewBodyState();
}

class _ProfileViewBodyState extends State<_ProfileViewBody> {
  late final TextEditingController _name;
  late final TextEditingController _email;
  late final TextEditingController _password;
  bool _obscure = true;

  @override
  void initState() {
    super.initState();
    final user = widget.viewModel.profile;
    _name = TextEditingController(text: user?.name);
    _email = TextEditingController(text: user?.email);
    _password = TextEditingController();
  }

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Shell provides PrimaryScrollController; keep this scrollable “normal”.
    return CustomScrollView(
      primary: true,
      physics: const BouncingScrollPhysics(),
      slivers: [
        SliverToBoxAdapter(child: verticalSpace(16)),

        const SliverPadding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          sliver: SliverToBoxAdapter(
            child: Text(
              'My Profile',
              style: TextStyle(
                color: Colors.white,
                fontSize: 26,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ),

        SliverToBoxAdapter(child: verticalSpace(14)),

        SliverPadding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 22),
          sliver: SliverToBoxAdapter(
            child: _ProfileCard(
              nameController: _name,
              emailController: _email,
              passwordController: _password,
              obscure: _obscure,
              onToggleObscure: () => setState(() => _obscure = !_obscure),
              pickedFileName: widget.viewModel.pickedFileName,
              hasThumbnail: widget.viewModel.hasPickedThumbnail,
              onChooseFile: widget.viewModel.pickMockFile,
              isSaving: widget.viewModel.isSaving,
              onSave: () => widget.viewModel.saveChanges(
                name: _name.text,
                email: _email.text,
                newPassword: _password.text,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _ProfileCard extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController passwordController;

  final bool obscure;
  final VoidCallback onToggleObscure;

  final String? pickedFileName;
  final bool hasThumbnail;
  final VoidCallback onChooseFile;

  final bool isSaving;
  final Future<bool> Function() onSave;

  const _ProfileCard({
    required this.nameController,
    required this.emailController,
    required this.passwordController,
    required this.obscure,
    required this.onToggleObscure,
    required this.pickedFileName,
    required this.hasThumbnail,
    required this.onChooseFile,
    required this.isSaving,
    required this.onSave,
  });

  Future<void> _handleSave(BuildContext context) async {
    final success = await onSave();
    if (!success) return;

    if (!context.mounted) return;
    
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: const Color(0xFF0E1626),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.check_circle, color: Color(0xFF38B24A), size: 52),
            verticalSpace(16),
            const Text(
              'Profile Updated!',
              style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
            ),
            verticalSpace(8),
            const Text(
              'Your changes have been saved successfully.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white70),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark ? const Color(0xFF101A2B) : const Color(0xFFEEF2F6);
    final border = isDark ? Colors.white24 : Colors.black12;
    final textPrimary = isDark ? Colors.white : const Color(0xFF0B1220);

    InputDecoration dec(String hint, {Widget? suffixIcon}) {
      return InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.white38, fontWeight: FontWeight.w700),
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFF2F6BFF), width: 2),
        ),
        suffixIcon: suffixIcon,
      );
    }

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 18),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.25 : 0.10),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          verticalSpace(4),

          // Avatar
          CircleAvatar(
            radius: 42,
            backgroundColor: const Color(0xFF2F6BFF).withOpacity(0.20),
            child: const Icon(Icons.person, color: Colors.white, size: 46),
          ),

          verticalSpace(14),

          // Choose File row (matches video)
          Container(
            height: 48,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: border),
            ),
            child: Row(
              children: [
                SizedBox(
                  height: 36,
                  child: OutlinedButton(
                    onPressed: isSaving ? null : onChooseFile,
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: border),
                      foregroundColor: const Color(0xFF2F6BFF),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                    ),
                    child: const Text(
                      'Choose File',
                      style: TextStyle(fontWeight: FontWeight.w900),
                    ),
                  ),
                ),
                horizontalSpace(12),
                if (hasThumbnail)
                  Container(
                    width: 18,
                    height: 18,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      color: Colors.white24,
                    ),
                    child: const Icon(Icons.image, size: 14, color: Colors.white70),
                  ),
                if (hasThumbnail) horizontalSpace(8),
                Expanded(
                  child: Text(
                    pickedFileName ?? 'no file selected',
                    style: TextStyle(
                      color: isDark ? Colors.white70 : Colors.black54,
                      fontWeight: FontWeight.w700,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),

          verticalSpace(8),
          const Text(
            'JPG, PNG up to 2MB',
            style: TextStyle(color: Colors.white54, fontWeight: FontWeight.w700),
          ),

          verticalSpace(14),

          TextField(
            controller: nameController,
            style: TextStyle(color: textPrimary, fontWeight: FontWeight.w700),
            decoration: dec(''),
          ),

          verticalSpace(12),

          TextField(
            controller: emailController,
            style: TextStyle(color: textPrimary, fontWeight: FontWeight.w700),
            keyboardType: TextInputType.emailAddress,
            decoration: dec(''),
          ),

          verticalSpace(12),

          TextField(
            controller: passwordController,
            style: TextStyle(color: textPrimary, fontWeight: FontWeight.w700),
            obscureText: obscure,
            decoration: dec(
              'New password (optional)',
              suffixIcon: IconButton(
                onPressed: isSaving ? null : onToggleObscure,
                icon: Icon(
                  obscure ? Icons.visibility : Icons.visibility_off,
                  color: Colors.white54,
                ),
              ),
            ),
          ),

          verticalSpace(16),

          SizedBox(
            height: 48,
            width: double.infinity,
            child: ElevatedButton(
              onPressed: isSaving ? null : () => _handleSave(context),
              style: ElevatedButton.styleFrom(
                elevation: 0,
                backgroundColor: const Color(0xFF38B24A),
                disabledBackgroundColor: const Color(0xFF2D7E39),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              child: isSaving
                  ? const Row(
                mainAxisAlignment: MainAxisAlignment.center,
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
                  : const Text(
                'Save Changes',
                style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
