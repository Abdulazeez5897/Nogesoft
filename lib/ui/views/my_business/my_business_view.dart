import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import 'package:nogesoft/ui/common/ui_helpers.dart';

import 'model/business_model.dart';
import 'my_buisness_viewmodel.dart';


class MyBusinessView extends StackedView<MyBusinessViewModel> {
  const MyBusinessView({super.key});

  @override
  void onViewModelReady(MyBusinessViewModel viewModel) {
    viewModel.initialise();
  }

  @override
  Widget builder(BuildContext context, MyBusinessViewModel viewModel, Widget? child) {
    final business = viewModel.business;

    if (viewModel.isBusy && business == null) {
      return const Center(child: CircularProgressIndicator());
    }

    if (business == null) {
      return const Center(
        child: Text(
          'No business data',
          style: TextStyle(color: Colors.white60, fontWeight: FontWeight.w800),
        ),
      );
    }

    return _MyBusinessBody(business: business, viewModel: viewModel);
  }

  @override
  MyBusinessViewModel viewModelBuilder(BuildContext context) => MyBusinessViewModel();
}

class _MyBusinessBody extends StatefulWidget {
  final BusinessProfile business;
  final MyBusinessViewModel viewModel;

  const _MyBusinessBody({
    required this.business,
    required this.viewModel,
  });

  @override
  State<_MyBusinessBody> createState() => _MyBusinessBodyState();
}

class _MyBusinessBodyState extends State<_MyBusinessBody> {
  late final TextEditingController _companyHeader;
  late final TextEditingController _distributor;
  late final TextEditingController _authorizedTag;
  late final TextEditingController _email;
  late final TextEditingController _phone;
  late final TextEditingController _headOfficeAddress;

  // Branch controllers keyed by id (keeps typing stable)
  final Map<String, TextEditingController> _branchNameCtrls = {};
  final Map<String, TextEditingController> _branchAddressCtrls = {};

  @override
  void initState() {
    super.initState();

    final b = widget.business;
    _companyHeader = TextEditingController(text: b.companyHeader);
    _distributor = TextEditingController(text: b.distributorName);
    _authorizedTag = TextEditingController(text: b.authorizedTag);
    _email = TextEditingController(text: b.email);
    _phone = TextEditingController(text: b.phone);
    _headOfficeAddress = TextEditingController(text: b.headOfficeAddress);

    _syncBranchControllers(b.branches);
  }

  @override
  void didUpdateWidget(covariant _MyBusinessBody oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Update branch controllers when branches change (add/remove)
    _syncBranchControllers(widget.business.branches);
  }

  void _syncBranchControllers(List<BusinessBranch> branches) {
    // Create missing
    for (final br in branches) {
      _branchNameCtrls.putIfAbsent(br.id, () => TextEditingController(text: br.name));
      _branchAddressCtrls.putIfAbsent(br.id, () => TextEditingController(text: br.address));
    }
    // Dispose removed
    final existingIds = branches.map((e) => e.id).toSet();
    final removedName = _branchNameCtrls.keys.where((id) => !existingIds.contains(id)).toList();
    for (final id in removedName) {
      _branchNameCtrls[id]!.dispose();
      _branchNameCtrls.remove(id);
    }
    final removedAddr = _branchAddressCtrls.keys.where((id) => !existingIds.contains(id)).toList();
    for (final id in removedAddr) {
      _branchAddressCtrls[id]!.dispose();
      _branchAddressCtrls.remove(id);
    }
  }

