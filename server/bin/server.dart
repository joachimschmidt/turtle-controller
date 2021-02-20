import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:appengine/appengine.dart';

import 'player.dart';
import 'turtle.dart';

var turtles = <Turtle>[];
var players = <Player>[];

Future<void> main() async {
  var turtleServer = await HttpServer.bind('0.0.0.0', 5757, shared: true);
  var playerServer = await HttpServer.bind('0.0.0.0', 5758, shared: true);
  startTurtleServer(turtleServer);
  startPlayerServer(playerServer);
}

void startTurtleServer(var server) async {
  var i = 0;
  print('awaiting connection from turtles');
  await for (var req in server) {
    if (req.uri.path == '/') {
      print('launching turtle $i');
      var socket = await WebSocketTransformer.upgrade(req);
      var player = getFirstAvailablePlayer();
      var turtle = Turtle(socket, i.toString());
      if (player != null) {
        pairTurtle(player, turtle);
        turtles.add(turtle);
      } else {
        turtles.add(turtle);
      }
      i++;
    }
  }
}

Turtle getFirstAvailableTurtle() {
  for (var turtle in turtles) {
    if (!turtle.isBusy) return turtle;
  }
  return null;
}

Player getFirstAvailablePlayer() {
  for (var player in players) {
    if (!player.hasTurtle) return player;
  }
  return null;
}

void startPlayerServer(var server) async {
  var i = 0;
  print('awaiting connection from players');
  await for (HttpRequest req in server) {
    if (req.uri.path == '/') {
      print('launching player $i');
      var socket = await WebSocketTransformer.upgrade(req);
      var turtle = getFirstAvailableTurtle();
      var player = Player(socket);
      if (turtle != null) {
        pairTurtle(player, turtle);
      } else {
        players.add(player);
      }
      i++;
    }
  }
}
void chooseTurtle(){

}
void pairTurtle(Player player, Turtle turtle) {
  player.hasTurtle = true;
  player.chosenTurtle = turtle;
  turtle.isBusy = true;
  player.socket.addStream(turtle.broadcaster.stream);
  turtle.socket.addStream(player.broadcaster.stream);
  turtle.infoController.add(jsonEncode(true));
  print("Kończymy parowanie");
}
