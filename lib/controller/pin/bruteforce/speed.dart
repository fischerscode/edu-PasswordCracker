enum BruteForceSpeed {
  extraFast("extra schnell", 1000),
  fast("schnell", 100),
  medium("zügig", 10),
  slow("langsam", 1),
  extraSlow("extra langsam", 0.2),
  ;

  final double attacksPerSecond;
  final String text;
  const BruteForceSpeed(this.text, this.attacksPerSecond);

  Duration getPressDelay(int pinLength) {
    return Duration(
        microseconds:
            (Duration.microsecondsPerSecond / attacksPerSecond / pinLength)
                .ceil());
  }

  @override
  String toString() => text;
}
