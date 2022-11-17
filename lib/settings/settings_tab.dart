import 'package:flutter/material.dart';
import 'package:password_cracker/controller/controller.dart';
import 'package:password_cracker/settings/about.dart';
import 'package:provider/provider.dart';

class SettingsTab extends StatelessWidget {
  const SettingsTab({super.key});

  @override
  Widget build(BuildContext context) {
    var controller = Provider.of<LoginController>(context);
    return Flex(
      direction: Axis.vertical,
      children: [
        Expanded(child: controller.buildSettings(context)),
        const AboutButtons(),
      ],
    );
  }
}
