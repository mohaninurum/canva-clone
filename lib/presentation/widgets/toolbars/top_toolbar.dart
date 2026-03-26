import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/editor_provider.dart';

class TopToolbar extends ConsumerWidget {
  const TopToolbar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      height: 56,
      color: Colors.deepPurple,
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.undo, color: Colors.white),
            onPressed: () => ref.read(editorProvider.notifier).undo(),
          ),
          IconButton(
            icon: const Icon(Icons.redo, color: Colors.white),
            onPressed: () => ref.read(editorProvider.notifier).redo(),
          ),
          const Spacer(),
          IconButton(
            icon: const Icon(Icons.flip_to_front, color: Colors.white),
            onPressed: () => ref.read(editorProvider.notifier).bringForward(),
          ),
          IconButton(
            icon: const Icon(Icons.flip_to_back, color: Colors.white),
            onPressed: () => ref.read(editorProvider.notifier).sendBackward(),
          ),
          TextButton(
            onPressed: () {
              // Trigger FFMPEG export implementation bound externally
            },
            child: const Text('EXPORT', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
