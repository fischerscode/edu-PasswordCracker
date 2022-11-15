import 'package:flutter/material.dart';
import 'package:password_cracker/controller/controller.dart';
import 'package:provider/provider.dart';

class LockScreen extends StatelessWidget {
  const LockScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Provider.of<LoginController>(context).buildSimulation(context);
  }
}
