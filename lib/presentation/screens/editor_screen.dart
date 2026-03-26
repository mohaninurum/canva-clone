import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../widgets/canvas/canvas_workspace.dart';
import '../widgets/toolbars/top_toolbar.dart';
import '../widgets/toolbars/bottom_toolbar.dart';
import '../widgets/toolbars/left_sidebar.dart';

class EditorScreen extends ConsumerWidget {
  const EditorScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: Column(
          children: [
            const TopToolbar(),
            Expanded(
              child: Row(
                children: [
                  const LeftSidebar(),
                  Expanded(
                    child: Stack(
                      children: const [
                        CanvasWorkspace(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const BottomToolbar(),
          ],
        ),
      ),
    );
  }
}
