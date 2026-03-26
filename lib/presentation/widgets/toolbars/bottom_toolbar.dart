import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../domain/models/canvas_element.dart';
import '../../providers/editor_provider.dart';

class BottomToolbar extends ConsumerWidget {
  const BottomToolbar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Rebuild when selection changes
    final selectedIds = ref.watch(editorProvider.select((s) => s.selectedIds));
    final elements = ref.watch(editorProvider.select((s) => s.elements));
    
    if (selectedIds.isEmpty) {
      return const SizedBox.shrink();
    }

    // Single selection properties
    final selectedElement = elements.firstWhere(
      (e) => e.id == selectedIds.first, 
      orElse: () => elements.first
    );

    return Container(
      height: 80,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, -2))],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildPropertyControl(
            icon: Icons.opacity,
            label: 'Opacity',
            onTap: () => _updateOpacity(ref, selectedElement),
          ),
          if (selectedElement is TextElement) ...[
            _buildPropertyControl(
              icon: Icons.format_size,
              label: 'Size +',
              onTap: () {
                ref.read(editorProvider.notifier).updateElement(
                  selectedElement.copyWith(fontSize: selectedElement.fontSize + 2)
                );
              },
            ),
            _buildPropertyControl(
              icon: Icons.format_size,
              label: 'Size -',
              onTap: () {
                ref.read(editorProvider.notifier).updateElement(
                  selectedElement.copyWith(fontSize: (selectedElement.fontSize - 2).clamp(8.0, 100.0))
                );
              },
            ),
            _buildPropertyControl(
              icon: Icons.color_lens,
              label: 'Color',
              onTap: () => _changeColor(ref, selectedElement),
            ),
          ],
          if (selectedElement is ShapeElement) ...[
            _buildPropertyControl(
              icon: Icons.color_lens,
              label: 'Color',
              onTap: () => _changeColor(ref, selectedElement),
            ),
          ],
        ],
      ),
    );
  }

  void _updateOpacity(WidgetRef ref, CanvasElement element) {
    final newOpacity = element.opacity > 0.5 ? 0.3 : 1.0;
    ref.read(editorProvider.notifier).updateElement(element.copyWith(opacity: newOpacity));
  }

  void _changeColor(WidgetRef ref, CanvasElement element) {
    // Rotate through some colors
    final colors = [Colors.red, Colors.green, Colors.blue, Colors.orange, Colors.purple, Colors.black];
    Color currentColor = Colors.black;
    if (element is TextElement) currentColor = element.color;
    if (element is ShapeElement) currentColor = element.color;

    final nextColor = colors[(colors.indexWhere((c) => c.value == currentColor.value) + 1) % colors.length];

    if (element is TextElement) {
      ref.read(editorProvider.notifier).updateElement(element.copyWith(color: nextColor));
    } else if (element is ShapeElement) {
      ref.read(editorProvider.notifier).updateElement(element.copyWith(color: nextColor));
    }
  }

  Widget _buildPropertyControl({required IconData icon, required String label, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.blueGrey),
          const SizedBox(height: 4),
          Text(label, style: const TextStyle(fontSize: 12, color: Colors.blueGrey)),
        ],
      ),
    );
  }
}
