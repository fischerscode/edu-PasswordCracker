import 'dart:math';

import 'runner.dart';

/// Start at the middle and go outwards.
/// 5000 -> 4999 -> 5001 -> ...
class MiddleBruteForceRunner extends BruteForceRunner {
  MiddleBruteForceRunner(super.inputController, super.speed) {
    _startValue = pow(10, inputController.pinLength()) ~/ 2;
  }

  late final int _startValue;

  @override
  List<int> get currentPin {
    return BruteForceRunner.getDigitsFromNumber(
        _startValue + ((pinCounter.isOdd ? -1 : 1) * (pinCounter / 2).ceil()),
        inputController.pinLength());
  }
}
