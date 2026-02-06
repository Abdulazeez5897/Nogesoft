import 'dart:io';
import 'package:flutter/material.dart';

import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

import '../common/app_colors.dart';

class ProfilePicturePicker extends StatefulWidget {
  final File? selectedFile;
  final Function(File?) onImagePicked;
  final double size;
  final String? defaultImage;

  const ProfilePicturePicker({
    super.key,
    this.selectedFile,
    required this.onImagePicked,
    this.size = 80,
    this.defaultImage,
  });

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




  void _showPermissionDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Permission Required"),
        content: const Text("Enable camera/gallery permission in settings."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              openAppSettings();
              Navigator.pop(context);
            },
            child: const Text("Open Settings"),
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
              leading: const Icon(Icons.camera_alt),
              title: const Text("Take Photo"),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text("Choose from Gallery"),
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
              padding: const EdgeInsets.all(4),
              decoration: const BoxDecoration(
                color: kcPrimaryColor,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.edit, color: Colors.white, size: 20),
            ),
          ),
        ],
      ),
    );
  }
}
