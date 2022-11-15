part of 'pin_lock_screen.dart';

class _PinDigitField extends StatefulWidget {
  const _PinDigitField(this.digit, this.last, this.hide, {super.key});

  final int digit;
  final bool last;
  final bool hide;

  @override
  State<_PinDigitField> createState() => _PinDigitFieldState();
}

class _PinDigitFieldState extends State<_PinDigitField> {
  bool hidden = false;
  bool invalid = false;

  @override
  void didChangeDependencies() {
    Future.delayed(const Duration(seconds: 1)).then((value) {
      if (mounted) {
        setState(() {
          hidden = true;
        });
      }
    });
    super.didChangeDependencies();
  }

  @override
  void didUpdateWidget(covariant _PinDigitField oldWidget) {
    invalid = false;
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 20,
      child: Center(
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          transitionBuilder: (Widget child, Animation<double> animation) {
            return ScaleTransition(scale: animation, child: child);
          },
          child: (widget.last && !hidden) || !widget.hide
              ? Text(widget.digit.toString())
              : Container(
                  height: 10,
                  width: 10,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                  ),
                ),
        ),
      ),
    );
  }
}
