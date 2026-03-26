import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/models.dart';

class ProjectNotifier extends Notifier<Project> {
  @override
  Project build() {
    return Project();
  }

  void updateProjectName(String name) {
    state = state.copyWith(name: name);
  }

  void addElement(CanvasElement element) {
    state = state.copyWith(
      elements: [...state.elements, element],
    );
  }

  void removeElement(String id) {
    state = state.copyWith(
      elements: state.elements.where((e) => e.id != id).toList(),
    );
  }

  void updateElement(String id, CanvasElement Function(CanvasElement) update) {
    state = state.copyWith(
      elements: state.elements.map((e) {
        if (e.id == id) {
          return update(e);
        }
        return e;
      }).toList(),
    );
  }

  void reorderElement(int oldIndex, int newIndex) {
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }
    final elements = List<CanvasElement>.from(state.elements);
    final element = elements.removeAt(oldIndex);
    elements.insert(newIndex, element);
    state = state.copyWith(elements: elements);
  }

  void setCanvasSize(Size size) {
    state = state.copyWith(canvasSize: size);
  }
}

final projectProvider = NotifierProvider<ProjectNotifier, Project>(() {
  return ProjectNotifier();
});

class SelectedElementNotifier extends Notifier<String?> {
  @override
  String? build() => null;

  void select(String? id) => state = id;
}

final selectedElementIdProvider = NotifierProvider<SelectedElementNotifier, String?>(() {
  return SelectedElementNotifier();
});

final selectedElementProvider = Provider<CanvasElement?>((ref) {
  final project = ref.watch(projectProvider);
  final selectedId = ref.watch(selectedElementIdProvider);
  if (selectedId == null) return null;
  try {
    return project.elements.firstWhere((e) => e.id == selectedId);
  } catch (_) {
    return null;
  }
});
