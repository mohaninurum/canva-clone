import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import '../../../domain/models/canvas_element.dart';

class AudioRenderer extends StatefulWidget {
  final AudioElement element;
  const AudioRenderer({super.key, required this.element});

  @override
  State<AudioRenderer> createState() => _AudioRendererState();
}

class _AudioRendererState extends State<AudioRenderer> {
  late AudioPlayer _player;

  @override
  void initState() {
    super.initState();
    _player = AudioPlayer();
    _initPlayer();
  }

  void _initPlayer() async {
    await _player.setReleaseMode(widget.element.isLooping ? ReleaseMode.loop : ReleaseMode.stop);
    await _player.setVolume(widget.element.volume);
    
    // Play source
    if (widget.element.path.startsWith('http')) {
      await _player.play(UrlSource(widget.element.path));
    } else {
      // In production, we'd switch based on local file check (DeviceFileSource vs AssetSource)
      // Defaults to Asset source simulating testing
      await _player.play(AssetSource(widget.element.path));
    }
  }

  @override
  void didUpdateWidget(AudioRenderer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.element.path != widget.element.path) {
      _initPlayer();
    } else {
      if (oldWidget.element.volume != widget.element.volume) {
        _player.setVolume(widget.element.volume);
      }
      if (oldWidget.element.isLooping != widget.element.isLooping) {
        _player.setReleaseMode(widget.element.isLooping ? ReleaseMode.loop : ReleaseMode.stop);
      }
    }
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2))],
      ),
      child: const Center(
        child: Icon(Icons.music_note, color: Colors.deepPurple, size: 40),
      ),
    );
  }
}
