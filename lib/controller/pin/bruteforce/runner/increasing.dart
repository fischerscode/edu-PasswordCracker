import 'runner.dart';

class IncreasingBruteForceRunner extends BruteForceRunner {
  IncreasingBruteForceRunner(super.inputController, super.speed);

  @override
  List<int> get currentPin {
    return BruteForceRunner.getDigitsFromNumber(
        pinCounter, inputController.pinLength());
  }
}
