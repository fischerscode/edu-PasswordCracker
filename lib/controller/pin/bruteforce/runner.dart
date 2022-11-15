import 'dart:async';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:password_cracker/controller/pin/bruteforce/controller.dart';

import '../controller.dart';

class BruteForceRunner with ChangeNotifier {
  BruteForceRunner(this.inputController) {
    inputController.addListener(cancel);
  }

  final PinController inputController;

  int progress = 0;
  Timer? _timer;

  List<int> get currentPin {
    return List.generate(inputController.pinLength(),
            (index) => (pinCounter % pow(10, index + 1)) ~/ pow(10, index))
        .reversed
        .toList();
  }

  int get pinCounter => progress ~/ (inputController.pinLength() + 1);
  int get pinInputCounter => progress % (inputController.pinLength() + 1);

  bool finished = false;

  void start(BruteForceSpeed speed) async {
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
        if (inputController.validatePin(currentPin)) {
          clearInput();
          for (var digit in currentPin) {
            inputController.addDigit(digit);
          }
          inputController.validate();
          finished = true;
          cancel();
          return;
        } else {
          progress += (inputController.pinLength() + 1);
        }
      }

      if (inputController.inputLength() < inputController.pinLength()) {
        inputController.addDigit(currentPin[inputController.inputLength()]);
      } else {
        if (inputController.updateUi) notifyListeners();
        if (inputController.validate()) {
          finished = true;
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
    inputController.enableUserInput();
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
}
