import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../domain/models/canvas_element.dart';
import '../../providers/editor_provider.dart';

class BottomToolbar extends ConsumerWidget {
  const BottomToolbar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedIds = ref.watch(editorProvider.select((s) => s.selectedIds));
    if (selectedIds.isEmpty) return const SizedBox.shrink();

    final id = selectedIds.first;
    final state = ref.read(editorProvider);
    final element = state.elements.firstWhere((e) => e.id == id, orElse: () => state.elements.first);

    return Container(
      height: 60,
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildOpacitySlider(ref, element),
          if (element is VideoElement || element is AudioElement)
            _buildVolumeSlider(ref, element),
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            onPressed: () => ref.read(editorProvider.notifier).removeElement(element.id),
          ),
        ],
      ),
    );
  }

  Widget _buildOpacitySlider(WidgetRef ref, CanvasElement element) {
    return Row(
      children: [
        const Icon(Icons.opacity, size: 20),
        SizedBox(
          width: 150,
          child: Slider(
            value: element.opacity,
            onChanged: (val) {
              ref.read(editorProvider.notifier).updateElement(element.copyWith(opacity: val));
            },
          ),
        ),
      ],
    );
  }

  Widget _buildVolumeSlider(WidgetRef ref, dynamic element) {
    return Row(
      children: [
        const Icon(Icons.volume_up, size: 20),
        SizedBox(
          width: 150,
          child: Slider(
            value: element.volume,
            onChanged: (val) {
              ref.read(editorProvider.notifier).updateElement(element.copyWith(volume: val));
            },
          ),
        ),
      ],
    );
  }
}
