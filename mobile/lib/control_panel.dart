import 'package:flutter/material.dart';
import 'package:turtle_controller/turtle.dart';

class ControlPanel extends StatefulWidget {
  final Turtle player;
  final Function onUpdate;

  const ControlPanel({Key key, this.player, this.onUpdate}) : super(key: key);

  @override
  _ControlPanelState createState() => _ControlPanelState();
}

class _ControlPanelState extends State<ControlPanel> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  FloatingActionButton(
                    child: Icon(Icons.arrow_circle_up),
                    onPressed: () {
                      setState(() {
                        widget.player.moveTurtle(MoveDirection.up);
                        widget.onUpdate();
                      });
                    },
                  ),
                  FloatingActionButton(
                    child: Icon(Icons.rotate_left),
                    onPressed: () {
                      setState(() {
                        widget.player.rotateTurtle(RotateDirection.left);
                        widget.onUpdate();
                      });
                    },
                  ),
                ],
              ),
            ),
            Container(
              width: 200,
              child: Stack(
                children: [
                  Align(
                    alignment: AlignmentDirectional.topCenter,
                    child: ElevatedButton(
                      child: Icon(Icons.arrow_upward),
                      onPressed: () {
                        setState(() {
                          widget.player.moveTurtle(MoveDirection.forward);
                          widget.onUpdate();
                        });
                      },
                    ),
                  ),
                  Align(
                    alignment: AlignmentDirectional.bottomCenter,
                    child: ElevatedButton(
                      child: Icon(Icons.arrow_downward),
                      onPressed: () {
                        setState(() {
                          widget.player.moveTurtle(MoveDirection.backward);
                          widget.onUpdate();
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  FloatingActionButton(
                    child: Icon(Icons.arrow_circle_down),
                    onPressed: () {
                      setState(() {
                        widget.player.moveTurtle(MoveDirection.down);
                        widget.onUpdate();
                      });
                    },
                  ),
                  FloatingActionButton(
                    child: Icon(Icons.rotate_right),
                    onPressed: () {
                      setState(() {
                        widget.player.rotateTurtle(RotateDirection.right);
                        widget.onUpdate();
                      });
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
