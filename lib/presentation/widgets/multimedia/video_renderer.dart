import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import '../../../domain/models/canvas_element.dart';

class VideoRenderer extends StatefulWidget {
  final VideoElement element;
  const VideoRenderer({super.key, required this.element});

  @override
  State<VideoRenderer> createState() => _VideoRendererState();
}

class _VideoRendererState extends State<VideoRenderer> {
  late VideoPlayerController _controller;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _initPlayer();
  }

  void _initPlayer() {
    if (widget.element.path.startsWith('http')) {
      _controller = VideoPlayerController.networkUrl(Uri.parse(widget.element.path));
    } else {
      _controller = VideoPlayerController.asset(widget.element.path);
    }

    _controller.initialize().then((_) {
      if (mounted) {
        setState(() {
          _isInitialized = true;
        });
        _controller.setLooping(widget.element.isLooping);
        _controller.setVolume(widget.element.volume);
        _controller.play();
      }
    });
  }

  @override
  void didUpdateWidget(VideoRenderer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.element.path != widget.element.path) {
      _controller.dispose();
      _isInitialized = false;
      _initPlayer();
    } else {
      if (oldWidget.element.volume != widget.element.volume) {
        _controller.setVolume(widget.element.volume);
      }
      if (oldWidget.element.isLooping != widget.element.isLooping) {
        _controller.setLooping(widget.element.isLooping);
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized) {
      return Container(
        color: Colors.black87,
        child: const Center(child: CircularProgressIndicator(color: Colors.white)),
      );
    }
    return VideoPlayer(_controller);
  }
}