  @override
  void dispose() {
    _companyHeader.dispose();
    _distributor.dispose();
    _authorizedTag.dispose();
    _email.dispose();
    _phone.dispose();
    _headOfficeAddress.dispose();

    for (final c in _branchNameCtrls.values) {
      c.dispose();
    }
    for (final c in _branchAddressCtrls.values) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _confirmRemove(String branchId) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF0E1626),
        title: const Text('Remove Branch', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        content: const Text(
          'Are you sure you want to remove this branch?',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Cancel', style: TextStyle(color: Colors.white60)),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Remove', style: TextStyle(color: Color(0xFFE04B5A), fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      widget.viewModel.removeBranch(branchId);
    }
  }

  Future<void> _handlePickLogo() async {
    // Mocking file pick + size validation
    // In real app: final XFile? file = await _picker.pickImage(...)
    // if (await file.length() > 2 * 1024 * 1024) _showError('File is too large (Max 2MB)');
    
    // Simulating success for now, but error modal logic is ready:
    /*
    _showError('File is too large. Maximum size is 2MB.');
    return;
    */
    
    widget.viewModel.pickLogoMock();
  }



  @override
  Widget build(BuildContext context) {
    final vm = widget.viewModel;
    final b = widget.business;
    
    // ...
    return Material(
      color: Colors.transparent,
      child: CustomScrollView(
        primary: true,
        // physics: const BouncingScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(child: verticalSpace(108)),

          const SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverToBoxAdapter(
              child: Text(
                'My Business',
                style: TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.w900),
              ),
            ),
          ),


        SliverToBoxAdapter(child: verticalSpace(14)),

        SliverPadding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 22),
          sliver: SliverToBoxAdapter(
            child: _BusinessFormCard(
              companyHeader: _companyHeader,
              distributor: _distributor,
              authorizedTag: _authorizedTag,
              email: _email,
              phone: _phone,
              headOfficeAddress: _headOfficeAddress,
              branches: b.branches,
              branchNameCtrls: _branchNameCtrls,
              branchAddressCtrls: _branchAddressCtrls,
              onAddBranch: vm.addBranch,
              onRemoveBranch: _confirmRemove,
              isSaving: vm.isSaving,
              onSave: () => vm.saveChanges(
                companyHeader: _companyHeader.text,
                distributorName: _distributor.text,
                authorizedTag: _authorizedTag.text,
                email: _email.text,
                phone: _phone.text,
                headOfficeAddress: _headOfficeAddress.text,
                branches: b.branches.map((br) {
                  final name = _branchNameCtrls[br.id]?.text ?? br.name;
                  final addr = _branchAddressCtrls[br.id]?.text ?? br.address;
                  return br.copyWith(name: name, address: addr);
                }).toList(growable: false),
              ),
              onPickLogo: _handlePickLogo,
            ),
          ),
        ),
        ],
      ),
    );
  }
}

class _BusinessFormCard extends StatelessWidget {
  final TextEditingController companyHeader;
  final TextEditingController distributor;
  final TextEditingController authorizedTag;
  final TextEditingController email;
  final TextEditingController phone;
  final TextEditingController headOfficeAddress;

  final List<BusinessBranch> branches;
  final Map<String, TextEditingController> branchNameCtrls;
  final Map<String, TextEditingController> branchAddressCtrls;

  final VoidCallback onAddBranch;
  final ValueChanged<String> onRemoveBranch;
  final VoidCallback onPickLogo;

  final bool isSaving;
  final Future<void> Function() onSave;

