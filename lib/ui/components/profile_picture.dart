import 'package:flutter/material.dart';

class ProfilePicture extends StatelessWidget {
  final double? size;
  final String? url;

  const ProfilePicture({
    this.size,
    this.url,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: size ?? 50,
      width: size ?? 50,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        image: DecorationImage(
          fit: BoxFit.cover,
          // image: AssetImage(
          //   "assets/images/pp.png",
          // ),
          image: NetworkImage(
            url ??
                "https://static.vecteezy.com/system/resources/previews/002/275/847/original/male-avatar-profile-icon-of-smiling-caucasian-man-vector.jpg",
          ),
        ),
      ),
    );
  }
}
