import 'package:flutter/material.dart';
import 'package:password_cracker/device/pages/locked.dart';

class Device extends StatelessWidget {
  const Device(this.controller, {super.key});

  final PinInputController controller;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      useInheritedMediaQuery: true,
      title: 'PasswordCracker',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LockScreen(controller),
    );
  }
}
