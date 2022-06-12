import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:flutter/material.dart';
import 'package:tiled/tiled.dart' hide Text;

import 'actors/player.dart';
import 'world/obstacle.dart';

void main() {
  runApp(MaterialApp(
    home: Scaffold(
      body: GameWidget(
        game: MyGame(),
        overlayBuilderMap: {
          'buttonOverlay': (BuildContext context, MyGame game) =>
              ButtonOverlay(game: game)
        },
      ),
    ),
  ));
}

enum MapType { basic, tile, charlie }

class MyGame extends FlameGame with HasDraggables, HasCollisionDetection {
  final player = Player();

  late final JoystickComponent joystick;
  final double playerSpeed = 300;
  // final MapType mapType = MapType.tile;
  late TiledComponent gameMap;
  late List<TiledObject> mapObstacles;
  List<Obstacle> obstacleComponents = [];

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    await loadMap(MapType.charlie);

    joystick = JoystickComponent(
        priority: 5,
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
    overlays.add('buttonOverlay');
  }

  Future<void> loadMap(MapType mapType) async {
    obstacleComponents = [];

    switch (mapType) {
      case MapType.tile:
        gameMap = await TiledComponent.load('map.tmx', Vector2.all(16));
        gameMap.priority = 1;
        mapObstacles =
            gameMap.tileMap.getLayer<ObjectGroup>('obstacle_object')!.objects;
        for (var obstacle in mapObstacles) {
          var obstacleComponent = Obstacle(
              position: Vector2(obstacle.x, obstacle.y),
              size: Vector2(obstacle.width, obstacle.height));
          obstacleComponents.add(obstacleComponent);
          add(obstacleComponent);
        }
        if (gameMap.parent is MyGame) {
          gameMap.removeFromParent();
        }
        add(gameMap);

        break;
      case MapType.charlie:
        gameMap = await TiledComponent.load('level_1.tmx', Vector2.all(16));
        gameMap.priority = 1;
        mapObstacles =
            gameMap.tileMap.getLayer<ObjectGroup>('Obstacles')!.objects;
        for (var obstacle in mapObstacles) {
          var obstacleComponent = Obstacle(
              position: Vector2(obstacle.x, obstacle.y),
              size: Vector2(obstacle.width, obstacle.height));
          obstacleComponents.add(obstacleComponent);
          add(obstacleComponent);
        }
        if (gameMap.parent is MyGame) {
          gameMap.removeFromParent();
        }
        add(gameMap);
        break;
      case MapType.basic:
        if (gameMap.parent is MyGame) {
          print('removing gameMap ${gameMap.parent}');
          gameMap.removeFromParent();
        }
        break;
      default:
        break;
    }
  }
}

class ButtonOverlay extends StatelessWidget {
  final MyGame game;
  const ButtonOverlay({Key? key, required this.game}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextButton(
            style: TextButton.styleFrom(backgroundColor: Colors.white24),
            child: const Text('basic'),
            onPressed: () {
              if (game.gameMap.parent is MyGame) {
                game.gameMap.removeFromParent();
              }

              if (game.obstacleComponents.isNotEmpty) {
                game.removeAll(game.obstacleComponents);
                game.obstacleComponents = [];
              }
              game.loadMap(MapType.basic);
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextButton(
            style: TextButton.styleFrom(backgroundColor: Colors.white24),
            child: const Text('tiled'),
            onPressed: () {
              if (game.gameMap.parent is MyGame) {
                game.gameMap.removeFromParent();
              }
              if (game.obstacleComponents.isNotEmpty) {
                game.removeAll(game.obstacleComponents);
                game.obstacleComponents = [];
              }

              game.loadMap(MapType.tile);
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextButton(
            style: TextButton.styleFrom(backgroundColor: Colors.white24),
            child: const Text('Charlie'),
            onPressed: () {
              if (game.gameMap.parent is MyGame) {
                game.gameMap.removeFromParent();
              }
              if (game.obstacleComponents.isNotEmpty) {
                game.removeAll(game.obstacleComponents);
                game.obstacleComponents = [];
              }

              game.loadMap(MapType.charlie);
            },
          ),
        ),
      ],
    );
  }
}
