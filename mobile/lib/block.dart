import 'package:flutter/material.dart';
import 'package:turtle_controller/position.dart';

enum BlockType { dirt, air, stone, unknown, oak_wood ,oak_leaves,water}

class Block {
  BlockType type;
  Position position;
  String name;
  Block(this.type, this.position);

  Block.fromJson(var json, this.position)
      : type = blockTypeFromString(json),
  name = blockTypeFromString(json)!=BlockType.unknown?blockTypeFromString(json).toString():json['name'];

  Color get color {
    switch (type) {
      case BlockType.dirt:
        return Colors.brown.shade400;
        break;
      case BlockType.air:
        return Colors.white.withOpacity(0);
        break;
      case BlockType.stone:
        return Colors.grey;
        break;
      case BlockType.unknown:
        return Colors.red;
        break;
      case BlockType.oak_wood:
        return Colors.brown.shade800;

        break;
      case BlockType.oak_leaves:
        return Colors.green.shade300;
        break;
      case BlockType.water:
        return Colors.blue.withOpacity(0.3);
        break;
    }
    return Colors.black;
  }

  static BlockType blockTypeFromString(var input) {
    if (input == "No block to inspect"|| input['name']=="minecraft:grass") {
      return BlockType.air;
    } else if (input['name'] == "minecraft:grass_block" ||input['name'] ==  "minecraft:dirt") {
      return BlockType.dirt;
    }else if(input['name'] ==  "minecraft:stone"){
      return BlockType.stone;
    } else if(input['name'] ==  "minecraft:oak_wood"){
      return BlockType.oak_wood;
    } else if(input['name'] ==  "minecraft:oak_leaves") {
      return BlockType.oak_leaves;
    } else if(input['name'] ==  "minecraft:water"){
      return BlockType.water;
    } else {
      return BlockType.unknown;
    }
  }
}
