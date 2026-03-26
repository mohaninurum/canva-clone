import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import '../../providers/editor_provider.dart';
import '../canvas/editor_canvas.dart';

class TopToolbar extends ConsumerWidget {
  const TopToolbar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      height: 60,
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.undo),
              onPressed: () => ref.read(editorProvider.notifier).undo(),
            ),
            IconButton(
              icon: const Icon(Icons.redo),
              onPressed: () => ref.read(editorProvider.notifier).redo(),
            ),
            IconButton(
              icon: const Icon(Icons.flip_to_front),
              tooltip: "Bring Forward",
              onPressed: () => ref.read(editorProvider.notifier).bringForward(),
            ),
            IconButton(
              icon: const Icon(Icons.flip_to_back),
              tooltip: "Send Backward",
              onPressed: () => ref.read(editorProvider.notifier).sendBackward(),
            ),
            IconButton(
              icon: const Icon(Icons.delete),
              color: Colors.red,
              onPressed: () {
                final selectedIds = ref.read(editorProvider).selectedIds;
                for (final id in selectedIds) {
                  ref.read(editorProvider.notifier).removeElement(id);
                }
              },
            ),
            const SizedBox(width: 8),
            ElevatedButton(
              onPressed: () => ref.read(editorProvider.notifier).saveToJson(),
              child: const Text('Save'),
            ),
            const SizedBox(width: 8),
            ElevatedButton(
              onPressed: () => ref.read(editorProvider.notifier).loadFromJson(),
              child: const Text('Load'),
            ),
            const SizedBox(width: 8),
            TextButton(
              onPressed: () async {
                try {
                  ref.read(editorProvider.notifier).clearSelection();
                  await Future.delayed(const Duration(milliseconds: 100)); // wait for selection removal frame

                  final controller = ref.read(screenshotControllerProvider);
                  final imageStream = await controller.capture();
                  if (imageStream != null) {
                    final directory = await getApplicationDocumentsDirectory();
                    final imagePath = await File('${directory.path}/export_${DateTime.now().millisecondsSinceEpoch}.png').create();
                    await imagePath.writeAsBytes(imageStream);

                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Saved to ${imagePath.path}')),
                      );
                    }
                  }
                } catch (e) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Failed to export: $e')),
                    );
                  }
                }
              },
              child: const Text('Export PNG'),
            ),
          ],
        ),
      ),
    );
  }
}
