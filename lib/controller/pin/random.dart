part of 'controller.dart';

class RandomPinController extends PinController {
  @override
  late List<int> _pin;

  RandomPinController() {
    setPinLength(4);
  }

  void setPinLength(int pinLength) {
    var random = Random();
    _pin = List.generate(pinLength, (index) => random.nextInt(10));
    notifyListeners();
  }

  @override
  Widget buildSettings(BuildContext context) {
    return Column(
      children: [
        _buildPinTypeSwitcher(context),
        Slider(
          value: _pin.length.toDouble(),
          min: 1,
          max: 8,
          divisions: 7,
          label: '${_pin.length}',
          onChanged: (value) {
            setPinLength(value.ceil());
          },
        ),
      ],
    );
  }
}
