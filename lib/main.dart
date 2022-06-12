import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import 'actors/player.dart';
import 'world/obstacle.dart';

void main() {
  runApp(GameWidget(game: MyGame()));
}

class MyGame extends FlameGame with HasDraggables, HasCollisionDetection {
  var player = Player();

  late JoystickComponent joystick;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    joystick = JoystickComponent(
        knob: CircleComponent(radius: 30, paint: Paint()..color = Colors.blue),
        size: 80,
        margin: const EdgeInsets.only(left: 50, bottom: 50));
    add(joystick);
    player.add(RectangleHitbox());

    add(player);
    add(Obstacle(size: Vector2(300, 50), position: Vector2(100, 400)));
    add(Obstacle(size: Vector2(50, 200), position: Vector2(350, 200)));
    add(Obstacle(size: Vector2(50, 200), position: Vector2(100, 200)));
    add(Obstacle(size: Vector2(100, 50), position: Vector2(100, 150)));
  }
}
