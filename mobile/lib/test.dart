import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:turtle_controller/color_utils.dart';
import 'package:turtle_controller/turtle.dart';
import 'package:turtle_controller/world.dart';
import 'package:web_socket_channel/io.dart';
import 'package:zflutter/zflutter.dart';
import 'block.dart';
import 'control_panel.dart';

class TestPlatform extends StatefulWidget {
  @override
  _TestPlatformState createState() => _TestPlatformState();
}

class _TestPlatformState extends State<TestPlatform> {
  Turtle player;
  World world;
  bool initialized = false;
  bool fill = true;
  IOWebSocketChannel socket;

  ZPositioned drawPlayer() {
    return ZPositioned(
      child: ZCone(
        length: 80,
        backfaceColor: Colors.yellow.shade900,
        color: Colors.yellow,
        diameter: 80,
      ),
      translate: player.controller.getPlayerPosition(),
      rotate: ZVector.only(y: player.controller.getPlayerRotation()),
    );
  }

  ZPositioned drawBlock(Block block) {
    bool sameAsPlayer = block.position == player.controller.position;
    bool fillBlock = fill && !sameAsPlayer;
    return ZPositioned(
      translate: ZVector(
          (100 * block.position.x).toDouble() -
              player.controller.position.x * 100,
          (100 * block.position.y).toDouble() -
              player.controller.position.y * 100,
          (100 * block.position.z).toDouble() -
              player.controller.position.z * 100),
      child: ZGroup(
        sortMode: SortMode.stack,
        children: [
          ZGroup(
            sortMode: SortMode.update,
            children: [
              ZBox(
                fill: fillBlock,
                height: !sameAsPlayer ? 100 : 1,
                width: !sameAsPlayer ? 100 : 1,
                depth: !sameAsPlayer ? 100 : 1,
                color: block.color,
                rearColor: darken(block.color, .1),
                frontColor: darken(block.color, .1),
                leftColor: darken(block.color, .2),
                rightColor: darken(block.color, .2),
                bottomColor: darken(block.color, .3),
              ),
            ],
          ),
          ZPositioned(
            translate: ZVector.only(x: 40, y: 40),
            child: ZToBoxAdapter(
              width: 100,
              height: 100,
              child: block.type == BlockType.unknown
                  ? Text(block.name)
                  : SizedBox(),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    world = World();
    addReceiver();
    super.initState();
  }

  void addReceiver() async {
    socket = IOWebSocketChannel.connect("ws://34.65.183.103:5758");
    player = Turtle(socket, world);
    player.updateData.stream.listen((event) {
      setState(() {
        initialized = true;
        update();
      });
    });
  }

  void update() {
    setState(() {
      player = player;
    });
  }

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: initialized
            ? Stack(children: [
                ZDragDetector(
                  builder: (context, rotateController, zoomController) {
                    return ZIllustration(
                      children: [
                        ZPositioned(
                          rotate: rotateController.rotate,
                          //scale: ZVector.only(x: 0.5,y: 0.5,z: 0.5),
                          child: ZGroup(
                            children: [
                              drawPlayer(),
                              for (Block block in world.getAllBlocksInRadius(
                                  10, player.controller.position))
                                drawBlock(block)
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                ),
                Align(
                  alignment: AlignmentDirectional.topCenter,
                  child: FloatingActionButton(
                    child: Icon(!fill ? Icons.add : Icons.ac_unit),
                    onPressed: () {
                      setState(() {
                        fill = !fill;
                      });
                    },
                  ),
                ),
                Align(
                  alignment: AlignmentDirectional.bottomCenter,
                  child: ControlPanel(
                    player: player,
                    onUpdate: update,
                  ),
                )
              ])
            : Center(
                child: CircularProgressIndicator(),
              ),
      ),
    );
  }
}
