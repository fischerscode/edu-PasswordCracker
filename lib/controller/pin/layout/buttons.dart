part of 'pin_lock_screen.dart';

class _DigitButton extends _InputButton {
  final int digit;

  _DigitButton(
    this.digit,
    super.input, {
    required super.ignorePress,
    super.buttonKey,
  }) : super(backgroundColor: Colors.grey.withOpacity(0.8));

  @override
  Widget get child => Text(
        digit.toString(),
        style: const TextStyle(fontSize: 40),
      );

  @override
  VoidCallback? get onPressed => () => inputController.addDigit(digit);
}

class _BackSpaceButton extends _InputButton {
  const _BackSpaceButton(
    super.input, {
    required super.ignorePress,
    super.buttonKey,
  }) : super(backgroundColor: Colors.transparent);

  @override
  Widget get child => const Icon(Icons.backspace);

  @override
  VoidCallback? get onPressed =>
      inputController.inputLength() > 0 ? inputController.removeLast : null;
}

class _OKButton extends _InputButton {
  const _OKButton(
    super.input, {
    required super.ignorePress,
    super.buttonKey,
  }) : super(backgroundColor: Colors.transparent);

  @override
  Widget get child => const Text('OK', style: TextStyle(fontSize: 30));

  @override
  VoidCallback? get onPressed =>
      inputController.inputLength() > 0 ? inputController.validate : null;
}

abstract class _InputButton extends StatelessWidget {
  const _InputButton(
    this.inputController, {
    this.backgroundColor,
    required this.ignorePress,
    this.buttonKey,
  });

  Widget get child;

  final Color? backgroundColor;
  final _PinInputController inputController;
  final bool ignorePress;
  final Key? buttonKey;

  VoidCallback? get onPressed;

  @override
  Widget build(BuildContext context) {
    var onPressed = this.onPressed;

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: RawMaterialButton(
        onPressed: ignorePress && onPressed != null ? () {} : onPressed,
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
        key: buttonKey,
        child: child,
      ),
    );
  }
}
