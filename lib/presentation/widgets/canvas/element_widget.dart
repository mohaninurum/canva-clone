import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../domain/models/canvas_element.dart';
import '../../../domain/models/editor_state.dart';
import '../../providers/editor_provider.dart';
import '../multimedia/video_renderer.dart';
import '../multimedia/audio_renderer.dart';
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
    if (velocity.distance < 50) return;

    final frictionMultiplier = 0.2;
    
    _controller.stop();
    _animation = Tween<Offset>(
      begin: widget.element.position,
      end: widget.element.position + (velocity * frictionMultiplier),
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
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
      );
    } else if (element is ShapeElement) {
      child = Container(
        decoration: BoxDecoration(
          color: element.color,
          shape: element.shapeType == ShapeType.circle ? BoxShape.circle : BoxShape.rectangle,
          boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, 5))],
        ),
      );
    } else if (element is VideoElement) {
      child = VideoRenderer(element: element);
    } else if (element is AudioElement) {
      child = AudioRenderer(element: element);
    } else {
      child = Container(
        color: Colors.grey[300],
        child: const Center(child: Icon(Icons.image, size: 40)),
      );
    }

    return Positioned(
      left: element.position.dx,
      top: element.position.dy,
      child: RepaintBoundary(
        child: GestureDetector(
          onScaleStart: (details) {
            _controller.stop();
            ref.read(editorProvider.notifier).selectElement(element.id);
            _initialRotation = element.rotation;
            _initialSize = element.size;
          },
          onScaleUpdate: (details) {
            Offset newPos = element.position + details.focalPointDelta;
            final newWidth = math.max(20.0, _initialSize.width * details.scale);
            final newHeight = math.max(20.0, _initialSize.height * details.scale);
            
            final snapThreshold = 10.0;
            List<SnappingGuide> activeGuides = [];
            final canvasCenter = Offset(960, 540); 
            final elementCenter = Offset(newPos.dx + newWidth / 2, newPos.dy + newHeight / 2);

            if ((elementCenter.dx - canvasCenter.dx).abs() < snapThreshold) {
              newPos = Offset(canvasCenter.dx - newWidth / 2, newPos.dy);
              activeGuides.add(SnappingGuide(Offset(canvasCenter.dx, 0), Offset(canvasCenter.dx, 1080)));
            }
            if ((elementCenter.dy - canvasCenter.dy).abs() < snapThreshold) {
              newPos = Offset(newPos.dx, canvasCenter.dy - newHeight / 2);
              activeGuides.add(SnappingGuide(Offset(0, canvasCenter.dy), Offset(1920, canvasCenter.dy)));
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
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
