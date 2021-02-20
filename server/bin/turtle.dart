import 'dart:async';
import 'dart:io';

import 'package:async/async.dart';

import 'player.dart';

class Turtle {
  WebSocket socket;
  String name;
  StreamController broadcaster;
  bool isBusy = false;
  Player turtlePlayer;
  Stream turtleStream;
  StreamController infoController;

  Turtle(this.socket, this.name) {
    infoController = StreamController();
    turtleStream =
        StreamGroup.merge([socket.asBroadcastStream(), infoController.stream]);
    broadcaster = StreamController.broadcast();
    broadcaster.addStream(turtleStream.asBroadcastStream(onCancel: (sub) {
      print('turtle $name disconnected');
      if (turtlePlayer != null) {
        turtlePlayer.chosenTurtle = null;
        turtlePlayer.hasTurtle = false;
        broadcaster.close();
      }
    }));
    broadcaster.stream.listen((event) {
      print('turtle said: $event');
    });
  }
}
