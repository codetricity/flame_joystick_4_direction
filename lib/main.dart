import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:flutter/material.dart';
import 'package:tiled/tiled.dart';

import 'actors/player.dart';
import 'world/obstacle.dart';

void main() {
  runApp(GameWidget(game: MyGame()));
}

class MyGame extends FlameGame with HasDraggables, HasCollisionDetection {
  final player = Player();

  late final JoystickComponent joystick;
  final double playerSpeed = 300;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    var gameMap = await TiledComponent.load('map.tmx', Vector2.all(16));
    add(gameMap);

    List<TiledObject> mapObstacles =
        gameMap.tileMap.getLayer<ObjectGroup>('obstacle_object')!.objects;

    for (var obstacle in mapObstacles) {
      add(Obstacle(
          position: Vector2(obstacle.x, obstacle.y),
          size: Vector2(obstacle.width, obstacle.height)));
    }

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
