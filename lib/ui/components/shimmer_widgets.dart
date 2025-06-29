import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerWidgets {
  /// Shimmer for a user row (like in People tab)
  static Widget userTileShimmer() {
    return ListTile(
      leading: Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: const CircleAvatar(radius: 20),
      ),
      title: _shimmerBox(height: 12, width: 100),
      subtitle: _shimmerBox(height: 10, width: 60),
    );
  }

  /// Shimmer for a post row (like in Posts tab)
  static Widget postTileShimmer() {
    return ListTile(
      leading: Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: Colors.grey,
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
      title: _shimmerBox(height: 12, width: 180),
      subtitle: _shimmerBox(height: 10, width: 100),
    );
  }

  /// Reusable shimmer box
  static Widget _shimmerBox({required double height, required double width}) {
    return Padding(
      padding: const EdgeInsets.only(top: 6.0),
      child: Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: Container(
          height: height,
          width: width,
          decoration: BoxDecoration(
            color: Colors.grey,
            borderRadius: BorderRadius.circular(6),
          ),
        ),
      ),
    );
  }

  static Widget postCardShimmer(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
      child: Shimmer.fromColors(
        baseColor: const Color(0xFFE0E0E0),
        highlightColor: const Color(0xFFF5F5F5),
        period: const Duration(milliseconds: 1500),
        direction: ShimmerDirection.ltr,
        child: Card(
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: ListTile(
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Container(
                width: 50,
                height: 50,
                color: const Color(0xFFD6D6D6),
              ),
            ),
            title: Container(
              height: 12,
              width: double.infinity,
              decoration: _boxDecoration,
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 6),
                Container(
                  height: 10,
                  width: MediaQuery.of(context).size.width * 0.5,
                  decoration: _boxDecoration,
                ),
                const SizedBox(height: 12),
                Container(
                  height: 160,
                  width: double.infinity,
                  decoration: _mediaBoxDecoration,
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: List.generate(
                    3,
                        (_) => Container(
                      width: 40,
                      height: 10,
                      decoration: _boxDecoration,
                    ),
                  ),
                ),
              ],
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
        ),
      ),
    );
  }

  static final BoxDecoration _boxDecoration = BoxDecoration(
    color: const Color(0xFFD6D6D6),
    borderRadius: BorderRadius.circular(4),
  );

  static final BoxDecoration _mediaBoxDecoration = BoxDecoration(
    color: const Color(0xFFD6D6D6),
    borderRadius: BorderRadius.circular(8),
  );

  static Widget shimmersPlaceholder() {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Container(
        color: Colors.grey.shade300,
      ),
    );
  }
}
