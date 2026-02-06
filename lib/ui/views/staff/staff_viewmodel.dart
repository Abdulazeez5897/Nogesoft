import 'package:stacked/stacked.dart';


import 'model/staff_member.dart';


class StaffViewModel extends BaseViewModel {
  static const Object saveBusyKey = 'saveStaff';


  List<StaffMember> _staff = [];
  List<StaffMember> get staff => List.unmodifiable(_staff);

  bool get isSaving => busy(saveBusyKey);

  Future<void> init() async {
    setBusy(true);
    // _staff = await _repository.getStaffMembers();
    await Future.delayed(const Duration(milliseconds: 500));
    
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
    }
    setBusy(false);
  }

  Future<void> addStaff({
    required String name,
    required String email,
    required String password, 
    required StaffRole role,
    required StaffStatus status,
    required bool isAdmin,
    String? pickedFileName,
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
    );

    _staff.insert(0, item);
    // await _repository.addStaff(item);
    
    setBusyForObject(saveBusyKey, false);
    notifyListeners();
  }

  Future<void> updateStaff(StaffMember updated) async {
    setBusyForObject(saveBusyKey, true);
    await Future.delayed(const Duration(milliseconds: 500));
    final idx = _staff.indexWhere((s) => s.id == updated.id);
    if (idx != -1) {
      _staff[idx] = updated;
      notifyListeners();
    }
    setBusyForObject(saveBusyKey, false);
  }

  void deleteStaff(String id) {
    _staff.removeWhere((s) => s.id == id);
    // await _repository.deleteStaff(id);
    notifyListeners();
  }
}
