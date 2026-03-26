import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../../domain/models/canvas_element.dart';
import '../../providers/editor_provider.dart';

class LeftSidebar extends ConsumerWidget {
  const LeftSidebar({super.key});

  void _addText(WidgetRef ref) {
    ref.read(editorProvider.notifier).addElement(TextElement(
      id: const Uuid().v4(),
      position: const Offset(960, 540),
      size: const Size(200, 50),
      text: 'New Text',
    ));
  }

  void _addShape(WidgetRef ref, ShapeType type) {
    ref.read(editorProvider.notifier).addElement(ShapeElement(
      id: const Uuid().v4(),
      position: const Offset(960, 540),
      size: const Size(100, 100),
      shapeType: type,
    ));
  }

  void _addVideo(WidgetRef ref) {
    ref.read(editorProvider.notifier).addElement(VideoElement(
      id: const Uuid().v4(),
      position: const Offset(960, 540),
      size: const Size(300, 200),
      path: 'assets/sample_video.mp4', // Example or NetworkURL
    ));
  }

  void _addAudio(WidgetRef ref) {
    ref.read(editorProvider.notifier).addElement(AudioElement(
      id: const Uuid().v4(),
      position: const Offset(960, 540),
      size: const Size(60, 60),
      path: 'assets/sample_audio.mp3', // Example or NetworkURL
    ));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      width: 80,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(right: BorderSide(color: Colors.grey.shade300)),
      ),
      child: Column(
        children: [
          const SizedBox(height: 16),
          _buildActionTab(Icons.text_fields, 'Text', () => _addText(ref)),
          _buildActionTab(Icons.rectangle_outlined, 'Shape', () => _addShape(ref, ShapeType.rectangle)),
          _buildActionTab(Icons.video_library_outlined, 'Video', () => _addVideo(ref)),
          _buildActionTab(Icons.library_music_outlined, 'Audio', () => _addAudio(ref)),
        ],
      ),
    );
  }

  Widget _buildActionTab(IconData icon, String label, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: SizedBox(
        height: 72,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.black87),
            Text(label, style: const TextStyle(fontSize: 10)),
          ],
        ),
      ),
    );
  }
}
