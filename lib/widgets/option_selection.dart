import 'package:flutter/material.dart';

class MultiButtonSelection extends StatelessWidget {
  const MultiButtonSelection({
    super.key,
    required this.options,
    required this.selected,
    required this.onSelected,
  });

  final List<String> options;
  final int selected;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      direction: Axis.horizontal,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        for (var i = 0; i < options.length; i++)
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            switchInCurve: Curves.easeInOut,
            switchOutCurve: Curves.easeInOut,
            child: selected == i
                ? ElevatedButton(
                    onPressed: () => onSelected(i),
                    child: Text(options[i]),
                  )
                : OutlinedButton(
                    onPressed: () => onSelected(i),
                    child: Text(options[i]),
                  ),
          )
      ],
    );
  }
}
