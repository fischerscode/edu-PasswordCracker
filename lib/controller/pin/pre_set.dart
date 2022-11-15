part of 'controller.dart';

class PreSetPinController extends PinController {
  @override
  List<int> _pin = [1, 2, 3, 4];

  PreSetPinController();

  void setPin(List<int> pin) {
    _pin = pin;
    notifyListeners();
  }

  @override
  Widget buildSettings(BuildContext context) {
    return Column(
      children: [
        _buildPinTypeSwitcher(context),
        PinField(
          _pin,
          hide: false,
        ),
        ElevatedButton(
          onPressed: () {
            var input = getInput();

            if (input.isNotEmpty) {
              while (inputLength() > 0) {
                removeLast();
              }
              setPin(input);
            }
          },
          child: const Text('Aktuelle Eingabe als Pin setzen.'),
        ),
      ],
    );
  }
}
