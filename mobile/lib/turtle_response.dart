import 'block.dart';
import 'direction.dart';
import 'position.dart';

abstract class TurtleResponse {}

class ErrorResponse extends TurtleResponse {}

class WorldInfoResponse extends TurtleResponse {
  Block front;
  Block down;
  Block up;

  WorldInfoResponse({Block down, Block front, Block up});

  WorldInfoResponse.fromJson(
      var data, Position position, Direction direction)
      : front = Block.fromJson(
            data['forward'], Position.getPositionInFront(direction, position)),
        down = Block.fromJson(
            data['down'], Position(position.x, position.y + 1, position.z)),
        up = Block.fromJson(
            data['up'], Position(position.x, position.y - 1, position.z));
}

class MovementResponse extends TurtleResponse {
  bool isSuccess;

  MovementResponse(this.isSuccess);
}

class LabelResponse extends TurtleResponse {
  bool hasLabel;
  String label;

  LabelResponse(this.hasLabel, this.label);

  LabelResponse.fromJson(data)
      : hasLabel = data != null,
        label = data;
}

class IDResponse extends TurtleResponse {
  int id;

  IDResponse(this.id);

  IDResponse.fromJson(data) : id = data;
}

class GenericResponse extends TurtleResponse {
  bool isSuccess;

  GenericResponse(this.isSuccess);
}
