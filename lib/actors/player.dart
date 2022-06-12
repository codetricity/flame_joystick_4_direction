import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:joy/main.dart';
import 'package:joy/world/obstacle.dart';

class Player extends RectangleComponent
    with HasGameRef<MyGame>, CollisionCallbacks {
  Player()
      : super(
          size: Vector2.all(30),
          paint: Paint()..color = Colors.green,
          position: Vector2.all(100),
        ) {
    debugMode = true;
  }

  bool collided = false;

  JoystickDirection collisionDirection = JoystickDirection.idle;

  @override
  void update(double dt) {
    var velocity = gameRef.joystick.relativeDelta * 100 * dt;
    var joystickDirection = gameRef.joystick.direction;
    super.update(dt);

    switch (joystickDirection) {
      case JoystickDirection.right:
        if (!collided || collisionDirection == JoystickDirection.left) {
          x += velocity[0];
        }
        break;
      case JoystickDirection.left:
        if (!collided || collisionDirection == JoystickDirection.right) {
          x += velocity[0];
        }
        break;
      case JoystickDirection.down:
        if (!collided || collisionDirection == JoystickDirection.up) {
          y += velocity[1];
        }
        break;
      case JoystickDirection.up:
        if (!collided || collisionDirection == JoystickDirection.down) {
          y += velocity[1];
        }
        break;
      default:
        break;
    }
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    if (other is Obstacle) {
      // if (gameRef.joystick.direction == JoystickDirection.up ||
      //     gameRef.joystick.direction == JoystickDirection.down ||
      //     gameRef.joystick.direction == JoystickDirection.left ||
      //     gameRef.joystick.direction == JoystickDirection.right) {
      if (!collided) {
        collided = true;
        collisionDirection = gameRef.joystick.direction;
      }
      // }
    }
    super.onCollision(intersectionPoints, other);
  }

  @override
  void onCollisionEnd(PositionComponent other) {
    collisionDirection = JoystickDirection.idle;
    collided = false;

    super.onCollisionEnd(other);
  }
}
