part of 'pin_lock_screen.dart';

abstract class _PinInputController {
  void addDigit(int digit);
  void removeLast();
  bool validate();
  int inputLength();
  void enableUserInput();
  void disableUserInput();
}

abstract class PinInputController implements _PinInputController {
  _PinLockScreenState? _subscriber;

  bool pressButtons = true;
  bool updateUi = true;

  DateTime _lastPress = DateTime(0);

  @override
  void addDigit(int digit) {
    if (pressButtons) {
      pressKey(_subscriber?.digitKeys[digit]);
    }
    _subscriber?.addDigit(digit, updateUi);
  }

  @override
  void removeLast() {
    if (pressButtons) {
      pressKey(_subscriber?.removeKey);
    }
    _subscriber?.removeLast(updateUi);
  }

  @override
  bool validate() {
    if (pressButtons) {
      pressKey(_subscriber?.okKey);
    }
    return _subscriber?.validate(updateUi) ?? false;
  }

  @override
  int inputLength() => _subscriber?.inputLength() ?? 0;

  int pinLength();

  List<int> getInput() => _subscriber?.input.toList() ?? [];

  int pendingPressCounter = 0;

  void pressKey(GlobalKey? key) {
    if (key != null) {
      if (pendingPressCounter == 0) {
        pendingPressCounter++;
        WidgetsBinding.instance.scheduleTask(() {
          pendingPressCounter--;
          RenderBox box = key.currentContext!.findRenderObject() as RenderBox;
          Offset position = box
              .localToGlobal(Offset.zero)
              .translate(box.size.width / 2, box.size.height / 2);

          WidgetsFlutterBinding.ensureInitialized()
              .handlePointerEvent(PointerDownEvent(
            pointer: 0,
            position: position,
          ));
          WidgetsFlutterBinding.ensureInitialized()
              .handlePointerEvent(PointerUpEvent(
            pointer: 0,
            position: position,
          ));
        }, Priority.animation, debugLabel: "Simulate button press.");
      }
    }
  }

  @override
  void disableUserInput() {
    _subscriber?.disableUserInput();
  }

  @override
  void enableUserInput() {
    _subscriber?.enableUserInput();
  }
}
