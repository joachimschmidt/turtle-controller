import 'dart:async';
import 'dart:convert';
import 'package:nonce/nonce.dart';
import 'package:turtle_controller/direction.dart';
import 'package:turtle_controller/position.dart';
import 'package:turtle_controller/turtle_response.dart';
import 'package:turtle_controller/world.dart';
import 'package:web_socket_channel/io.dart';
import 'command.dart';
import 'movement_controller.dart';

enum MoveDirection { forward, backward, up, down }
enum RotateDirection { left, right }

class Turtle {
  StreamController streamController;
  StreamController updateData = new StreamController.broadcast();
  MovementController controller;
  World world;
  String name;
  int id;
  int fuelLevel;
  IOWebSocketChannel socket;
  bool initialized = false;
  bool localOnly = false;

  Turtle(this.socket, this.world, {this.localOnly = false}) {
    initializeTurtle();
  }

  Turtle.localTurtle(this.world)
      : localOnly = true,
        initialized = true,
        controller = MovementController(Position(0, 0, 0), Direction.WEST),
        socket = null;

  Future<int> getID() async {
    IDResponse idResponse =
        await executeCommand(Command(CommandType.idInfo, "os.getComputerID()"));
    print("Dostałem id ${idResponse.id}");
    return idResponse.id;
  }

  Future<LabelResponse> getName() async {
    return await executeCommand(
        Command(CommandType.labelInfo, "os.getComputerLabel()"));
  }

  Future<bool> setName(String localName) async {
    GenericResponse setLabelResponse = await executeCommand(
        Command(CommandType.generic, 'os.setComputerLabel("$localName")'));
    return setLabelResponse.isSuccess;
  }

  Future<TurtleResponse> executeCommand(Command command) async {
    String nonce = Nonce.generate();
    Map<String, dynamic> data = Map();
    data["type"] = "eval";
    data["fun"] = "return ${command.text}";
    data["nonce"] = nonce;
    var turtleCommand = jsonEncode(data);
    print("Sending command ${command.text}");
    socket.sink.add(turtleCommand);
    Completer completer = new Completer();
    StreamSubscription sub;

    sub = streamController.stream.listen((event) {
      print(event);

      var response = jsonDecode(event);
      if (response['nonce'] == nonce) {
        switch (command.type) {
          case CommandType.movement:
            completer.complete(MovementResponse(response['data'] == true));
            sub.cancel();
            break;
          case CommandType.inspection:
            //print(response['data']);
            completer.complete(WorldInfoResponse.fromJson(
                response['data'], controller.position, controller.facing));
            sub.cancel();
            break;
          case CommandType.labelInfo:
            completer.complete(LabelResponse.fromJson(response['data']));
            sub.cancel();
            break;
          case CommandType.idInfo:
            print("Dostałem info o ID: ${response['data']}");
            completer.complete(IDResponse.fromJson(response['data']));
            sub.cancel();

            break;
          case CommandType.generic:
            completer.complete(GenericResponse(response['data']));
            sub.cancel();
            break;
        }
      }
    });

    return await completer.future;
    //return ErrorResponse();
  }

  Future<bool> awaitForTurtle() async {
    Completer completer = Completer();
    StreamSubscription sub;

    sub = streamController.stream.listen((event) {
      var data = jsonDecode(event);
      print(data);
      if (data) {
        completer.complete(true);
        sub.cancel();
      }
    });
    return await completer.future;
  }

  void initializeTurtle() async {
    streamController = StreamController.broadcast();
    streamController.addStream(socket.stream.asBroadcastStream());
    if (!await awaitForTurtle()) {
      return;
    }
    this.id = await getID();
    LabelResponse labelResponse = await getName();
    if (labelResponse.hasLabel) {
      this.name = labelResponse.label;
    } else {
      bool success = await setName("zolw");
      if (!success) throw Exception();
      this.name = "Zolw nakurwiator";
    }
    controller = MovementController(Position(0, 0, 0), Direction.WEST);
    updateWorld();
    initialized = true;
    updateData.add("initialized");
  }

  Future<void> moveTurtle(MoveDirection direction, {bool update = true}) async {
    String goVariant;
    Function onSuccess;
    switch (direction) {
      case MoveDirection.forward:
        goVariant = "forward";
        onSuccess = controller.moveForward;
        break;
      case MoveDirection.backward:
        goVariant = "back";
        onSuccess = controller.moveBackward;
        break;
      case MoveDirection.up:
        goVariant = "up";
        onSuccess = controller.goUp;
        break;
      case MoveDirection.down:
        goVariant = "down";
        onSuccess = controller.goDown;
        break;
    }
    Command command = Command(CommandType.movement, "turtle.$goVariant()");
    if (localOnly) {
      onSuccess();
      updateData.add("updated position");
      return;
    }
    MovementResponse movementResponse = await executeCommand(command);
    if (movementResponse.isSuccess) {
      onSuccess();
      if (update) {
        await updateWorld();
      }
    }
  }

  Future rotateTurtle(RotateDirection rotateDirection,
      {bool update = true}) async {
    Function onSuccess;
    String rotateVariant;
    switch (rotateDirection) {
      case RotateDirection.left:
        rotateVariant = "Left";
        onSuccess = controller.rotateLeft;
        break;
      case RotateDirection.right:
        rotateVariant = "Right";
        onSuccess = controller.rotateRight;
        break;
    }
    Command command =
        Command(CommandType.movement, "turtle.turn$rotateVariant()");
    if (localOnly) {
      onSuccess();
      return;
    }
    MovementResponse movementResponse = await executeCommand(command);
    if (movementResponse.isSuccess) {
      onSuccess();
      updateData.add("updated position");
      if (update) {
        await updateWorld();
      }
    }
  }

  Future updateWorld() async {
    Command command = Command(CommandType.inspection,
        "{down=select(2,turtle.inspectDown()), up=select(2,turtle.inspectUp()), forward=select(2,turtle.inspect())}");
    WorldInfoResponse info = await executeCommand(command);
    world.updateBlock(info.front);
    world.updateBlock(info.down);
    world.updateBlock(info.up);
    updateData.add("updated world");
  }

  void dispose() {
    streamController.close();
    updateData.close();
  }
}
