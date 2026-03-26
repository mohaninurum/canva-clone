import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/canvas_element.dart';
import '../../domain/models/editor_state.dart';

final editorProvider = NotifierProvider<EditorNotifier, EditorState>(() {
  return EditorNotifier();
});

class EditorNotifier extends Notifier<EditorState> {
  @override
  EditorState build() => const EditorState();

  final List<EditorState> _undoStack = [];
  final List<EditorState> _redoStack = [];

  void _saveHistory() {
    _undoStack.add(state);
    _redoStack.clear();
  }

  void addElement(CanvasElement element) {
    _saveHistory();
    state = state.copyWith(elements: [...state.elements, element]);
  }

  void updateElement(CanvasElement element) {
    final elements = state.elements.map((e) => e.id == element.id ? element : e).toList();
    state = state.copyWith(elements: elements);
  }

  void saveHistoryEvent() {
    _saveHistory();
  }

  void removeElement(String id) {
    _saveHistory();
    final elements = state.elements.where((e) => e.id != id).toList();
    state = state.copyWith(
      elements: elements,
      selectedIds: state.selectedIds.where((sid) => sid != id).toList(),
    );
  }

  void selectElement(String id) {
    state = state.copyWith(selectedIds: [id]);
  }

  void clearSelection() {
    state = state.copyWith(selectedIds: []);
  }

  void setSnappingGuides(List<SnappingGuide> guides) {
    state = state.copyWith(snappingGuides: guides);
  }

  void clearSnappingGuides() {
    if (state.snappingGuides.isNotEmpty) {
      state = state.copyWith(snappingGuides: []);
    }
  }

  void bringForward() {
    if (state.selectedIds.isEmpty) return;
    _saveHistory();
    final id = state.selectedIds.first;
    final elements = List<CanvasElement>.from(state.elements);
    final index = elements.indexWhere((e) => e.id == id);
    if (index >= 0 && index < elements.length - 1) {
      final elem = elements.removeAt(index);
      elements.insert(index + 1, elem);
      state = state.copyWith(elements: elements);
    }
  }

  void sendBackward() {
    if (state.selectedIds.isEmpty) return;
    _saveHistory();
    final id = state.selectedIds.first;
    final elements = List<CanvasElement>.from(state.elements);
    final index = elements.indexWhere((e) => e.id == id);
    if (index > 0) {
      final elem = elements.removeAt(index);
      elements.insert(index - 1, elem);
      state = state.copyWith(elements: elements);
    }
  }

  void undo() {
    if (_undoStack.isEmpty) return;
    _redoStack.add(state);
    state = _undoStack.removeLast();
  }

  void redo() {
    if (_redoStack.isEmpty) return;
    _undoStack.add(state);
    state = _redoStack.removeLast();
  }

  String saveToJson() {
    final elementMaps = state.elements.map((e) => e.toJson()).toList();
    return jsonEncode({'elements': elementMaps});
  }
}
