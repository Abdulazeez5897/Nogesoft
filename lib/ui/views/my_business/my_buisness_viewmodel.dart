import 'package:stacked/stacked.dart';

import 'model/business_model.dart';


class MyBusinessViewModel extends BaseViewModel {
  static const Object saveBusyKey = 'saveBusiness';

  BusinessProfile? _business;

  BusinessProfile? get business => _business;
  bool get isSaving => busy(saveBusyKey);

  Future<void> initialise() async {
    setBusy(true);
    await Future<void>.delayed(const Duration(milliseconds: 250));

    // Matches the video values.
    _business = const BusinessProfile(
      id: 'biz_1',
      companyHeader: 'XYZ LTD',
      distributorName: '',
      authorizedTag: '',
      email: 'codespring557@gmail.com',
      phone: '08087722595',
      headOfficeAddress: 'Army Estate Kubwa Abuja',
      branches: [],
    );

    setBusy(false);
    notifyListeners();
  }

  void addBranch() {
    final b = _business;
    if (b == null) return;

    final newBranch = BusinessBranch(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      name: 'Branch',
      address: '',
    );

    _business = b.copyWith(branches: [...b.branches, newBranch]);
    notifyListeners();
  }

  void removeBranch(String branchId) {
    final b = _business;
    if (b == null) return;

    _business = b.copyWith(
      branches: b.branches.where((e) => e.id != branchId).toList(growable: false),
    );
    notifyListeners();
  }

  void updateBranch({
    required String branchId,
    String? name,
    String? address,
  }) {
    final b = _business;
    if (b == null) return;

    final updated = b.branches.map((br) {
      if (br.id != branchId) return br;
      return br.copyWith(name: name, address: address);
    }).toList(growable: false);

    _business = b.copyWith(branches: updated);
    notifyListeners();
  }

  Future<void> saveChanges({
    required String companyHeader,
    required String distributorName,
    required String authorizedTag,
    required String email,
    required String phone,
    required String headOfficeAddress,
    required List<BusinessBranch> branches,
  }) async {
    final b = _business;
    if (b == null) return;

    setBusyForObject(saveBusyKey, true);
    await Future<void>.delayed(const Duration(milliseconds: 700));

    _business = b.copyWith(
      companyHeader: companyHeader.trim(),
      distributorName: distributorName.trim(),
      authorizedTag: authorizedTag.trim(),
      email: email.trim(),
      phone: phone.trim(),
      headOfficeAddress: headOfficeAddress.trim(),
      branches: branches,
    );

    setBusyForObject(saveBusyKey, false);
    notifyListeners();
  }

  // Avatar picker UI exists in video; we keep a hook.
  void pickLogoMock() {
    // no-op for now; wire to image_picker later if you want
  }
}
