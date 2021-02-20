import 'dart:async';
import 'dart:io';

import 'turtle.dart';

class Player {
  Turtle chosenTurtle;
  bool hasTurtle = false;
  WebSocket socket;
  StreamController broadcaster;

  Player(this.socket) {
    broadcaster = StreamController.broadcast();
    broadcaster.addStream(socket.asBroadcastStream(onCancel: (sub) {
      print('player disconnected');
      if (chosenTurtle != null) chosenTurtle.isBusy = false;
      broadcaster.close();
    }));
    broadcaster.stream.listen((event) {
      print('Player said: $event');
    });
  }
}
