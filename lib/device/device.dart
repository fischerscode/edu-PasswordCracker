import 'package:flutter/material.dart';
import 'package:password_cracker/device/pages/locked.dart';

class Device extends StatelessWidget {
  const Device({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      useInheritedMediaQuery: true,
      title: 'PasswordCracker',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const LockScreen(),
    );
  }
}
