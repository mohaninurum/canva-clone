import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../../domain/models/canvas_element.dart';
import '../../providers/editor_provider.dart';

class LeftSidebar extends ConsumerWidget {
  const LeftSidebar({super.key});

  void _addText(WidgetRef ref) {
    final e = TextElement(
      id: const Uuid().v4(),
      position: const Offset(400, 400),
      size: const Size(200, 50),
      text: 'Heading',
      fontSize: 32,
      fontWeight: FontWeight.bold,
    );
    ref.read(editorProvider.notifier).addElement(e);
  }

  void _addShape(WidgetRef ref, ShapeType type) {
    final e = ShapeElement(
      id: const Uuid().v4(),
      position: const Offset(400, 400),
      size: const Size(100, 100),
      shapeType: type,
    );
    ref.read(editorProvider.notifier).addElement(e);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      width: 80,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(right: BorderSide(color: Colors.grey.shade300)),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(2, 0)),
        ],
      ),
      child: Column(
        children: [
          const SizedBox(height: 16),
          _buildActionTab(Icons.dashboard, 'Templates', () {}),
          _buildActionTab(Icons.text_fields, 'Text', () => _addText(ref)),
          _buildActionTab(Icons.rectangle_outlined, 'Square', () => _addShape(ref, ShapeType.rectangle)),
          _buildActionTab(Icons.circle_outlined, 'Circle', () => _addShape(ref, ShapeType.circle)),
          _buildActionTab(Icons.cloud_upload_outlined, 'Uploads', () {}),
        ],
      ),
    );
  }

  Widget _buildActionTab(IconData icon, String label, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 72,
        alignment: Alignment.center,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: Colors.black87, size: 28),
            const SizedBox(height: 4),
            Text(label, style: const TextStyle(fontSize: 10, color: Colors.black87)),
          ],
        ),
      ),
    );
  }
}
