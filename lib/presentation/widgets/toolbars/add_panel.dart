import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../../domain/models/canvas_element.dart';
import '../../providers/editor_provider.dart';

class AddPanel extends ConsumerWidget {
  const AddPanel({super.key});

  void _addText(WidgetRef ref, BuildContext context) {
    final e = TextElement(
      id: const Uuid().v4(),
      position: const Offset(400, 400),
      size: const Size(200, 50),
    );
    ref.read(editorProvider.notifier).addElement(e);
    Navigator.pop(context);
  }

  void _addShape(WidgetRef ref, BuildContext context, ShapeType type) {
    final e = ShapeElement(
      id: const Uuid().v4(),
      position: const Offset(400, 400),
      size: const Size(100, 100),
      shapeType: type,
    );
    ref.read(editorProvider.notifier).addElement(e);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.all(16),
      height: 250,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Add Element', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildAddButton(Icons.text_fields, 'Text', () => _addText(ref, context)),
              _buildAddButton(Icons.rectangle, 'Rectangle', () => _addShape(ref, context, ShapeType.rectangle)),
              _buildAddButton(Icons.circle, 'Circle', () => _addShape(ref, context, ShapeType.circle)),
              _buildAddButton(Icons.image, 'Image', () {
                // TODO: image picker
                Navigator.pop(context);
              }),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAddButton(IconData icon, String label, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          CircleAvatar(radius: 30, child: Icon(icon, size: 30)),
          const SizedBox(height: 8),
          Text(label),
        ],
      ),
    );
  }
}
