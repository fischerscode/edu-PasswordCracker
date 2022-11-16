import 'package:flutter/material.dart';
import 'package:password_cracker/controller/pin/bruteforce/layout/settings.dart';
import 'package:password_cracker/controller/pin/bruteforce/strategy.dart';
import 'package:password_cracker/widgets/option_selection.dart';
import 'package:provider/provider.dart';

import '../controller.dart';
import 'runner/runner.dart';
import 'speed.dart';

class BruteForceController with ChangeNotifier {
  BruteForceRunner? _runner;

  BruteForceController(this.pinController) {
    pinController.addListener(stop);
  }

  bool get isRunning =>
      _runner != null && _runner!.state == RunnerState.running;

  BruteForceSpeed delayLevel = BruteForceSpeed.medium;

  final PinController pinController;

  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: this,
      child: const BruteForceWidget(),
    );
  }

  void start() {
    _runner = bruteForceStrategy.create(pinController, delayLevel);
    _runner!.addListener(notifyListeners);
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

  BruteForceStrategy bruteForceStrategy = BruteForceStrategy.raising;

  List<Widget> buildSettings(BuildContext context) {
    return [
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: MultiButtonSelection(
          options: BruteForceStrategy.values
              .map((e) => e.text)
              .toList(growable: false),
          selected: bruteForceStrategy.index,
          onSelected: (value) {
            bruteForceStrategy = BruteForceStrategy.values[value];
            stop();
          },
        ),
      ),
      Slider(
        value: delayLevel.index.toDouble(),
        min: 0,
        max: BruteForceSpeed.values.length.toDouble() - 1,
        divisions: BruteForceSpeed.values.length - 1,
        onChanged: (v) => onDelayLevelChange(BruteForceSpeed.values[v.toInt()]),
        label: '$delayLevel',
      ),
    ];
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
