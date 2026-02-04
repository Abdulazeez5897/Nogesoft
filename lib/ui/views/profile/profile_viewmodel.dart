import 'package:stacked/stacked.dart';

import 'model/user_profile.dart';


class ProfileViewModel extends BaseViewModel {
  static const Object saveBusyKey = 'saveProfile';

  UserProfile? _profile;

  // UI-only “file chosen” state to match video
  String? _pickedFileName;
  bool _hasPickedThumbnail = false;

  UserProfile? get profile => _profile;

  String? get pickedFileName => _pickedFileName;
  bool get hasPickedThumbnail => _hasPickedThumbnail;

  bool get isSaving => busy(saveBusyKey);

  Future<void> initialise() async {
    // keep it clean + realistic
    await Future<void>.delayed(const Duration(milliseconds: 250));

    _profile = const UserProfile(
      id: 'u1',
      name: 'Abdulazeez Usman',
      email: 'abdulazeezusman732@gmail.com',
      avatarUrl: null,
    );

    notifyListeners();
  }

  void pickMockFile() {
    // Matches video: filename becomes IMG...eg and a tiny thumbnail appears
    _pickedFileName = 'IMG_0318.jpeg';
    _hasPickedThumbnail = true;
    notifyListeners();
  }

  Future<bool> saveChanges({
    required String name,
    required String email,
    required String newPassword,
  }) async {
    if (_profile == null) return false;

    setBusyForObject(saveBusyKey, true);

    // Mimic “Saving…” behavior from video
    await Future<void>.delayed(const Duration(milliseconds: 700));

    _profile = _profile!.copyWith(
      name: name.trim(),
      email: email.trim(),
    );

    setBusyForObject(saveBusyKey, false);
    notifyListeners();
    return true;
  }
}
