import 'dart:async';
import 'dart:math';
import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:password_cracker/device/pages/unlocked.dart';

const generatedPinLength = 4;

class LockScreen extends StatefulWidget {
  const LockScreen(this.controller, {super.key});

  final PinInputController controller;

  @override
  State<LockScreen> createState() => _LockScreenState();
}

abstract class _PinInputController {
  void addDigit(int digit);
  void removeLast();
  bool validate();
  int pinLength();
}

class PinInputController implements _PinInputController {
  _LockScreenState? _subscriber;

  bool pressButtons = true;
  bool updateUi = true;

  @override
  void addDigit(int digit) => pressButtons
      ? pressKey(_subscriber?.digitKeys[digit])
      : _subscriber?.addDigit(digit, updateUi);

  @override
  void removeLast() => pressButtons
      ? pressKey(_subscriber?.removeKey)
      : _subscriber?.removeLast(updateUi);

  @override
  bool validate() {
    if (_subscriber?.validate(updateUi) ?? false) {
      return true;
    } else {
      if (pressButtons) {
        pressKey(_subscriber?.okKey);
      }
      return false;
    }
  }

  @override
  int pinLength() => _subscriber?.pinLength() ?? 0;

  void pressKey(GlobalKey? key) {
    if (key != null) {
      RenderBox box = key.currentContext!.findRenderObject() as RenderBox;
      Offset position = box
          .localToGlobal(Offset.zero)
          .translate(box.size.width / 2, box.size.height / 2);

      WidgetsBinding.instance.handlePointerEvent(PointerDownEvent(
        pointer: 0,
        position: position,
      ));
      WidgetsBinding.instance.handlePointerEvent(PointerUpEvent(
        pointer: 0,
        position: position,
      ));
    }
  }
}

