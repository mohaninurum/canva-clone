import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:screenshot/screenshot.dart';
import '../../providers/editor_provider.dart';
import 'element_widget.dart';

final screenshotControllerProvider = Provider((ref) => ScreenshotController());

class EditorCanvas extends ConsumerWidget {
  const EditorCanvas({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final elements = ref.watch(editorProvider.select((state) => state.elements));
    final controller = ref.watch(screenshotControllerProvider);
    
    return Container(
      width: 1080,
      height: 1080,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Screenshot(
        controller: controller,
        child: Container(
          color: Colors.white, // Export background
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              ...elements.map((e) => ElementWidget(element: e)),
              Positioned.fill(
                child: IgnorePointer(
                  child: CustomPaint(
                    painter: SnappingGuidesPainter(ref.watch(editorProvider.select((s) => s.snappingGuides))),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SnappingGuidesPainter extends CustomPainter {
  final List<dynamic> guides;
  SnappingGuidesPainter(this.guides);

  @override
  void paint(Canvas canvas, Size size) {
    if (guides.isEmpty) return;
    final paint = Paint()
      ..color = Colors.pinkAccent
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    for (final guide in guides) {
      canvas.drawLine(guide.start, guide.end, paint);
    }
  }

  @override
  bool shouldRepaint(covariant SnappingGuidesPainter oldDelegate) => true;
}
