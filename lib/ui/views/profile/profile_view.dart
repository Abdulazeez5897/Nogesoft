import 'package:flutter/material.dart';
import 'package:nogesoft/ui/views/profile/profile_viewmodel.dart';
import 'package:stacked/stacked.dart';

import 'model/user_profile.dart';

class ProfileView extends StackedView<ProfileViewModel> {
  const ProfileView({super.key});

  @override
  void onViewModelReady(ProfileViewModel viewModel) {
    viewModel.initialise();
  }

  @override
  Widget builder(BuildContext context, ProfileViewModel viewModel, Widget? child) {
    final profile = viewModel.profile;

    if (viewModel.isBusy && profile == null) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (profile == null) {
      return const Center(
        child: Text(
          'No profile data',
          style: TextStyle(color: Colors.white60, fontWeight: FontWeight.w800),
        ),
      );
    }

    // ✅ Pass the VM down instead of using context.watch
    return _MyProfileBody(profile: profile, viewModel: viewModel);
  }

  @override
  ProfileViewModel viewModelBuilder(BuildContext context) => ProfileViewModel();
}

class _MyProfileBody extends StatefulWidget {
  final UserProfile profile;
  final ProfileViewModel viewModel;

  const _MyProfileBody({
    required this.profile,
    required this.viewModel,
  });

  @override
  State<_MyProfileBody> createState() => _MyProfileBodyState();
}

class _MyProfileBodyState extends State<_MyProfileBody> {
  late final TextEditingController _name;
  late final TextEditingController _email;
  late final TextEditingController _password;

  bool _obscure = true;

  @override
  void initState() {
    super.initState();
    _name = TextEditingController(text: widget.profile.name);
    _email = TextEditingController(text: widget.profile.email);
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
    final vm = widget.viewModel; // ✅ Use the VM passed in

    // Shell provides PrimaryScrollController; keep this scrollable “normal”.
    return CustomScrollView(
      primary: true,
      physics: const BouncingScrollPhysics(),
      slivers: [
        const SliverToBoxAdapter(child: SizedBox(height: 16)),

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

        const SliverToBoxAdapter(child: SizedBox(height: 14)),

        SliverPadding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 22),
          sliver: SliverToBoxAdapter(
            child: _ProfileCard(
              nameController: _name,
              emailController: _email,
              passwordController: _password,
              obscure: _obscure,
              onToggleObscure: () => setState(() => _obscure = !_obscure),
              pickedFileName: vm.pickedFileName,
              hasThumbnail: vm.hasPickedThumbnail,
              onChooseFile: vm.pickMockFile,
              isSaving: vm.isSaving,
              onSave: () => vm.saveChanges(
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
  final Future<void> Function() onSave;

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
          const SizedBox(height: 4),

          // Avatar
          CircleAvatar(
            radius: 42,
            backgroundColor: const Color(0xFF2F6BFF).withOpacity(0.20),
            child: const Icon(Icons.person, color: Colors.white, size: 46),
          ),

          const SizedBox(height: 14),

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
                const SizedBox(width: 12),
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
                if (hasThumbnail) const SizedBox(width: 8),
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

          const SizedBox(height: 8),
          const Text(
            'JPG, PNG up to 2MB',
            style: TextStyle(color: Colors.white54, fontWeight: FontWeight.w700),
          ),

          const SizedBox(height: 14),

          TextField(
            controller: nameController,
            style: TextStyle(color: textPrimary, fontWeight: FontWeight.w700),
            decoration: dec(''),
          ),

          const SizedBox(height: 12),

          TextField(
            controller: emailController,
            style: TextStyle(color: textPrimary, fontWeight: FontWeight.w700),
            keyboardType: TextInputType.emailAddress,
            decoration: dec(''),
          ),

          const SizedBox(height: 12),

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

          const SizedBox(height: 16),

          SizedBox(
            height: 48,
            width: double.infinity,
            child: ElevatedButton(
              onPressed: isSaving ? null : () => onSave(),
              style: ElevatedButton.styleFrom(
                elevation: 0,
                backgroundColor: const Color(0xFF38B24A),
                disabledBackgroundColor: const Color(0xFF2D7E39),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              child: isSaving
                  ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
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
