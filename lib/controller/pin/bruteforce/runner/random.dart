import 'dart:math';

import 'runner.dart';

/// Nutzt einen Linearen Kongruenzgenerator um alle pins in "zufällgier" Reihenfolge zu testen.
/// https://de.wikipedia.org/wiki/Kongruenzgenerator#Linearer_Kongruenzgenerator)
class RandomBruteForceRunner extends BruteForceRunner {
  int get m => pow(10, inputController.pinLength()).toInt();
  late final int b;
  late final int a;

  RandomBruteForceRunner(super.inputController, super.speed) {
    b = _primes[Random().nextInt(_primes.length)];
    a = (m % 4 == 0 ? 20 : 10) * Random().nextInt(1000) + 1;
  }

  @override
  List<int> get currentPin {
    return BruteForceRunner.getDigitsFromNumber(
        (a * pinCounter + b) % m, inputController.pinLength());
  }
}

const _primes = [
  7,
  11,
  13,
  17,
  19,
  23,
  29,
  31,
  37,
  41,
  43,
  47,
  53,
  59,
  61,
  67,
  71
];
