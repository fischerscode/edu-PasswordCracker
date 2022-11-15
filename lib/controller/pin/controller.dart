import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:password_cracker/controller/pin/bruteforce/controller.dart';
import 'package:provider/provider.dart';

import '../controller.dart';
import 'layout/pin_lock_screen.dart';

part 'random.dart';
part 'pre_set.dart';

abstract class PinController extends LoginController with PinInputController {
  List<int> get _pin;

  late BruteForceController bruteForceController;

  PinController() {
    bruteForceController = BruteForceController(this);
  }

  bool validatePin(List<int> input) {
    return listEquals(input, _pin);
  }

  @override
  int pinLength() => _pin.length;

  @override
  Widget buildSimulation(BuildContext context) {
    return PinLockScreen(this);
  }

  @override
  Widget buildBruteForce(BuildContext context) {
    return bruteForceController.build(context);
  }

  Widget _buildPinTypeSwitcher(BuildContext context) {
    var isRandom = this is RandomPinController;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 22),
      child: Row(
        children: [
          const Text("Zufällige Pin:"),
          Switch(
            value: isRandom,
            onChanged: (shouldBeRandom) {
              if (isRandom != shouldBeRandom) {
                Provider.of<AppController>(context, listen: false)
                    .setLoginController(shouldBeRandom
                        ? RandomPinController()
                        : PreSetPinController());
              }
            },
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    bruteForceController.dispose();
    super.dispose();
  }
}
