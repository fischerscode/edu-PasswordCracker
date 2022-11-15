import 'package:flutter/material.dart';
import 'package:password_cracker/controller/pin/bruteforce/layout/settings.dart';
import 'package:provider/provider.dart';

import '../controller.dart';
import 'runner.dart';

class BruteForceController with ChangeNotifier {
  BruteForceRunner? _runner;

  BruteForceController(this.pinController) {
    pinController.addListener(stop);
  }

  bool get isRunning => _runner != null && !_runner!.finished;

  BruteForceSpeed delayLevel = BruteForceSpeed.medium;

  final PinController pinController;

  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: this,
      child: const BruteForceWidget(),
    );
  }

  void start() {
    _runner = BruteForceRunner(pinController);
    _runner!.addListener(notifyListeners);
    _runner!.start(delayLevel);
    notifyListeners();
  }

  void stop() {
    _runner?.cancel();
    _runner = null;
    notifyListeners();
  }

  void onDelayLevelChange(value) {
    delayLevel = value;
    stop();
    notifyListeners();
  }

  bool get pressButtons => pinController.pressButtons;

  void onPressButtonsChange(value) {
    pinController.pressButtons = value;
    notifyListeners();
  }

  bool get updateUi => pinController.updateUi;
  void onUpdateUiChange(value) {
    pinController.updateUi = value;
    notifyListeners();
  }

  List<int>? get currentPin => _runner?.currentPin;

  @override
  void dispose() {
    pinController.removeListener(stop);
    stop();
    super.dispose();
  }
}

enum BruteForceSpeed {
  extraFast("extra schnell", 1000),
  fast("schnell", 100),
  medium("zügig", 10),
  slow("langsam", 1),
  extraSlow("extra langsam", 0.2),
  ;

  final double attacksPerSecond;
  final String text;
  const BruteForceSpeed(this.text, this.attacksPerSecond);

  Duration getPressDelay(int pinLength) {
    return Duration(
        microseconds:
            (Duration.microsecondsPerSecond / attacksPerSecond / pinLength)
                .ceil());
  }

  @override
  String toString() => text;
}
