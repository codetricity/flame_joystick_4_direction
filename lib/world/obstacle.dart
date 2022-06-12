import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

class Obstacle extends PositionComponent {
  Obstacle({required Vector2 size, required Vector2 position})
      : super(
          size: size,
          position: position,
          priority: 2,
          // paint: Paint()..color = Colors.brown
        ) {
    debugMode = true;
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    add(RectangleHitbox());
  }
}
