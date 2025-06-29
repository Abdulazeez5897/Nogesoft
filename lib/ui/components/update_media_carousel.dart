import 'package:cached_network_image/cached_network_image.dart';
import 'package:scrubly/ui/components/shimmer_widgets.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';

class UpdateMediaCarousel extends StatefulWidget {
  final List<String> mediaUrls;
  final List<String>? mediaThumbnails;
  const UpdateMediaCarousel({super.key, required this.mediaUrls, this.mediaThumbnails});

  @override
  State<UpdateMediaCarousel> createState() => _UpdateMediaCarouselState();
}

class _UpdateMediaCarouselState extends State<UpdateMediaCarousel> {
  final PageController _pageController = PageController();
  List<VideoPlayerController?> _videoControllers = [];
  List<bool> _isVisible = [];
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _videoControllers = List.generate(widget.mediaUrls.length, (_) => null);
    _isVisible = List.generate(widget.mediaUrls.length, (_) => false);
  }

  @override
  void dispose() {
    for (var controller in _videoControllers) {
      controller?.dispose();
    }
    _pageController.dispose();
    super.dispose();
  }

  void _initializeVideo(int index) async {
    if (_videoControllers[index] == null && _isVideo(widget.mediaUrls[index])) {
      final controller = VideoPlayerController.network(widget.mediaUrls[index]);
      await controller.initialize();
      setState(() {
        _videoControllers[index] = controller..setLooping(true);
      });
      controller.play();
    }
  }

  void _disposeVideo(int index) {
    _videoControllers[index]?.dispose();
    _videoControllers[index] = null;
  }

  bool _isVideo(String url) {
    Uri uri = Uri.parse(url);
    String path = uri.path.toLowerCase();
    return path.endsWith('.mp4') || path.endsWith('.mov');
  }



  Widget _buildDotsIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        widget.mediaUrls.length,
            (index) => AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: _currentPage == index ? 12 : 8,
          height: _currentPage == index ? 12 : 8,
          decoration: BoxDecoration(
            color: _currentPage == index ? Colors.blueAccent : Colors.grey,
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 350,
          child: PageView.builder(
            controller: _pageController,
            itemCount: widget.mediaUrls.length,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            itemBuilder: (context, index) {
              final mediaUrl = widget.mediaUrls[index];

              return VisibilityDetector(
                key: Key(mediaUrl + index.toString()),
                onVisibilityChanged: (visibilityInfo) {
                  if (visibilityInfo.visibleFraction > 0.5) {
                    _isVisible[index] = true;
                    _initializeVideo(index);
                  } else {
                    _isVisible[index] = false;
                    _disposeVideo(index);
                  }
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: _isVideo(mediaUrl)
                      ? (_videoControllers[index] != null && _videoControllers[index]!.value.isInitialized
                      ? Stack(
                    fit: StackFit.expand,
                    children: [
                      AspectRatio(
                        aspectRatio: _videoControllers[index]!.value.aspectRatio,
                        child: VideoPlayer(_videoControllers[index]!),
                      ),
                      Center(
                        child: IconButton(
                          iconSize: 50,
                          icon: Icon(
                            _videoControllers[index]!.value.isPlaying
                                ? Icons.pause_circle_filled
                                : Icons.play_circle_fill,
                            color: Colors.white.withOpacity(0.8),
                          ),
                          onPressed: () {
                            setState(() {
                              if (_videoControllers[index]!.value.isPlaying) {
                                _videoControllers[index]!.pause();
                              } else {
                                _videoControllers[index]!.play();
                              }
                            });
                          },
                        ),
                      ),
                    ],
                  )
                      : CachedNetworkImage(
                    imageUrl: widget.mediaThumbnails?[index] ?? mediaUrl,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => ShimmerWidgets.shimmersPlaceholder(),
                    errorWidget: (context, error, stackTrace) =>
                        ShimmerWidgets.shimmersPlaceholder(),
                  ))
                      : CachedNetworkImage(
                    imageUrl: mediaUrl,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => ShimmerWidgets.shimmersPlaceholder(),
                    errorWidget: (context, error, stackTrace) => const Icon(Icons.broken_image, size: 100),
                  ),
                ),
              );
            },
          ),
        ),
        if (widget.mediaUrls.length > 1) _buildDotsIndicator(), // only show if more than 1
      ],
    );
  }
}
