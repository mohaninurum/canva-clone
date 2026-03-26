import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';

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
    state = state.copyWith(
      elements: [...state.elements, element],
      selectedIds: [element.id],
    );
  }

  void updateElement(CanvasElement element) {
    _saveHistory();
    state = state.copyWith(
      elements: state.elements.map((e) => e.id == element.id ? element : e).toList(),
    );
  }

  void removeElement(String id) {
    _saveHistory();
    state = state.copyWith(
      elements: state.elements.where((e) => e.id != id).toList(),
      selectedIds: state.selectedIds.where((selectedId) => selectedId != id).toList(),
    );
  }

  void selectElement(String id, {bool multiSelect = false}) {
    if (multiSelect) {
      if (state.selectedIds.contains(id)) {
        state = state.copyWith(
          selectedIds: state.selectedIds.where((e) => e != id).toList(),
        );
      } else {
        state = state.copyWith(
          selectedIds: [...state.selectedIds, id],
        );
      }
    } else {
      state = state.copyWith(selectedIds: [id]);
    }
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
    
    final newElements = List<CanvasElement>.from(state.elements);
    for (final id in state.selectedIds) {
      final index = newElements.indexWhere((e) => e.id == id);
      if (index != -1 && index < newElements.length - 1) {
        final element = newElements.removeAt(index);
        newElements.insert(index + 1, element);
      }
    }
    state = state.copyWith(elements: newElements);
  }

  void sendBackward() {
    if (state.selectedIds.isEmpty) return;
    _saveHistory();

    final newElements = List<CanvasElement>.from(state.elements);
    final indicesToMove = <int>[];
    for (final id in state.selectedIds) {
      final index = newElements.indexWhere((e) => e.id == id);
      if (index != -1) {
        indicesToMove.add(index);
      }
    }
    indicesToMove.sort();

    for (final index in indicesToMove) {
      if (index > 0) {
        final element = newElements.removeAt(index);
        newElements.insert(index - 1, element);
      }
    }
    state = state.copyWith(elements: newElements);
  }

  void undo() {
    if (_undoStack.isEmpty) return;
    _redoStack.add(state);
    final previousState = _undoStack.removeLast();
    state = previousState;
  }

  void redo() {
    if (_redoStack.isEmpty) return;
    _undoStack.add(state);
    final nextState = _redoStack.removeLast();
    state = nextState;
  }

  Future<void> saveToJson() async {
    try {
      final jsonList = state.elements.map((e) => e.toJson()).toList();
      final jsonString = jsonEncode(jsonList);
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/canvas_save.json');
      await file.writeAsString(jsonString);
    } catch (e) {
      debugPrint("Save error: $e");
    }
  }

  Future<void> loadFromJson() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/canvas_save.json');
      if (await file.exists()) {
        final jsonString = await file.readAsString();
        final List<dynamic> jsonList = jsonDecode(jsonString);
        
        final loadedElements = jsonList.map((j) {
           final map = j as Map<String, dynamic>;
           final type = map['type'] as String;
           
           final position = Offset(map['position']['dx'], map['position']['dy']);
           final size = Size(map['size']['width'], map['size']['height']);
           final rotation = (map['rotation'] as num).toDouble();
           final opacity = (map['opacity'] as num).toDouble();
           final id = map['id'] as String;

           if (type == ElementType.text.name) {
             return TextElement(
               id: id, position: position, size: size,
               rotation: rotation, opacity: opacity,
               text: map['text'], 
               fontSize: (map['fontSize'] as num).toDouble(),
               color: Color(map['color']),
             );
           } else if (type == ElementType.shape.name) {
             return ShapeElement(
               id: id, position: position, size: size,
               rotation: rotation, opacity: opacity,
               shapeType: ShapeType.values.firstWhere((e) => e.name == map['shapeType']),
               color: Color(map['color'])
             );
           } else {
             return ImageElement(
               id: id, position: position, size: size,
               rotation: rotation, opacity: opacity,
               imagePath: map['imagePath']
             );
           }
        }).toList();

        state = state.copyWith(elements: loadedElements, selectedIds: []);
        _undoStack.clear();
        _redoStack.clear();
      }
    } catch (e) {
      debugPrint("Load error: $e");
    }
  }
}
