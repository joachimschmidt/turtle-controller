import 'package:turtle_controller/position.dart';
import 'package:zflutter/zflutter.dart';

import 'direction.dart';

class MovementController {
  Position position;
  Direction facing;

  MovementController(Position position,Direction direction) {
    this.position = position;
    this.facing = direction;
  }

  void moveForward() {
    switch (facing) {
      case Direction.WEST:
        position.x++;
        break;
      case Direction.SOUTH:
        position.z--;
        break;
      case Direction.NORTH:
        position.z++;
        break;
      case Direction.EAST:
        position.x--;
        break;
    }
  }

  void moveBackward() {
    switch (facing) {
      case Direction.WEST:
        position.x--;
        break;
      case Direction.SOUTH:
        position.z++;
        break;
      case Direction.NORTH:
        position.z--;
        break;
      case Direction.EAST:
        position.x++;
        break;
    }
  }

  void moveLeft() {
    switch (facing) {
      case Direction.WEST:
        position.z--;
        break;
      case Direction.SOUTH:
        position.x--;
        break;
      case Direction.NORTH:
        position.x++;
        break;
      case Direction.EAST:
        position.z++;
        break;
    }
  }

  void moveRight() {
    switch (facing) {
      case Direction.WEST:
        position.z++;
        break;
      case Direction.SOUTH:
        position.x++;
        break;
      case Direction.NORTH:
        position.x--;
        break;
      case Direction.EAST:
        position.z--;
        break;
    }
  }

  void rotateLeft() {
    switch (facing) {
      case Direction.WEST:
        facing = Direction.SOUTH;
        break;
      case Direction.SOUTH:
        facing = Direction.EAST;
        break;
      case Direction.NORTH:
        facing = Direction.WEST;
        break;
      case Direction.EAST:
        facing = Direction.NORTH;
        break;
    }
  }

  void rotateRight() {
    switch (facing) {
      case Direction.WEST:
        facing = Direction.NORTH;
        break;
      case Direction.SOUTH:
        facing = Direction.WEST;
        break;
      case Direction.NORTH:
        facing = Direction.EAST;
        break;
      case Direction.EAST:
        facing = Direction.SOUTH;
        break;
    }
  }

  void goUp() {
    position.y--;
  }

  void goDown() {
    position.y++;
  }

  double getPlayerRotation() {
    switch (facing) {
      case Direction.WEST:
        return -tau / 4;
        break;
      case Direction.SOUTH:
        return tau / 2;
        break;
      case Direction.NORTH:
        return 0;
        break;
      case Direction.EAST:
        return tau / 4;
        break;
      default:
        return tau / 4;
        break;
    }
  }

  ZVector getPlayerPosition() {
    double relativeX = (position.x * 100).toDouble() - position.x * 100;
    double relativeY = (position.y * 100).toDouble() - position.y * 100;
    double relativeZ = (position.z * 100).toDouble() - position.z * 100;
    switch (facing) {
      case Direction.WEST:
        relativeX -= 40;
        break;
      case Direction.SOUTH:
        relativeZ += 40;
        break;
      case Direction.NORTH:
        relativeZ -= 40;
        break;
      case Direction.EAST:
        relativeX += 40;
        break;
    }
    return ZVector(relativeX, relativeY, relativeZ);
  }
}
