import 'dart:async';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../../controller.dart';
import '../speed.dart';

abstract class BruteForceRunner with ChangeNotifier {
  BruteForceRunner(this.inputController, this.speed) {
    inputController.addListener(cancel);
    _start();
  }

  final PinController inputController;
  final BruteForceSpeed speed;

  int progress = 0;
  Timer? _timer;

  List<int>? get currentPin;

  int get pinCounter => progress ~/ (inputController.pinLength() + 1);
  int get pinInputCounter => progress % (inputController.pinLength() + 1);

  RunnerState state = RunnerState.running;

  void _start() async {
    inputController.disableUserInput();

    await Future.delayed(const Duration(milliseconds: 10));

    void clearInput() {
      while (inputController.inputLength() > 0) {
        inputController.removeLast();
      }
    }

    clearInput();

    var start = DateTime.now();

    var pressDelay = speed.getPressDelay(inputController.pinLength() + 1);

    _timer = Timer.periodic(pressDelay, (timer) {
      int desiredProgress = (DateTime.now().difference(start).inMicroseconds ~/
              pressDelay.inMicroseconds) -
          1;

      while (progress < desiredProgress) {
        progress = pinCounter * (inputController.pinLength() + 1);
        var testPin = currentPin;
        if (testPin == null) {
          state = RunnerState.failed;
          cancel();
          return;
        }
        if (inputController.validatePin(testPin)) {
          clearInput();
          for (var digit in testPin) {
            inputController.addDigit(digit);
          }
          inputController.validate();
          state = RunnerState.finished;
          cancel();
          return;
        } else {
          progress += (inputController.pinLength() + 1);
        }
      }

      if (inputController.inputLength() < inputController.pinLength()) {
        var testPin = currentPin;
        if (testPin == null) {
          state = RunnerState.failed;
          cancel();
          return;
        }
        inputController.addDigit(testPin[inputController.inputLength()]);
      } else {
        if (inputController.updateUi) notifyListeners();
        if (inputController.validate()) {
          state = RunnerState.finished;
          cancel();
          return;
        }
      }
      progress++;
    });
  }

  bool _disposed = false;
  void cancel() {
    _timer?.cancel();
    Future.delayed(const Duration(milliseconds: 50)).then((value) {
      inputController.invalid();
      inputController.enableUserInput();
    });
    if (!_disposed) {
      notifyListeners();
      dispose();
      inputController.removeListener(cancel);
    }
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }

  static List<int> getDigitsFromNumber(int number, int length) {
    return List.generate(
            length, (index) => (number % pow(10, index + 1)) ~/ pow(10, index))
        .reversed
        .toList(growable: false);
  }
}

enum RunnerState {
  running,
  finished,
  failed;
}
