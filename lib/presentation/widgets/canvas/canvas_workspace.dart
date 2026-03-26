import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'editor_canvas.dart';
import '../../providers/editor_provider.dart';

class CanvasWorkspace extends ConsumerWidget {
  const CanvasWorkspace({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () {
        // Tapping empty workspace clears selection
        ref.read(editorProvider.notifier).clearSelection();
      },
      child: InteractiveViewer(
        boundaryMargin: const EdgeInsets.all(double.infinity),
        minScale: 0.1,
        maxScale: 4.0,
        constrained: false,
        child: const Center(
          child: Padding(
            padding: EdgeInsets.all(100.0), // Padding to allow scrolling past edges
            child: EditorCanvas(),
          ),
        ),
      ),
    );
  }
}
