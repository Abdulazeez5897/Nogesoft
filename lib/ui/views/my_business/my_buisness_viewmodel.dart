import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:stacked/stacked.dart';

import '../../../app/app.locator.dart';
import '../../../core/utils/local_storage.dart';
import 'model/business_model.dart';


class MyBusinessViewModel extends BaseViewModel {
  static const Object saveBusyKey = 'saveBusiness';

  final _localStorage = locator<LocalStorage>();
  final ImagePicker _picker = ImagePicker();

  BusinessProfile? _business;
  File? _selectedLogo;

  BusinessProfile? get business => _business;
  bool get isSaving => busy(saveBusyKey);

  Future<void> initialise() async {
    setBusy(true);

    try {
      final savedData = await _localStorage.fetch('businessProfile');
      if (savedData != null && savedData is Map) {
        _business = BusinessProfile.fromJson(Map<String, dynamic>.from(savedData));
        if (_business?.logoUrl != null) {
          _selectedLogo = File(_business!.logoUrl!);
        }
      }
    } catch (e) {
      // ignore parsing or storage errors on init
    }

    if (_business == null) {
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
      await _saveToStorage();
    }

    setBusy(false);
    notifyListeners();
  }

  Future<void> _saveToStorage() async {
    if (_business != null) {
      await _localStorage.save('businessProfile', _business!.toJson());
    }
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
    _saveToStorage(); // Fire and forget
    notifyListeners();
  }

  void removeBranch(String branchId) {
    final b = _business;
    if (b == null) return;

    _business = b.copyWith(
      branches: b.branches.where((e) => e.id != branchId).toList(growable: false),
    );
    _saveToStorage();
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
    _saveToStorage();
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
      logoUrl: _selectedLogo?.path,
      branches: branches,
    );

    await _saveToStorage();

    setBusyForObject(saveBusyKey, false);
    notifyListeners();
  }

  Future<void> pickLogo(ImageSource source) async {
    try {
      bool granted = await _handlePermission(source);
      if (!granted) return;

      final XFile? pickedFile = await _picker.pickImage(
        source: source,
        imageQuality: 80,
      );

      if (pickedFile != null) {
        _selectedLogo = File(pickedFile.path);
        notifyListeners();
      }
    } catch (e) {
      // Handle error
    }
  }

  Future<bool> _handlePermission(ImageSource source) async {
    if (source == ImageSource.camera) {
      final status = await Permission.camera.request();
      if (status.isGranted) return true;
    } else {
      if (Platform.isAndroid) {
        final storageStatus = await Permission.storage.request();
        if (storageStatus.isGranted) return true;
        final photosStatus = await Permission.photos.request();
        if (photosStatus.isGranted) return true;
        try {
          final mediaLibraryStatus = await Permission.mediaLibrary.request();
          if (mediaLibraryStatus.isGranted) return true;
        } catch (_) {}
      } else if (Platform.isIOS) {
        final status = await Permission.photos.request();
        if (status.isGranted) return true;
      }
    }
    return false;
  }
}

extension MyBusinessViewModelExtension on MyBusinessViewModel {
  File? get selectedLogo => _selectedLogo;
}