class _LockScreenState extends State<LockScreen>
    implements _PinInputController {
  bool isInvalid = false;
  bool isInitial = true;

  final pinKey = GlobalKey();

  final input = <int>[];
  late List<int> pin;

  _LockScreenState() {
    var random = Random();
    pin = List.generate(generatedPinLength, (index) => random.nextInt(10));
    // pin = [1, 2, 3, 4];
  }

  @override
  void didChangeDependencies() {
    widget.controller._subscriber = this;
    super.didChangeDependencies();
  }

  final digitKeys = List.generate(10, (index) => GlobalKey());
  final okKey = GlobalKey();
  final removeKey = GlobalKey();

  @override
  void didUpdateWidget(covariant LockScreen oldWidget) {
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
                      _PinField(input, isInvalid),
                      GridView.count(
                        shrinkWrap: true,
                        crossAxisCount: 3,
                        children: [
                          _DigitButton(1, this, key: digitKeys[1]),
                          _DigitButton(2, this, key: digitKeys[2]),
                          _DigitButton(3, this, key: digitKeys[3]),
                          _DigitButton(4, this, key: digitKeys[4]),
                          _DigitButton(5, this, key: digitKeys[5]),
                          _DigitButton(6, this, key: digitKeys[6]),
                          _DigitButton(7, this, key: digitKeys[7]),
                          _DigitButton(8, this, key: digitKeys[8]),
                          _DigitButton(9, this, key: digitKeys[9]),
                          _BackSpaceButton(this, key: removeKey),
                          _DigitButton(0, this, key: digitKeys[0]),
                          _OKButton(this, key: okKey)
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
      input.removeLast();
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
    if (listEquals(input, pin)) {
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
  int pinLength() {
    return input.length;
  }

  @override
  void dispose() {
    invalidTimer?.cancel();
    super.dispose();
  }
}

class _DigitButton extends _InputButton {
  final int digit;

  _DigitButton(this.digit, super.input, {super.key})
      : super(backgroundColor: Colors.grey.withOpacity(0.8));

  @override
  Widget get child => Text(
        digit.toString(),
        style: const TextStyle(fontSize: 40),
      );

  @override
  VoidCallback? get onPressed => () => inputController.addDigit(digit);
}

class _BackSpaceButton extends _InputButton {
  const _BackSpaceButton(super.input, {super.key})
      : super(backgroundColor: Colors.transparent);

  @override
  Widget get child => const Icon(Icons.backspace);

  @override
  VoidCallback? get onPressed =>
      inputController.pinLength() > 0 ? inputController.removeLast : null;
}

class _OKButton extends _InputButton {
  const _OKButton(
    super.input, {
    super.key,
  }) : super(backgroundColor: Colors.transparent);

  @override
  Widget get child => const Text('OK', style: TextStyle(fontSize: 30));

  @override
  VoidCallback? get onPressed =>
      inputController.pinLength() > 0 ? inputController.validate : null;
}

abstract class _InputButton extends StatelessWidget {
  const _InputButton(
    this.inputController, {
    super.key,
    this.backgroundColor,
  });

  Widget get child;

  final Color? backgroundColor;
  final _PinInputController inputController;

  VoidCallback? get onPressed;

  @override
  Widget build(BuildContext context) {
    var onPressed = this.onPressed;

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: RawMaterialButton(
        onPressed: onPressed,
        shape: const CircleBorder(),
        fillColor: backgroundColor,
        textStyle:
            TextStyle(color: onPressed != null ? Colors.white : Colors.white60),
        elevation: 0,
        focusElevation: 0,
        hoverElevation: 0,
        highlightElevation: 0,
        disabledElevation: 0,
        splashColor: Colors.white70,
        child: child,
      ),
    );
  }
}

class _PinField extends StatelessWidget {
  const _PinField(this.pin, this.isInvalid);
  final List<int> pin;
  final bool isInvalid;

  @override
  Widget build(BuildContext context) {
    return Material(
      textStyle: const TextStyle(fontSize: 35, color: Colors.white),
      color: Colors.transparent,
      child: SizedBox(
        height: 50,
        child: isInvalid
            ? const InitiallyWigglingText("PIN-Eingabe ungültig")
            : Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                for (int i = 0; i < pin.length; i++)
                  _PinDigitField(
                    pin[i],
                    i == pin.length - 1,
                    key: ValueKey("$i-${pin[i]}"),
                  )
              ]),
      ),
    );
  }
}

class _PinDigitField extends StatefulWidget {
  const _PinDigitField(this.digit, this.last, {super.key});

  final int digit;
  final bool last;

  @override
  State<_PinDigitField> createState() => __PinDigitFieldState();
}

class __PinDigitFieldState extends State<_PinDigitField> {
  bool hidden = false;
  bool invalid = false;

  @override
  void didChangeDependencies() {
    Future.delayed(const Duration(seconds: 1)).then((value) {
      if (mounted) {
        setState(() {
          hidden = true;
        });
      }
    });
    super.didChangeDependencies();
  }

  @override
  void didUpdateWidget(covariant _PinDigitField oldWidget) {
    invalid = false;
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 20,
      child: Center(
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          transitionBuilder: (Widget child, Animation<double> animation) {
            return ScaleTransition(scale: animation, child: child);
          },
          child: widget.last && !hidden
              ? Text(
                  widget.digit.toString(),
                )
              : Container(
                  height: 10,
                  width: 10,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                  ),
                ),
        ),
      ),
    );
  }
}

class InitiallyWigglingText extends StatelessWidget {
  const InitiallyWigglingText(this.text, {super.key});

  final String text;

  double bounce(double t) {
    const steps = 1 / 2;
    return (((steps * 0.5) - (((t + 0.25 * steps) % steps))).abs() -
            0.25 * steps) /
        (steps / 4);
  }

  double smooth(double t) {
    return pow(t.abs(), 1 / 3) * t.sign;
  }

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: const Duration(milliseconds: 300),
      builder: (context, value, child) {
        return Transform.rotate(
          angle: smooth(bounce(value)) / 15,
          origin: const Offset(0, 500),
          child: Text(
            text,
            style: const TextStyle(fontSize: 25),
          ),
        );
      },
    );
  }
}
