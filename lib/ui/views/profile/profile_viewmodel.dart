import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:stacked/stacked.dart';

import '../../../app/app.locator.dart';
import '../../../core/utils/local_storage.dart';
import 'model/user_profile.dart';


class ProfileViewModel extends BaseViewModel {
  static const Object saveBusyKey = 'saveProfile';

  final _localStorage = locator<LocalStorage>();
  final ImagePicker _picker = ImagePicker();

  UserProfile? _profile;

  String? _pickedFileName;
  File? _selectedImage;
  bool get hasPickedThumbnail => _selectedImage != null || _profile?.avatarUrl != null;

  UserProfile? get profile => _profile;

  String? get pickedFileName => _pickedFileName;

  bool get isSaving => busy(saveBusyKey);

  Future<void> initialise() async {
    setBusy(true);

    try {
      final savedData = await _localStorage.fetch('userProfile');
      if (savedData != null && savedData is Map) {
         _profile = UserProfile.fromJson(Map<String, dynamic>.from(savedData));
         if (_profile?.avatarUrl != null) {
           _selectedImage = File(_profile!.avatarUrl!);
         }
      }
    } catch (e) {
      // ignore
    }

    if (_profile == null) {
      _profile = const UserProfile(
      id: 'u1',
      name: 'Abdulazeez Usman',
      email: 'abdulazeezusman732@gmail.com',
      avatarUrl: null,
      );
      await _saveToStorage();
    }

    setBusy(false);
  }

  Future<void> _saveToStorage() async {
    if (_profile != null) {
      await _localStorage.save('userProfile', _profile!.toJson());
    }
  }

  Future<void> pickImage(ImageSource source) async {
    try {
      bool granted = await _handlePermission(source);
      if (!granted) return;

      final XFile? pickedFile = await _picker.pickImage(
        source: source,
        imageQuality: 80,
      );

      if (pickedFile != null) {
        _selectedImage = File(pickedFile.path);
        _pickedFileName = pickedFile.name;
        notifyListeners();
      }
    } catch (e) {
      // handle error if needed
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
      name: name.trim().isEmpty ? _profile!.name : name.trim(),
      email: email.trim().isEmpty ? _profile!.email : email.trim(),
      avatarUrl: _selectedImage?.path,
    );

    await _saveToStorage();

    setBusyForObject(saveBusyKey, false);
    notifyListeners();
    return true;
  }
}

extension UserProfileExtension on ProfileViewModel {
  File? get selectedImage => _selectedImage;
}
