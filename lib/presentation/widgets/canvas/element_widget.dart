import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../domain/models/canvas_element.dart';
import '../../../domain/models/editor_state.dart';
import '../../providers/editor_provider.dart';
import 'dart:math' as math;

class ElementWidget extends ConsumerStatefulWidget {
  final CanvasElement element;
  
  const ElementWidget({super.key, required this.element});

  @override
  ConsumerState<ElementWidget> createState() => _ElementWidgetState();
}

class _ElementWidgetState extends ConsumerState<ElementWidget> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  Animation<Offset>? _animation;
  
  double _initialRotation = 0.0;
  Size _initialSize = Size.zero;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
    _controller.addListener(() {
      if (_animation != null) {
        ref.read(editorProvider.notifier).updateElement(
          widget.element.copyWith(position: _animation!.value)
        );
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _runAntigravity(Offset velocity) {
    if (velocity.distance < 50) return; // Minimum velocity required

    final frictionMultiplier = 0.2; // Slide distance scale
    
    _controller.stop();
    _animation = Tween<Offset>(
      begin: widget.element.position,
      end: widget.element.position + (velocity * frictionMultiplier),
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic, // Snappy antigravity easing
    ));
    _controller.duration = const Duration(milliseconds: 700);
    _controller.forward(from: 0);
  }

  @override
  Widget build(BuildContext context) {
    final isSelected = ref.watch(editorProvider.select((s) => s.selectedIds.contains(widget.element.id)));
    final element = widget.element;

    Widget child;
    if (element is TextElement) {
      child = Text(
        element.text,
        style: TextStyle(
          fontSize: element.fontSize,
          color: element.color,
          fontWeight: element.fontWeight,
        ),
        textAlign: element.textAlign,
      );
    } else if (element is ShapeElement) {
      child = Container(
        decoration: BoxDecoration(
          color: element.color,
          shape: element.shapeType == ShapeType.circle ? BoxShape.circle : BoxShape.rectangle,
          boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, 5))],
        ),
      );
    } else {
      child = Container(
        color: Colors.grey[300],
        child: const Center(child: Icon(Icons.image, size: 40)),
      );
    }

    return Positioned(
      left: element.position.dx,
      top: element.position.dy,
      child: RepaintBoundary( // Crucial for performance while translating position
        child: GestureDetector(
          onScaleStart: (details) {
            _controller.stop(); // Intercept gliding
            ref.read(editorProvider.notifier).selectElement(element.id);
            _initialRotation = element.rotation;
            _initialSize = element.size;
          },
          onScaleUpdate: (details) {
            Offset newPos = element.position + details.focalPointDelta;
            final newWidth = math.max(20.0, _initialSize.width * details.scale);
            final newHeight = math.max(20.0, _initialSize.height * details.scale);
            
            // Snapping Logic
            final snapThreshold = 10.0;
            List<SnappingGuide> activeGuides = [];
            final canvasCenter = const Offset(540, 540); // 1080/2
            final elementCenter = Offset(newPos.dx + newWidth / 2, newPos.dy + newHeight / 2);

            if ((elementCenter.dx - canvasCenter.dx).abs() < snapThreshold) {
              newPos = Offset(canvasCenter.dx - newWidth / 2, newPos.dy);
              activeGuides.add(SnappingGuide(Offset(canvasCenter.dx, 0), Offset(canvasCenter.dx, 1080)));
            }
            if ((elementCenter.dy - canvasCenter.dy).abs() < snapThreshold) {
              newPos = Offset(newPos.dx, canvasCenter.dy - newHeight / 2);
              activeGuides.add(SnappingGuide(const Offset(0, 540), const Offset(1080, 540)));
            }

            ref.read(editorProvider.notifier).setSnappingGuides(activeGuides);

            ref.read(editorProvider.notifier).updateElement(
              element.copyWith(
                position: newPos,
                size: Size(newWidth, newHeight),
                rotation: _initialRotation + details.rotation,
              )
            );
          },
          onScaleEnd: (details) {
            ref.read(editorProvider.notifier).clearSnappingGuides();
            _runAntigravity(details.velocity.pixelsPerSecond);
          },
          child: Transform.rotate(
            angle: element.rotation,
            // Use fractionalOffset to ensure rotation is smoothly centered
            alignment: FractionalOffset.center,
            child: Opacity(
              opacity: element.opacity,
              child: Container(
                width: element.size.width,
                height: element.size.height,
                decoration: isSelected ? BoxDecoration(
                  border: Border.all(color: Colors.blueAccent, width: 2),
                ) : null,
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Positioned.fill(child: child),
                    if (isSelected) ..._buildHandles(ref, element),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildHandles(WidgetRef ref, CanvasElement element) {
    // Only manual resizing handle since scaling gesture exists now
    return [
      Positioned(
        right: -10,
        bottom: -10,
        child: GestureDetector(
          onPanUpdate: (details) {
            final newWidth = math.max(20.0, element.size.width + details.delta.dx);
            final newHeight = math.max(20.0, element.size.height + details.delta.dy);
            ref.read(editorProvider.notifier).updateElement(
              element.copyWith(size: Size(newWidth, newHeight))
            );
          },
          child: Container(
            width: 20, height: 20,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              border: Border.fromBorderSide(BorderSide(color: Colors.blue)),
            ),
          ),
        ),
      ),
    ];
  }
}
