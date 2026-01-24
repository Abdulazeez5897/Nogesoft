import 'package:stacked/stacked.dart';

import 'model/staff_member.dart';


class StaffViewModel extends BaseViewModel {
  static const Object saveBusyKey = 'saveStaff';

  final List<StaffMember> _staff = [
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

  List<StaffMember> get staff => List.unmodifiable(_staff);

  bool get isSaving => busy(saveBusyKey);

  Future<void> addStaff({
    required String name,
    required String email,
    required String password, // kept because UI has it; not stored
    required StaffRole role,
    required StaffStatus status,
    required bool isAdmin,
    String? pickedFileName, // UI only
  }) async {
    setBusyForObject(saveBusyKey, true);

    // mimic the “Saving...” state from the video (without UI-layer hacks)
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
    setBusyForObject(saveBusyKey, false);
    notifyListeners();
  }

  Future<void> updateStaff(StaffMember updated) async {
    final idx = _staff.indexWhere((s) => s.id == updated.id);
    if (idx == -1) return;
    _staff[idx] = updated;
    notifyListeners();
  }

  void deleteStaff(String id) {
    _staff.removeWhere((s) => s.id == id);
    notifyListeners();
  }
}