  const _BusinessFormCard({
    required this.companyHeader,
    required this.distributor,
    required this.authorizedTag,
    required this.email,
    required this.phone,
    required this.headOfficeAddress,
    required this.branches,
    required this.branchNameCtrls,
    required this.branchAddressCtrls,
    required this.onAddBranch,
    required this.onRemoveBranch,
    required this.onPickLogo,
    required this.isSaving,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {


    final border = Colors.white.withOpacity(0.22);
    final inputBorder = Colors.white.withOpacity(0.22);

    InputDecoration dec(String hint) {
      return InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.white38, fontWeight: FontWeight.w700),
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: inputBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFF2F6BFF), width: 2),
        ),
      );
    }

    Widget label(String text) => Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: const TextStyle(color: Colors.white70, fontWeight: FontWeight.w800),
      ),
    );

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 18),
      decoration: BoxDecoration(
        border: Border.all(color: border, width: 1.3),
        borderRadius: BorderRadius.circular(18),
        color: Colors.transparent,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Avatar
          Center(
            child: GestureDetector(
              onTap: isSaving ? null : onPickLogo,
              child: CircleAvatar(
                radius: 46,
                backgroundColor: const Color(0xFF2F6BFF).withOpacity(0.18),
                child: const Icon(Icons.store, color: Colors.white, size: 40),
              ),
            ),
          ),
          verticalSpace(10),
          const Center(
            child: Text(
              'PNG / JPG • Max 2MB',
              style: TextStyle(color: Colors.white54, fontWeight: FontWeight.w700),
            ),
          ),

          verticalSpace(14),

          label('Company Header (Main Company Name)'),
          TextField(
            controller: companyHeader,
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
            decoration: dec(''),
          ),

          verticalSpace(12),

          label('Distributor Name (Optional)'),
          TextField(
            controller: distributor,
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
            decoration: dec('e.g. Al-Amin Foams Trading Company'),
          ),

          verticalSpace(12),

          label('Authorized Tag (Optional)'),
          TextField(
            controller: authorizedTag,
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
            decoration: dec('e.g. Authorized Key Distributor'),
          ),

          verticalSpace(12),

          label('Email'),
          TextField(
            controller: email,
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
            keyboardType: TextInputType.emailAddress,
            decoration: dec(''),
          ),

          verticalSpace(12),

          label('Phone'),
          TextField(
            controller: phone,
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
            keyboardType: TextInputType.phone,
            decoration: dec(''),
          ),

          verticalSpace(14),

          const Text(
            'Business Addresses',
            style: TextStyle(color: Colors.white70, fontWeight: FontWeight.w900, fontSize: 16),
          ),
          verticalSpace(10),

          _AddressBlock(
            titleController: TextEditingController(text: 'Head Office'),
            addressController: headOfficeAddress,
            titleReadOnly: true,
            dec: dec,
          ),

          verticalSpace(10),

          InkWell(
            onTap: isSaving ? null : onAddBranch,
            child: const Padding(
              padding: EdgeInsets.symmetric(vertical: 6),
              child: Text(
                '+ Add Branch',
                style: TextStyle(
                  color: Colors.white70,
                  fontWeight: FontWeight.w800,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ),

          verticalSpace(10),

          // Branch blocks
          ...branches.map((br) {
            final nameCtrl = branchNameCtrls[br.id]!;
            final addrCtrl = branchAddressCtrls[br.id]!;
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _AddressBlock(
                    titleController: nameCtrl,
                    addressController: addrCtrl,
                    titleReadOnly: false,
                    dec: dec,
                    titleHint: 'Branch',
                    addressHint: 'Enter address',
                  ),
                  verticalSpace(8),
                  InkWell(
                    onTap: isSaving ? null : () => onRemoveBranch(br.id),
                    child: const Text(
                      'Remove Branch',
                      style: TextStyle(
                        color: Color(0xFFE04B5A),
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),

          verticalSpace(8),

          // Save button aligned to end like video
          Row(
            children: [
              const Spacer(),
              SizedBox(
                height: 46,
                child: ElevatedButton(
                  onPressed: isSaving ? null : () => onSave(),
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    backgroundColor: const Color(0xFF38B24A),
                    disabledBackgroundColor: const Color(0xFF2D7E39),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    padding: const EdgeInsets.symmetric(horizontal: 18),
                  ),
                  child: isSaving
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
                      : const Text('Save Changes', style: TextStyle(fontWeight: FontWeight.w900)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _AddressBlock extends StatelessWidget {
  final TextEditingController titleController;
  final TextEditingController addressController;
  final bool titleReadOnly;
  final InputDecoration Function(String) dec;

  final String? titleHint;
  final String? addressHint;

  const _AddressBlock({
    required this.titleController,
    required this.addressController,
    required this.titleReadOnly,
    required this.dec,
    this.titleHint,
    this.addressHint,
  });

  @override
  Widget build(BuildContext context) {
    final border = Colors.white.withOpacity(0.22);

    return Container(
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
      decoration: BoxDecoration(
        border: Border.all(color: border, width: 1.3),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: [
          TextField(
            controller: titleController,
            readOnly: titleReadOnly,
            style: const TextStyle(color: Colors.white70, fontWeight: FontWeight.w800),
            decoration: dec(titleHint ?? '').copyWith(
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.white.withOpacity(0.18)),
              ),
            ),
          ),
          verticalSpace(10),
          TextField(
            controller: addressController,
            maxLines: 2,
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
            decoration: dec(addressHint ?? ''),
          ),
        ],
      ),
    );
  }
}
