import 'package:flutter/material.dart';
import 'package:password_cracker/controller/pin/bruteforce/controller.dart';
import 'package:password_cracker/controller/pin/layout/pin_lock_screen.dart';
import 'package:provider/provider.dart';

class BruteForceWidget extends StatelessWidget {
  const BruteForceWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    var controller = Provider.of<BruteForceController>(context);
    return Column(children: [
      ElevatedButton(
          onPressed: !controller.isRunning ? controller.start : controller.stop,
          child: Text(controller.isRunning ? "STOP" : "START")),
      ...controller.buildSettings(context),
      Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text("Tastendruck anzeigen"),
          Switch(
            value: controller.pressButtons,
            onChanged: controller.onPressButtonsChange,
          ),
        ],
      ),
      Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text("Anzeige aktualisieren"),
          Switch(
            value: controller.updateUi,
            onChanged: controller.onUpdateUiChange,
          ),
        ],
      ),
      if (controller.currentPin != null)
        DefaultTextStyle(
          style: DefaultTextStyle.of(context)
              .style
              .copyWith(color: Colors.black54),
          child: PinField(
            controller.currentPin!,
            hide: false,
          ),
        )
    ]);
  }
}
