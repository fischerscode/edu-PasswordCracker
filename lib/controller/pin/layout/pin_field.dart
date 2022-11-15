part of 'pin_lock_screen.dart';

class PinField extends StatelessWidget {
  const PinField(
    this.pin, {
    this.hide = true,
    this.isInvalid = false,
    super.key,
  });
  final List<int> pin;
  final bool isInvalid;
  final bool hide;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: LayoutBuilder(
        builder: (context, constraints) {
          var width = min(constraints.biggest.width / pin.length, 50.0);
          return SizedBox(
            height: 50,
            child: DefaultTextStyle(
              style: DefaultTextStyle.of(context).style.copyWith(fontSize: 50),
              child: isInvalid
                  ? const InitiallyWigglingText("PIN-Eingabe ungültig")
                  : Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      for (int i = 0; i < pin.length; i++)
                        ConstrainedBox(
                          constraints: BoxConstraints(maxWidth: width),
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: _PinDigitField(
                                pin[i],
                                !hide || i == pin.length - 1,
                                hide,
                                key: ValueKey("$i-${pin[i]}"),
                              ),
                            ),
                          ),
                        )
                    ]),
            ),
          );
        },
      ),
    );
  }
}
