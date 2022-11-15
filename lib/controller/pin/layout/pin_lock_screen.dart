import 'dart:async';
import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:password_cracker/controller/pin/controller.dart';
import 'package:password_cracker/device/pages/unlocked.dart';
import 'package:password_cracker/widgets/initially_wiggling_text.dart';

part 'input_controller.dart';
part 'pin_field.dart';
part 'buttons.dart';
part 'pin_digit.dart';

class PinLockScreen extends StatefulWidget {
  const PinLockScreen(this.controller, {super.key});

  final PinController controller;

  @override
  State<PinLockScreen> createState() => _PinLockScreenState();
}

class _PinLockScreenState extends State<PinLockScreen>
    implements _PinInputController {
  bool isInvalid = false;
  bool isInitial = true;

  bool userInputDisabled = false;

  final pinKey = GlobalKey();

  final input = <int>[];

  @override
  void didChangeDependencies() {
    widget.controller._subscriber = this;
    super.didChangeDependencies();
  }

  final digitKeys = List.generate(10, (index) => GlobalKey());
  final okKey = GlobalKey();
  final removeKey = GlobalKey();

  @override
  void didUpdateWidget(covariant PinLockScreen oldWidget) {
    oldWidget.controller._subscriber = null;
    widget.controller._subscriber = this;
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SizedBox.expand(
            child: Image.asset(
              "assets/bg.jpg",
              fit: BoxFit.cover,
            ),
          ),
          ClipRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
              child: Center(
                child: AspectRatio(
                  aspectRatio: 412.0 / 892.0,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Material(
                          textStyle: const TextStyle(color: Colors.white),
                          color: Colors.transparent,
                          child: PinField(input, isInvalid: isInvalid)),
                      GridView.count(
                        shrinkWrap: true,
                        crossAxisCount: 3,
                        children: [
                          _DigitButton(1, this,
                              buttonKey: digitKeys[1],
                              ignorePress: userInputDisabled),
                          _DigitButton(2, this,
                              buttonKey: digitKeys[2],
                              ignorePress: userInputDisabled),
                          _DigitButton(3, this,
                              buttonKey: digitKeys[3],
                              ignorePress: userInputDisabled),
                          _DigitButton(4, this,
                              buttonKey: digitKeys[4],
                              ignorePress: userInputDisabled),
                          _DigitButton(5, this,
                              buttonKey: digitKeys[5],
                              ignorePress: userInputDisabled),
                          _DigitButton(6, this,
                              buttonKey: digitKeys[6],
                              ignorePress: userInputDisabled),
                          _DigitButton(7, this,
                              buttonKey: digitKeys[7],
                              ignorePress: userInputDisabled),
                          _DigitButton(8, this,
                              buttonKey: digitKeys[8],
                              ignorePress: userInputDisabled),
                          _DigitButton(9, this,
                              buttonKey: digitKeys[9],
                              ignorePress: userInputDisabled),
                          _BackSpaceButton(this,
                              buttonKey: removeKey,
                              ignorePress: userInputDisabled),
                          _DigitButton(0, this,
                              buttonKey: digitKeys[0],
                              ignorePress: userInputDisabled),
                          _OKButton(this,
                              buttonKey: okKey, ignorePress: userInputDisabled)
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  @override
  void addDigit(int digit, [bool updateUi = true]) {
    run() {
      input.add(digit);
      isInvalid = false;
    }

    if (mounted && updateUi) {
      setState(() {
        run();
      });
    } else {
      run();
    }
  }

  @override
  void removeLast([bool updateUi = true]) {
    run() {
      if (input.isNotEmpty) {
        input.removeLast();
      }
    }

    if (mounted && updateUi) {
      setState(() {
        run();
      });
    } else {
      run();
    }
  }

  @override
  bool validate([bool updateUi = true]) {
    if (widget.controller.validatePin(input)) {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
      setState(() {
        input.clear();
      });
      return true;
    } else {
      run() {
        input.clear();
        isInvalid = true;
        invalidTimer?.cancel();
        invalidTimer = Timer(
          const Duration(seconds: 2),
          () {
            if (mounted) {
              setState(() {
                isInvalid = false;
              });
            } else {
              isInvalid = false;
            }
          },
        );
      }

      if (mounted && updateUi) {
        setState(() {
          run();
        });
      } else {
        run();
      }
      return false;
    }
  }

  Timer? invalidTimer;

  @override
  int inputLength() {
    return input.length;
  }

  @override
  void dispose() {
    invalidTimer?.cancel();
    super.dispose();
  }

  @override
  void disableUserInput() {
    setState(() {
      userInputDisabled = true;
    });
  }

  @override
  void enableUserInput() {
    setState(() {
      userInputDisabled = false;
    });
  }
}
