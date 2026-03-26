import 'package:flutter/material.dart';
import 'canvas_element.dart';

class SnappingGuide {
  final Offset start;
  final Offset end;
  const SnappingGuide(this.start, this.end);
}

class EditorState {
  final List<CanvasElement> elements;
  final List<String> selectedIds;
  final List<SnappingGuide> snappingGuides;

  const EditorState({
    this.elements = const [],
    this.selectedIds = const [],
    this.snappingGuides = const [],
  });

  EditorState copyWith({
    List<CanvasElement>? elements,
    List<String>? selectedIds,
    List<SnappingGuide>? snappingGuides,
  }) {
    return EditorState(
      elements: elements ?? this.elements,
      selectedIds: selectedIds ?? this.selectedIds,
      snappingGuides: snappingGuides ?? this.snappingGuides,
    );
  }
}
