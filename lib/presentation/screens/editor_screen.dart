import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../widgets/canvas/infinite_canvas.dart';
import '../../domain/providers/project_provider.dart';
import '../../domain/models/models.dart';
import 'dart:ui';

class EditorScreen extends ConsumerWidget {
  const EditorScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F2),
      body: Row(
        children: [
          // Sidebar
          const Sidebar(),
          // Main Editor Area
          Expanded(
            child: Column(
              children: [
                // Top Bar
                const TopBar(),
                // Canvas Area
                const Expanded(
                  child: InfiniteCanvas(),
                ),
                // Bottom Toolbar
                const BottomToolbar(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class Sidebar extends ConsumerWidget {
  const Sidebar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      width: 260,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.8),
        border: const Border(right: BorderSide(color: Colors.black12)),
      ),
      child: ClipRRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(24.0),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.deepPurple, Colors.indigo],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.auto_awesome, color: Colors.white),
                    SizedBox(width: 12),
                    Text(
                      'Design Hub',
                      style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  children: [
                    const SizedBox(height: 16),
                    _SidebarItem(
                      icon: Icons.text_fields,
                      label: 'Add Text',
                      onTap: () {
                        ref.read(projectProvider.notifier).addElement(
                              TextElement(
                                content: 'New Text',
                                position: const Offset(100, 100),
                                fontSize: 40,
                                color: Colors.black,
                              ),
                            );
                      },
                    ),
                    _SidebarItem(
                      icon: Icons.image,
                      label: 'Add Image',
                      onTap: () {
                        ref.read(projectProvider.notifier).addElement(
                              ImageElement(
                                content: 'https://picsum.photos/400/400',
                                position: const Offset(150, 150),
                                size: const Size(200, 200),
                              ),
                            );
                      },
                    ),
                    _SidebarItem(
                      icon: Icons.video_collection,
                      label: 'Add Video',
                      onTap: () {
                        ref.read(projectProvider.notifier).addElement(
                              VideoElement(
                                content: 'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4',
                                position: const Offset(200, 200),
                                size: const Size(300, 200),
                              ),
                            );
                      },
                    ),
                    _SidebarItem(
                      icon: Icons.music_note,
                      label: 'Add Audio',
                      onTap: () {},
                    ),
                    const Divider(height: 32),
                    const Text('Templates', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black54)),
                    const SizedBox(height: 12),
                    _TemplateThumbnail(label: 'Social Media Post'),
                    _TemplateThumbnail(label: 'Video Intro'),
                    _TemplateThumbnail(label: 'Product Promo'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SidebarItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _SidebarItem({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: ListTile(
        leading: Icon(icon, color: Colors.deepPurple),
        title: Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
        onTap: onTap,
        tileColor: Colors.deepPurple.withOpacity(0.05),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        hoverColor: Colors.deepPurple.withOpacity(0.1),
      ),
    );
  }
}

class _TemplateThumbnail extends StatelessWidget {
  final String label;

  const _TemplateThumbnail({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      height: 120,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(16),
        image: const DecorationImage(
          image: NetworkImage('https://picsum.photos/300/150'),
          fit: BoxFit.cover,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      alignment: Alignment.bottomCenter,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(16), bottomRight: Radius.circular(16)),
          gradient: LinearGradient(
            colors: [Colors.black.withOpacity(0.8), Colors.transparent],
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
          ),
        ),
        child: Text(
          label,
          style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
          textAlign: TextAlign.left,
        ),
      ),
    );
  }
}

class TopBar extends ConsumerWidget {
  const TopBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final project = ref.watch(projectProvider);

    return Container(
      height: 70,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            project.name,
            style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 18, color: Colors.black87),
          ),
          Row(
            children: [
              IconButton(onPressed: () {}, icon: const Icon(Icons.undo_rounded)),
              IconButton(onPressed: () {}, icon: const Icon(Icons.redo_rounded)),
              const SizedBox(width: 16),
              Container(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(colors: [Colors.deepPurple, Colors.indigo]),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.deepPurple.withOpacity(0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.local_fire_department_rounded, size: 20),
                  label: const Text('Export Video', style: TextStyle(fontWeight: FontWeight.bold)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    foregroundColor: Colors.white,
                    shadowColor: Colors.transparent,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class BottomToolbar extends ConsumerWidget {
  const BottomToolbar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedElement = ref.watch(selectedElementProvider);

    return Container(
      height: 140,
      margin: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: Colors.white.withOpacity(0.5)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 30,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: selectedElement == null
                ? const Center(
                    child: Text(
                      'Select an element to unlock creative tools',
                      style: TextStyle(color: Colors.black38, fontWeight: FontWeight.w500),
                    ),
                  )
                : Row(
                    children: [
                      _ToolButton(
                        icon: Icons.delete_outline_rounded,
                        label: 'Delete',
                        color: Colors.redAccent,
                        onTap: () {
                          ref.read(projectProvider.notifier).removeElement(selectedElement.id);
                          ref.read(selectedElementIdProvider.notifier).select(null);
                        },
                      ),
                      _ToolButton(icon: Icons.copy_rounded, label: 'Duplicate', onTap: () {}),
                      _ToolButton(icon: Icons.layers_outlined, label: 'Layers', onTap: () {}),
                      const VerticalDivider(width: 48, indent: 12, endIndent: 12),
                      if (selectedElement.type == ElementType.text) ...[
                        _ToolButton(icon: Icons.font_download_outlined, label: 'Font', onTap: () {}),
                        _ToolButton(icon: Icons.palette_outlined, label: 'Color', onTap: () {}),
                        _ToolButton(icon: Icons.animation_rounded, label: 'Animate', onTap: () {}),
                      ],
                      if (selectedElement.type == ElementType.video) ...[
                        _ToolButton(icon: Icons.content_cut_rounded, label: 'Trim', onTap: () {}),
                        _ToolButton(icon: Icons.volume_up_outlined, label: 'Sound', onTap: () {}),
                        _ToolButton(icon: Icons.slow_motion_video_rounded, label: 'Speed', onTap: () {}),
                      ],
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}

class _ToolButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color? color;

  const _ToolButton({
    required this.icon,
    required this.label,
    required this.onTap,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            onPressed: onTap,
            icon: Icon(icon, color: color ?? Colors.deepPurple, size: 26),
            style: IconButton.styleFrom(
              backgroundColor: (color ?? Colors.deepPurple).withOpacity(0.08),
              padding: const EdgeInsets.all(12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            ),
          ),
          const SizedBox(height: 6),
          Text(label, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Colors.black54)),
        ],
      ),
    );
  }
}
