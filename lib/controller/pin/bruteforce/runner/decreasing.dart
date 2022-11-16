import 'package:password_cracker/controller/pin/bruteforce/runner/runner.dart';

class DecreasingBruteForceRunner extends BruteForceRunner {
  DecreasingBruteForceRunner(super.inputController, super.speed);

  @override
  List<int> get currentPin {
    return BruteForceRunner.getDigitsFromNumber(
            pinCounter, inputController.pinLength())
        .map((digit) => 9 - digit)
        .toList(growable: false);
  }
}
