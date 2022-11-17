import 'package:password_cracker/controller/pin/bruteforce/runner/decreasing.dart';
import 'package:password_cracker/controller/pin/bruteforce/runner/dictionary.dart';
import 'package:password_cracker/controller/pin/bruteforce/runner/increasing.dart';
import 'package:password_cracker/controller/pin/bruteforce/runner/middle.dart';
import 'package:password_cracker/controller/pin/bruteforce/runner/random.dart';
import 'package:password_cracker/controller/pin/bruteforce/runner/runner.dart';
import 'package:password_cracker/controller/pin/bruteforce/speed.dart';
import 'package:password_cracker/controller/pin/controller.dart';

enum BruteForceStrategy {
  raising("Steigend"),
  falling("Fallend"),
  middle("Mitte"),
  random("Zufall"),
  dictionary("Wörterbuch"),
  ;

  final String text;

  const BruteForceStrategy(this.text);

  BruteForceRunner create(
      PinController inputController, BruteForceSpeed speed) {
    switch (this) {
      case BruteForceStrategy.raising:
        return IncreasingBruteForceRunner(inputController, speed);
      case BruteForceStrategy.falling:
        return DecreasingBruteForceRunner(inputController, speed);
      case BruteForceStrategy.random:
        return RandomBruteForceRunner(inputController, speed);
      case BruteForceStrategy.middle:
        return MiddleBruteForceRunner(inputController, speed);
      case BruteForceStrategy.dictionary:
        return DictionaryBruteForceRunner(inputController, speed);
    }
  }
}
