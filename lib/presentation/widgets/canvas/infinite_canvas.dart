import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../domain/providers/project_provider.dart';
import 'draggable_element.dart';

class InfiniteCanvas extends ConsumerWidget {
  const InfiniteCanvas({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final project = ref.watch(projectProvider);
    final transformationController = TransformationController();

    return LayoutBuilder(
      builder: (context, constraints) {
        return InteractiveViewer(
          transformationController: transformationController,
          boundaryMargin: const EdgeInsets.all(double.infinity),
          minScale: 0.1,
          maxScale: 10.0,
          constrained: false,
          child: Container(
            width: project.canvasSize.width,
            height: project.canvasSize.height,
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 20,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                // Grid background (Optional but helpful)
                Positioned.fill(
                  child: CustomPaint(
                    painter: GridPainter(),
                  ),
                ),
                // Render Canvas Elements
                ...project.elements.map((element) {
                  return DraggableElement(
                    key: ValueKey(element.id),
                    element: element,
                  );
                }).toList(),
              ],
            ),
          ),
        );
      },
    );
  }
}

class GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey.withOpacity(0.1)
      ..strokeWidth = 1.0;

    const gridSize = 50.0;
    for (double i = 0; i <= size.width; i += gridSize) {
      canvas.drawLine(Offset(i, 0), Offset(i, size.height), paint);
    }
    for (double i = 0; i <= size.height; i += gridSize) {
      canvas.drawLine(Offset(0, i), Offset(size.width, i), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
