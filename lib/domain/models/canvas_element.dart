import 'package:flutter/material.dart';

abstract class CanvasElement {
  final String id;
  final Offset position;
  final Size size;
  final double rotation;
  final double opacity;
  final int zIndex;

  const CanvasElement({
    required this.id,
    required this.position,
    required this.size,
    this.rotation = 0.0,
    this.opacity = 1.0,
    this.zIndex = 0,
  });

  CanvasElement copyWith({
    Offset? position,
    Size? size,
    double? rotation,
    double? opacity,
    int? zIndex,
  });

  Map<String, dynamic> toJson();
}

class TextElement extends CanvasElement {
  final String text;
  final Color color;
  final double fontSize;
  final FontWeight fontWeight;

  const TextElement({
    required super.id,
    required super.position,
    required super.size,
    super.rotation,
    super.opacity,
    super.zIndex,
    required this.text,
    this.color = Colors.black,
    this.fontSize = 24,
    this.fontWeight = FontWeight.normal,
  });

  @override
  TextElement copyWith({
    Offset? position,
    Size? size,
    double? rotation,
    double? opacity,
    int? zIndex,
    String? text,
    Color? color,
    double? fontSize,
    FontWeight? fontWeight,
  }) {
    return TextElement(
      id: id,
      position: position ?? this.position,
      size: size ?? this.size,
      rotation: rotation ?? this.rotation,
      opacity: opacity ?? this.opacity,
      zIndex: zIndex ?? this.zIndex,
      text: text ?? this.text,
      color: color ?? this.color,
      fontSize: fontSize ?? this.fontSize,
      fontWeight: fontWeight ?? this.fontWeight,
    );
  }

  @override
  Map<String, dynamic> toJson() => {
    'type': 'text',
    'id': id,
    'position': [position.dx, position.dy],
    'size': [size.width, size.height],
    'rotation': rotation,
    'opacity': opacity,
    'zIndex': zIndex,
    'text': text,
    'color': color.toARGB32(),
    'fontSize': fontSize,
  };
}

class VideoElement extends CanvasElement {
  final String path;
  final double volume;
  final bool isLooping;

  const VideoElement({
    required super.id,
    required super.position,
    required super.size,
    super.rotation,
    super.opacity,
    super.zIndex,
    required this.path,
    this.volume = 1.0,
    this.isLooping = true,
  });

  @override
  VideoElement copyWith({
    Offset? position,
    Size? size,
    double? rotation,
    double? opacity,
    int? zIndex,
    String? path,
    double? volume,
    bool? isLooping,
  }) {
    return VideoElement(
      id: id,
      position: position ?? this.position,
      size: size ?? this.size,
      rotation: rotation ?? this.rotation,
      opacity: opacity ?? this.opacity,
      zIndex: zIndex ?? this.zIndex,
      path: path ?? this.path,
      volume: volume ?? this.volume,
      isLooping: isLooping ?? this.isLooping,
    );
  }

  @override
  Map<String, dynamic> toJson() => {
    'type': 'video',
    'id': id,
    'position': [position.dx, position.dy],
    'size': [size.width, size.height],
    'rotation': rotation,
    'opacity': opacity,
    'zIndex': zIndex,
    'path': path,
    'volume': volume,
  };
}

class AudioElement extends CanvasElement {
  final String path;
  final double volume;
  final bool isLooping;

  const AudioElement({
    required super.id,
    required super.position,
    required super.size,
    super.rotation,
    super.opacity,
    super.zIndex,
    required this.path,
    this.volume = 1.0,
    this.isLooping = true,
  });

  @override
  AudioElement copyWith({
    Offset? position,
    Size? size,
    double? rotation,
    double? opacity,
    int? zIndex,
    String? path,
    double? volume,
    bool? isLooping,
  }) {
    return AudioElement(
      id: id,
      position: position ?? this.position,
      size: size ?? this.size,
      rotation: rotation ?? this.rotation,
      opacity: opacity ?? this.opacity,
      zIndex: zIndex ?? this.zIndex,
      path: path ?? this.path,
      volume: volume ?? this.volume,
      isLooping: isLooping ?? this.isLooping,
    );
  }

  @override
  Map<String, dynamic> toJson() => {
    'type': 'audio',
    'id': id,
    'position': [position.dx, position.dy],
    'size': [size.width, size.height],
    'rotation': rotation,
    'opacity': opacity,
    'zIndex': zIndex,
    'path': path,
    'volume': volume,
  };
}

enum ShapeType { rectangle, circle }

class ShapeElement extends CanvasElement {
  final ShapeType shapeType;
  final Color color;

  const ShapeElement({
    required super.id,
    required super.position,
    required super.size,
    super.rotation,
    super.opacity,
    super.zIndex,
    required this.shapeType,
    this.color = Colors.blue,
  });

  @override
  ShapeElement copyWith({
    Offset? position,
    Size? size,
    double? rotation,
    double? opacity,
    int? zIndex,
    ShapeType? shapeType,
    Color? color,
  }) {
    return ShapeElement(
      id: id,
      position: position ?? this.position,
      size: size ?? this.size,
      rotation: rotation ?? this.rotation,
      opacity: opacity ?? this.opacity,
      zIndex: zIndex ?? this.zIndex,
      shapeType: shapeType ?? this.shapeType,
      color: color ?? this.color,
    );
  }

  @override
  Map<String, dynamic> toJson() => {
    'type': 'shape',
    'id': id,
    'position': [position.dx, position.dy],
    'size': [size.width, size.height],
    'rotation': rotation,
    'opacity': opacity,
    'zIndex': zIndex,
    'shapeType': shapeType.index,
    'color': color.toARGB32(),
  };
}
