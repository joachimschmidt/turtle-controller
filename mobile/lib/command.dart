import 'dart:convert';

import 'dart:io';
enum CommandType{
  movement,inspection,labelInfo,idInfo,generic
}
class Command{
  CommandType type;
  String text;

  Command(this.type, this.text);

}