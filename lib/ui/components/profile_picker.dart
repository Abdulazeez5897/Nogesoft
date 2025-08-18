import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

import '../common/app_colors.dart';

class ProfilePicturePicker extends StatefulWidget {
  final File? selectedFile;
  final Function(File?) onImagePicked;
  final double size;
  final String? defaultImage;

  const ProfilePicturePicker({
    Key? key,
    this.selectedFile,
    required this.onImagePicked,
    this.size = 80,
    this.defaultImage,
  }) : super(key: key);

  @override
  State<ProfilePicturePicker> createState() => _ProfilePicturePickerState();
}

class _ProfilePicturePickerState extends State<ProfilePicturePicker> {
  final ImagePicker _picker = ImagePicker();
  Future _pickImage(ImageSource source) async {
    try {
      bool granted = await _handlePermission(source);
      if (!granted) return;

      final XFile? pickedFile = await _picker.pickImage(
        source: source,
        imageQuality: 80,
      );

      if (pickedFile != null) {
        widget.onImagePicked(File(pickedFile.path));
      }
    } catch (e, stackTrace) {
      debugPrint('Error picking image: $e');
      debugPrint(stackTrace.toString());
      _showErrorDialog('Error accessing image: $e');
    }
  }

  Future<bool> _handlePermission(ImageSource source) async {
    if (source == ImageSource.camera) {
      final status = await Permission.camera.request();
      if (status.isGranted) {
        return true;
      }
    } else {
      if (Platform.isAndroid) {
        final storageStatus = await Permission.storage.request();
        if (storageStatus.isGranted) {
          return true;
        }
        final photosStatus = await Permission.photos.request();
        if (photosStatus.isGranted) {
          return true;
        }
        try {
          final mediaLibraryStatus = await Permission.mediaLibrary.request();
          if (mediaLibraryStatus.isGranted) {
            return true;
          }
        } catch (e) {
          debugPrint('Media library permission not available: $e');
        }
      } else if (Platform.isIOS) {
        final status = await Permission.photos.request();
        if (status.isGranted) {
          return true;
        }
      }
    }
    _showPermissionDialog();
    return false;
  }

  Future<File?> _cropImage(String path) async {
    try {
      final cropped = await ImageCropper().cropImage(
        sourcePath: path,
        cropStyle: CropStyle.circle,
        compressQuality: 90,
        aspectRatioPresets: [CropAspectRatioPreset.square],
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: 'Crop Image',
            toolbarColor: Colors.black,
            toolbarWidgetColor: Colors.white,
            hideBottomControls: true,
          ),
          IOSUiSettings(
            title: 'Crop Image',
          ),
        ],
      );

      if (cropped == null) {
        debugPrint('Cropping cancelled or failed.');
        return null;
      }

      return File(cropped.path);
    } catch (e) {
      debugPrint('Cropper error: $e');
      return null;
    }
  }


  void _showPermissionDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Permission Required"),
        content: Text("Enable camera/gallery permission in settings."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              openAppSettings();
              Navigator.pop(context);
            },
            child: Text("Open Settings"),
          ),
        ],
      ),
    );
  }
  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Error"),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  void _showImageSourceOptions() {
    showModalBottomSheet(
      context: context,
      builder: (_) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: Icon(Icons.camera_alt),
              title: Text("Take Photo"),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.camera);
              },
            ),
            ListTile(
              leading: Icon(Icons.photo_library),
              title: Text("Choose from Gallery"),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.gallery);
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _showImageSourceOptions,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CircleAvatar(
            radius: widget.size / 2,
            backgroundColor: Colors.grey[300],
            backgroundImage: widget.selectedFile != null
                ? FileImage(widget.selectedFile!) as ImageProvider<Object>
                : (widget.defaultImage != null && widget.defaultImage!.isNotEmpty)
                ? NetworkImage(widget.defaultImage!) as ImageProvider<Object>
                : null,
            child: (widget.selectedFile == null &&
                (widget.defaultImage == null || widget.defaultImage!.isEmpty))
                ? Icon(Icons.camera_alt, size: widget.size * 0.4, color: Colors.white)
                : null,
          ),
          Positioned(
            bottom: 4,
            right: 4,
            child: Container(
              padding: EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: kcPrimaryColor,
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.edit, color: Colors.white, size: 20),
            ),
          ),
        ],
      ),
    );
  }
}
