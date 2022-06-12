import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class Obstacle extends RectangleComponent {
  Obstacle({required Vector2 size, required Vector2 position})
      : super(
            size: size,
            position: position,
            paint: Paint()..color = Colors.brown) {
    debugMode = true;
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    add(RectangleHitbox());
  }
}
