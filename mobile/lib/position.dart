import 'package:equatable/equatable.dart';

import 'direction.dart';

// ignore: must_be_immutable
class Position extends Equatable {
  int x;
  int y;
  int z;

  Position(this.x, this.y, this.z);

  @override
  List<Object> get props => [x, y, z];

  static Position getPositionInFront(Direction direction, Position position) {
    Position positionCopy = Position(position.x, position.y, position.z);
    switch (direction) {
      case Direction.WEST:
        positionCopy.x++;
        break;
      case Direction.SOUTH:
        positionCopy.z--;
        break;
      case Direction.NORTH:
        positionCopy.z++;
        break;
      case Direction.EAST:
        positionCopy.x--;
        break;
    }
    return positionCopy;
  }

}
