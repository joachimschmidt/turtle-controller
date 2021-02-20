import 'dart:collection';
import 'dart:math';

import 'package:tuple/tuple.dart';
import 'package:turtle_controller/position.dart';

import 'block.dart';

class World {
  Map<Tuple3, Block> blocks = Map();

  List<Block> getAllBlocksInRadius(int radius, Position positionOfCentre) {
    List<Block> blocksInRadius = [];
    List<Block> potentialBlocksInRadius = [];
    for (int i = positionOfCentre.x - radius;
        i < positionOfCentre.x + radius;
        i++) {
      for (int j = positionOfCentre.y - radius;
          j < positionOfCentre.y + radius;
          j++) {
        for (int k = positionOfCentre.z - radius;
            k < positionOfCentre.z + radius;
            k++) {
          Position positionOfPotentialBlock = Position(i, j, k);
          Tuple3 key = getBlockID(positionOfPotentialBlock);
          if (key != null) {
            potentialBlocksInRadius.add(blocks[key]);
          }
        }
      }
    }

    for (Block block in potentialBlocksInRadius) {
      Position positionOfBlock = block.position;
      int x = positionOfBlock.x;
      int y = positionOfBlock.y;
      int z = positionOfBlock.z;
      int xc = positionOfCentre.x;
      int yc = positionOfCentre.y;
      int zc = positionOfCentre.z;
      double distance =
          sqrt(pow((xc - x), 2) + pow((yc - y), 2) + pow((zc - z), 2));
      if (distance < radius) {
        blocksInRadius.add(block);
      }
    }
    return blocksInRadius;
  }

  static Tuple3 convertPositionToTuple(Position position) {
    return Tuple3(position.x, position.y, position.z);
  }

  Tuple3 getBlockID(Position position) {
    Tuple3 key = convertPositionToTuple(position);
    if (blocks.containsKey(key)) {
      return key;
    }
    return null;
  }

  void updateBlock( Block newBlock) {
    Tuple3 key = convertPositionToTuple(newBlock.position);
    blocks[key] = newBlock;
  }

  void removeBlock(Position position) {
    Tuple3 key = getBlockID(position);
    blocks.remove(key);
  }
}
