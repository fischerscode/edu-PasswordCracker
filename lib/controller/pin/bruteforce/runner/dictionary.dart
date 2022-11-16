import 'package:password_cracker/controller/pin/bruteforce/runner/runner.dart';

class DictionaryBruteForceRunner extends BruteForceRunner {
  DictionaryBruteForceRunner(super.inputController, super.speed) {
    List<int> countUp(int start) => List.generate(
        inputController.pinLength(), (index) => (index + start) % 10);
    List<int> countDown(int start) => List.generate(
        inputController.pinLength(), (index) => (start - index) % 10);
    dictionary = [
      countUp(1),
      for (var i = 0; i <= 9; i++)
        List.generate(inputController.pinLength(), (index) => i),
      countUp(0),
      for (var i = 2; i <= 9; i++) countUp(i),
      for (var i = 0; i <= 9; i++) countDown(i),
    ];
  }

  late final List<List<int>> dictionary;

  @override
  List<int>? get currentPin {
    return pinCounter >= dictionary.length ? null : dictionary[pinCounter];
  }
}
