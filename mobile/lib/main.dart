import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:turtle_controller/test.dart';

handleMsg(msg) {
  print('Message received: $msg');
}
void main() {

  runApp(TestApp());

}

class TestApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: TestPlatform(),
    );
  }
}
