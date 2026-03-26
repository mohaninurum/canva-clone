import 'package:flutter/material.dart';

enum ElementType { text, shape, image }

abstract class CanvasElement {
  final String id;
  final ElementType type;
  Offset position;
  Size size;
  double rotation; // In radians
  double opacity;

  CanvasElement({
    required this.id,
    required this.type,
    required this.position,
    required this.size,
    this.rotation = 0.0,
    this.opacity = 1.0,
  });

  CanvasElement copyWith({
    Offset? position,
    Size? size,
    double? rotation,
    double? opacity,
  });

  Map<String, dynamic> toJson();
}

class TextElement extends CanvasElement {
  String text;
  double fontSize;
  Color color;
  FontWeight fontWeight;
  TextAlign textAlign;

  TextElement({
    required super.id,
    required super.position,
    required super.size,
    this.text = 'New Text',
    this.fontSize = 24.0,
    this.color = Colors.black,
    this.fontWeight = FontWeight.normal,
    this.textAlign = TextAlign.center,
    super.rotation,
    super.opacity,
  }) : super(type: ElementType.text);

  @override
  TextElement copyWith({
    Offset? position,
    Size? size,
    double? rotation,
    double? opacity,
    String? text,
    double? fontSize,
    Color? color,
    FontWeight? fontWeight,
    TextAlign? textAlign,
  }) {
    return TextElement(
      id: id,
      position: position ?? this.position,
      size: size ?? this.size,
      rotation: rotation ?? this.rotation,
      opacity: opacity ?? this.opacity,
      text: text ?? this.text,
      fontSize: fontSize ?? this.fontSize,
      color: color ?? this.color,
      fontWeight: fontWeight ?? this.fontWeight,
      textAlign: textAlign ?? this.textAlign,
    );
  }

  @override
  Map<String, dynamic> toJson() => {
    'id': id,
    'type': type.name,
    'position': {'dx': position.dx, 'dy': position.dy},
    'size': {'width': size.width, 'height': size.height},
    'rotation': rotation,
    'opacity': opacity,
    'text': text,
    'fontSize': fontSize,
    'color': color.value,
    'fontWeight': fontWeight.index,
    'textAlign': textAlign.index,
  };
}

enum ShapeType { rectangle, circle }

class ShapeElement extends CanvasElement {
  ShapeType shapeType;
  Color color;

  ShapeElement({
    required super.id,
    required super.position,
    required super.size,
    this.shapeType = ShapeType.rectangle,
    this.color = Colors.blue,
    super.rotation,
    super.opacity,
  }) : super(type: ElementType.shape);

  @override
  ShapeElement copyWith({
    Offset? position,
    Size? size,
    double? rotation,
    double? opacity,
    ShapeType? shapeType,
    Color? color,
  }) {
    return ShapeElement(
      id: id,
      position: position ?? this.position,
      size: size ?? this.size,
      rotation: rotation ?? this.rotation,
      opacity: opacity ?? this.opacity,
      shapeType: shapeType ?? this.shapeType,
      color: color ?? this.color,
    );
  }

  @override
  Map<String, dynamic> toJson() => {
    'id': id,
    'type': type.name,
    'position': {'dx': position.dx, 'dy': position.dy},
    'size': {'width': size.width, 'height': size.height},
    'rotation': rotation,
    'opacity': opacity,
    'shapeType': shapeType.name,
    'color': color.value,
  };
}

class ImageElement extends CanvasElement {
  String imagePath; // Local path or url or base64

  ImageElement({
    required super.id,
    required super.position,
    required super.size,
    required this.imagePath,
    super.rotation,
    super.opacity,
  }) : super(type: ElementType.image);

  @override
  ImageElement copyWith({
    Offset? position,
    Size? size,
    double? rotation,
    double? opacity,
    String? imagePath,
  }) {
    return ImageElement(
      id: id,
      position: position ?? this.position,
      size: size ?? this.size,
      rotation: rotation ?? this.rotation,
      opacity: opacity ?? this.opacity,
      imagePath: imagePath ?? this.imagePath,
    );
  }

  @override
  Map<String, dynamic> toJson() => {
    'id': id,
    'type': type.name,
    'position': {'dx': position.dx, 'dy': position.dy},
    'size': {'width': size.width, 'height': size.height},
    'rotation': rotation,
    'opacity': opacity,
    'imagePath': imagePath,
  };
}
