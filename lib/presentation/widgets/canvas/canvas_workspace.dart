import 'package:flutter/material.dart';
import 'editor_canvas.dart';

class CanvasWorkspace extends StatelessWidget {
  const CanvasWorkspace({super.key});

  @override
  Widget build(BuildContext context) {
    return InteractiveViewer(
      boundaryMargin: const EdgeInsets.all(2000), // Infinite pan feel
      minScale: 0.1,
      maxScale: 5.0,
      constrained: false, 
      child: const Center(
        child: EditorCanvas(),
      ),
    );
  }
}
