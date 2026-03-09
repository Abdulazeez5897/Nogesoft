import 'dart:io';
import 'package:stacked/stacked.dart';

import '../../../app/app.locator.dart';
import '../../../core/utils/local_storage.dart';
import 'model/staff_member.dart';


class StaffViewModel extends BaseViewModel {
  static const Object saveBusyKey = 'saveStaff';

  final _localStorage = locator<LocalStorage>();

  List<StaffMember> _staff = [];
  List<StaffMember> get staff => List.unmodifiable(_staff);

  bool get isSaving => busy(saveBusyKey);

  Future<void> init() async {
    setBusy(true);
    
    try {
      final savedData = await _localStorage.fetch('staffList');
      if (savedData != null && savedData is List) {
        _staff = savedData.map((e) => StaffMember.fromJson(Map<String, dynamic>.from(e))).toList();
      }
    } catch (e) {
      // ignore parsing or storage errors on init
    }
    
    if (_staff.isEmpty) {
      _staff = [
        const StaffMember(
          id: 's1',
          name: 'Abubakar Salihu Baba',
          email: 'salihuabubakar557@smartbiz.com',
          role: StaffRole.owner,
          status: StaffStatus.active,
          isAdmin: false,
        ),
        const StaffMember(
          id: 's2',
          name: 'Abdulazeez Usman',
          email: 'abdulazeezusman732@gmail.com',
          role: StaffRole.admin,
          status: StaffStatus.active,
          isAdmin: true,
        ),
      ];
      await _saveToStorage();
    }
    setBusy(false);
  }

  Future<void> _saveToStorage() async {
    final data = _staff.map((e) => e.toJson()).toList();
    await _localStorage.save('staffList', data);
  }

  Future<void> addStaff({
    required String name,
    required String email,
    required String password, 
    required StaffRole role,
    required StaffStatus status,
    required bool isAdmin,
    String? pickedFileName,
    File? imageFile,
  }) async {
    setBusyForObject(saveBusyKey, true);

    await Future<void>.delayed(const Duration(milliseconds: 750));

    final item = StaffMember(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      name: name.trim(),
      email: email.trim(),
      role: role,
      status: status,
      isAdmin: isAdmin,
      avatarAssetOrUrl: imageFile?.path,
    );

    _staff.insert(0, item);
    await _saveToStorage();
    
    setBusyForObject(saveBusyKey, false);
    notifyListeners();
  }

  Future<void> updateStaff(StaffMember updated) async {
    setBusyForObject(saveBusyKey, true);
    await Future.delayed(const Duration(milliseconds: 500));
    final idx = _staff.indexWhere((s) => s.id == updated.id);
    if (idx != -1) {
      _staff[idx] = updated;
      await _saveToStorage();
      notifyListeners();
    }
    setBusyForObject(saveBusyKey, false);
  }

  Future<void> deleteStaff(String id) async {
    _staff.removeWhere((s) => s.id == id);
    await _saveToStorage();
    notifyListeners();
  }
}
