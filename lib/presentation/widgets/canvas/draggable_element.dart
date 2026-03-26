import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:math' as math;
import '../../../domain/models/models.dart';
import '../../../domain/providers/project_provider.dart';

class DraggableElement extends ConsumerStatefulWidget {
  final CanvasElement element;

  const DraggableElement({
    super.key,
    required this.element,
  });

  @override
  ConsumerState<DraggableElement> createState() => _DraggableElementState();
}

class _DraggableElementState extends ConsumerState<DraggableElement> with SingleTickerProviderStateMixin {
  late Offset _position;
  late double _rotation;
  late double _scale;
  late Size _size;

  // Animation for momentum
  late AnimationController _momentumController;
  late Animation<Offset> _momentumAnimation;

  @override
  void initState() {
    super.initState();
    _position = widget.element.position;
    _rotation = widget.element.rotation;
    _scale = widget.element.scale;
    _size = widget.element.size;

    _momentumController = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _momentumController.dispose();
    super.dispose();
  }

  void _onPanUpdate(DragUpdateDetails details) {
    if (widget.element.isLocked) return;

    setState(() {
      _position += details.delta;
    });

    // Update state in provider (debounced in a real app, or handled on pan end)
  }

  void _onPanEnd(DragEndDetails details) {
    if (widget.element.isLocked) return;

    final velocity = details.velocity.pixelsPerSecond;
    if (velocity.distance > 0) {
      _startMomentum(velocity);
    } else {
      _finalizePosition();
    }
  }

  void _startMomentum(Offset velocity) {
    final simulation = FrictionSimulation(0.1, 0, velocity.distance);
    _momentumAnimation = _momentumController.drive(
      Tween<Offset>(
        begin: _position,
        end: _position + (velocity / 10),
      ),
    );

    _momentumController.addListener(() {
      setState(() {
        _position = _momentumAnimation.value;
      });
    });

    _momentumController.animateWith(simulation).then((_) {
      _finalizePosition();
      _momentumController.removeListener(() {}); // Clean up
    });
  }

  void _finalizePosition() {
    ref.read(projectProvider.notifier).updateElement(
          widget.element.id,
          (e) => e.copyWith(position: _position),
        );
  }

  @override
  Widget build(BuildContext context) {
    final isSelected = ref.watch(selectedElementIdProvider) == widget.element.id;

    return Positioned(
      left: _position.dx,
      top: _position.dy,
      child: GestureDetector(
        onPanUpdate: _onPanUpdate,
        onPanEnd: _onPanEnd,
        onTap: () {
          ref.read(selectedElementIdProvider.notifier).select(widget.element.id);
        },
        child: MouseRegion(
          cursor: SystemMouseCursors.move,
          child: Transform.rotate(
            angle: _rotation,
            child: Transform.scale(
              scale: _scale,
              child: Opacity(
                opacity: widget.element.isVisible ? 1.0 : 0.0,
                child: Container(
                  width: _size.width,
                  height: _size.height,
                  decoration: BoxDecoration(
                    border: isSelected ? Border.all(color: Colors.blue, width: 2) : null,
                  ),
                  child: Stack(
                    children: [
                      _buildElementContent(),
                      if (isSelected) _buildSelectionHandles(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildElementContent() {
    switch (widget.element.type) {
      case ElementType.image:
        return Image.network(
          widget.element.content,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => Container(
            color: Colors.grey[200],
            child: const Icon(Icons.image),
          ),
        );
      case ElementType.text:
        final textElement = widget.element as TextElement;
        return Text(
          textElement.content,
          style: TextStyle(
            fontSize: textElement.fontSize,
            color: textElement.color,
            fontFamily: textElement.fontFamily,
          ),
          textAlign: textElement.textAlign,
        );
      case ElementType.video:
        return Container(
          color: Colors.black,
          child: const Center(
            child: Icon(Icons.play_circle_fill, color: Colors.white, size: 48),
          ),
        );
      default:
        return Container(color: Colors.red);
    }
  }

  Widget _buildSelectionHandles() {
    // Basic implementation of resize/rotate handles
    return Stack(
      children: [
        // Top-left handle
        Positioned(
          left: -10,
          top: -10,
          child: _handleWidget(),
        ),
        // Top-right handle
        Positioned(
          right: -10,
          top: -10,
          child: _handleWidget(),
        ),
        // Bottom-left handle
        Positioned(
          left: -10,
          bottom: -10,
          child: _handleWidget(),
        ),
        // Bottom-right handle
        Positioned(
          right: -10,
          bottom: -10,
          child: _handleWidget(),
        ),
      ],
    );
  }

  Widget _handleWidget() {
    return Container(
      width: 20,
      height: 20,
      decoration: const BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 4)],
      ),
    );
  }
}

class FrictionSimulation extends Simulation {
  final double drag;
  final double start;
  final double velocity;

  FrictionSimulation(this.drag, this.start, this.velocity);

  @override
  double x(double time) {
    return start + (velocity / drag) * (1 - math.exp(-drag * time));
  }

  @override
  double dx(double time) {
    return velocity * math.exp(-drag * time);
  }

  @override
  bool isDone(double time) {
    return dx(time).abs() < 1.0;
  }
}
