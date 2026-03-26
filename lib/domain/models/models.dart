import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

enum ElementType { image, video, text, audio }

abstract class CanvasElement {
  final String id;
  final String content; // Path or Text
  final ElementType type;
  final Offset position;
  final Size size;
  final double rotation;
  final double scale;
  final int zIndex;
  final bool isLocked;
  final bool isVisible;

  CanvasElement({
    String? id,
    required this.content,
    required this.type,
    this.position = Offset.zero,
    this.size = const Size(200, 200),
    this.rotation = 0,
    this.scale = 1.0,
    this.zIndex = 0,
    this.isLocked = false,
    this.isVisible = true,
  }) : id = id ?? const Uuid().v4();

  CanvasElement copyWith({
    Offset? position,
    Size? size,
    double? rotation,
    double? scale,
    int? zIndex,
    bool? isLocked,
    bool? isVisible,
    String? content,
  });

  Map<String, dynamic> toJson();
}

class ImageElement extends CanvasElement {
  ImageElement({
    super.id,
    required super.content,
    super.position,
    super.size,
    super.rotation,
    super.scale,
    super.zIndex,
    super.isLocked,
    super.isVisible,
  }) : super(type: ElementType.image);

  @override
  ImageElement copyWith({
    Offset? position,
    Size? size,
    double? rotation,
    double? scale,
    int? zIndex,
    bool? isLocked,
    bool? isVisible,
    String? content,
  }) {
    return ImageElement(
      id: id,
      content: content ?? this.content,
      position: position ?? this.position,
      size: size ?? this.size,
      rotation: rotation ?? this.rotation,
      scale: scale ?? this.scale,
      zIndex: zIndex ?? this.zIndex,
      isLocked: isLocked ?? this.isLocked,
      isVisible: isVisible ?? this.isVisible,
    );
  }

  @override
  Map<String, dynamic> toJson() => {
        'id': id,
        'type': 'image',
        'content': content,
        'x': position.dx,
        'y': position.dy,
        'width': size.width,
        'height': size.height,
        'rotation': rotation,
        'scale': scale,
        'zIndex': zIndex,
        'isLocked': isLocked,
        'isVisible': isVisible,
      };
}

class VideoElement extends CanvasElement {
  final double duration;
  final double startTrim;
  final double endTrim;

  VideoElement({
    super.id,
    required super.content,
    super.position,
    super.size,
    super.rotation,
    super.scale,
    super.zIndex,
    super.isLocked,
    super.isVisible,
    this.duration = 0,
    this.startTrim = 0,
    this.endTrim = 0,
  }) : super(type: ElementType.video);

  @override
  VideoElement copyWith({
    Offset? position,
    Size? size,
    double? rotation,
    double? scale,
    int? zIndex,
    bool? isLocked,
    bool? isVisible,
    String? content,
    double? duration,
    double? startTrim,
    double? endTrim,
  }) {
    return VideoElement(
      id: id,
      content: content ?? this.content,
      position: position ?? this.position,
      size: size ?? this.size,
      rotation: rotation ?? this.rotation,
      scale: scale ?? this.scale,
      zIndex: zIndex ?? this.zIndex,
      isLocked: isLocked ?? this.isLocked,
      isVisible: isVisible ?? this.isVisible,
      duration: duration ?? this.duration,
      startTrim: startTrim ?? this.startTrim,
      endTrim: endTrim ?? this.endTrim,
    );
  }

  @override
  Map<String, dynamic> toJson() => {
        'id': id,
        'type': 'video',
        'content': content,
        'x': position.dx,
        'y': position.dy,
        'width': size.width,
        'height': size.height,
        'rotation': rotation,
        'scale': scale,
        'zIndex': zIndex,
        'isLocked': isLocked,
        'isVisible': isVisible,
        'duration': duration,
        'startTrim': startTrim,
        'endTrim': endTrim,
      };
}

class TextElement extends CanvasElement {
  final double fontSize;
  final Color color;
  final String fontFamily;
  final TextAlign textAlign;

  TextElement({
    super.id,
    required super.content,
    super.position,
    super.size,
    super.rotation,
    super.scale,
    super.zIndex,
    super.isLocked,
    super.isVisible,
    this.fontSize = 24,
    this.color = Colors.black,
    this.fontFamily = 'Roboto',
    this.textAlign = TextAlign.center,
  }) : super(type: ElementType.text);

  @override
  TextElement copyWith({
    Offset? position,
    Size? size,
    double? rotation,
    double? scale,
    int? zIndex,
    bool? isLocked,
    bool? isVisible,
    String? content,
    double? fontSize,
    Color? color,
    String? fontFamily,
    TextAlign? textAlign,
  }) {
    return TextElement(
      id: id,
      content: content ?? this.content,
      position: position ?? this.position,
      size: size ?? this.size,
      rotation: rotation ?? this.rotation,
      scale: scale ?? this.scale,
      zIndex: zIndex ?? this.zIndex,
      isLocked: isLocked ?? this.isLocked,
      isVisible: isVisible ?? this.isVisible,
      fontSize: fontSize ?? this.fontSize,
      color: color ?? this.color,
      fontFamily: fontFamily ?? this.fontFamily,
      textAlign: textAlign ?? this.textAlign,
    );
  }

  @override
  Map<String, dynamic> toJson() => {
        'id': id,
        'type': 'text',
        'content': content,
        'x': position.dx,
        'y': position.dy,
        'width': size.width,
        'height': size.height,
        'rotation': rotation,
        'scale': scale,
        'zIndex': zIndex,
        'isLocked': isLocked,
        'isVisible': isVisible,
        'fontSize': fontSize,
        'color': color.value,
        'fontFamily': fontFamily,
        'textAlign': textAlign.index,
      };
}

class Project {
  final String id;
  final String name;
  final List<CanvasElement> elements;
  final Size canvasSize;
  final double duration;

  Project({
    String? id,
    this.name = 'Untitled Project',
    this.elements = const [],
    this.canvasSize = const Size(1080, 1920),
    this.duration = 5.0,
  }) : id = id ?? const Uuid().v4();

  Project copyWith({
    String? name,
    List<CanvasElement>? elements,
    Size? canvasSize,
    double? duration,
  }) {
    return Project(
      id: id,
      name: name ?? this.name,
      elements: elements ?? this.elements,
      canvasSize: canvasSize ?? this.canvasSize,
      duration: duration ?? this.duration,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'canvasWidth': canvasSize.width,
        'canvasHeight': canvasSize.height,
        'duration': duration,
        'elements': elements.map((e) => e.toJson()).toList(),
      };
}
