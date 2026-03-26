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
    final elements = ref.watch(editorProvider.select((s) => s.elements));
    final controller = ref.watch(screenshotControllerProvider);

    return GestureDetector(
      onTap: () {
        ref.read(editorProvider.notifier).clearSelection();
      },
      child: Screenshot(
        controller: controller,
        child: Container(
          width: 1920, // 1080p canvas equivalent
          height: 1080,
          decoration: const BoxDecoration(
            color: Colors.white,
            boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 20)],
          ),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              ...elements.map((e) => ElementWidget(key: ValueKey(e.id), element: e)),
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
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;

    for (final guide in guides) {
      canvas.drawLine(guide.start, guide.end, paint);
    }
  }

  @override
  bool shouldRepaint(covariant SnappingGuidesPainter oldDelegate) => true;
}
