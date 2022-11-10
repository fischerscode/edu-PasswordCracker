import 'dart:async';

import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:password_cracker/device/pages/locked.dart';

class BruteForceController extends StatefulWidget {
  const BruteForceController(this.inputController, {super.key});

  final PinInputController inputController;

  @override
  State<BruteForceController> createState() => _BruteForceControllerState();
}

enum DelayLevel {
  one("0 ms", Duration.zero),
  two("0,1 ms", Duration(microseconds: 100)),
  three("1 ms", Duration(milliseconds: 1)),
  four("10 ms", Duration(milliseconds: 10)),
  five("100 ms", Duration(milliseconds: 100)),
  six("1 s", Duration(milliseconds: 1000)),
  ;

  final Duration delay;
  final String text;
  const DelayLevel(this.text, this.delay);

  @override
  String toString() => text;
}

class _BruteForceControllerState extends State<BruteForceController> {
  BruteForceRunner? _runner;

  bool get isRunning => _runner != null && !_runner!.finished;

  DelayLevel delayLevel = DelayLevel.three;

  @override
  Widget build(BuildContext context) {
    return ToolPanelSection(title: "Bruteforce", children: [
      ElevatedButton(
          onPressed: isRunning
              ? () {
                  setState(() {
                    _runner?.cancel();
                    _runner = null;
                  });
                }
              : () {
                  _start();
                },
          child: Text(isRunning ? "STOP" : "START")),
      Slider(
        value: delayLevel.index.toDouble(),
        min: 0,
        max: DelayLevel.values.length.toDouble() - 1,
        divisions: DelayLevel.values.length - 1,
        onChanged: (v) => setState(() {
          delayLevel = DelayLevel.values[v.toInt()];
          if (_runner != null && !_runner!.finished) {
            _runner?.cancel();
            _start();
          }
        }),
        label: '$delayLevel',
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text("Tastendruck anzeigen"),
          Switch(
            value: widget.inputController.pressButtons,
            onChanged: (value) {
              setState(() {
                widget.inputController.pressButtons = value;
              });
            },
          ),
        ],
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text("Anzeige aktualisieren"),
          Switch(
            value: widget.inputController.updateUi,
            onChanged: (value) {
              setState(() {
                widget.inputController.updateUi = value;
              });
            },
          ),
        ],
      ),
      if (_runner?.currentPin != null)
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ...?_runner?.currentPin.map((e) => SizedBox(
                  width: 50,
                  child: Center(
                    child: Text(
                      e.toString(),
                      style: Theme.of(context).textTheme.displayMedium,
                    ),
                  ),
                )),
          ],
        ),
    ]);
  }

  @override
  void dispose() {
    _runner?.cancel();
    super.dispose();
  }

  void _start() {
    setState(() {
      _runner = BruteForceRunner(widget.inputController);
      _runner!.addListener(() {
        setState(() {});
      });
      _runner!.start(delayLevel.delay);
    });
  }
}

class BruteForceRunner with ChangeNotifier {
  BruteForceRunner(this.inputController);
  final PinInputController inputController;

  int progress = 0;
  Timer? _timer;

  List<int> get currentPin {
    return [
      (progress % 10000) ~/ 1000,
      (progress % 1000) ~/ 100,
      (progress % 100) ~/ 10,
      (progress % 10),
    ];
  }

  bool finished = false;

  void start(Duration delay) {
    while (inputController.pinLength() > 0) {
      inputController.removeLast();
    }
    _timer = Timer.periodic(delay, (timer) {
      if (inputController.pinLength() < 4) {
        inputController.addDigit(currentPin[inputController.pinLength()]);
      } else {
        if (inputController.updateUi) notifyListeners();
        if (inputController.validate()) {
          timer.cancel();
          finished = true;
          if (!inputController.updateUi) notifyListeners();
        } else {
          progress++;
        }
      }
    });
  }

  void cancel() {
    _timer?.cancel();
  }
}
