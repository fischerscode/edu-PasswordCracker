import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:password_cracker/controller/controller.dart';
import 'package:password_cracker/device/device.dart';
import 'package:password_cracker/settings/settings_tab.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const CrackerApp());
}

class CrackerApp extends StatefulWidget {
  const CrackerApp({super.key});

  @override
  State<CrackerApp> createState() => _CrackerAppState();
}

class _CrackerAppState extends State<CrackerApp> {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ChangeNotifierProvider(
        create: (_) => AppController(),
        child: Builder(builder: (context) {
          var loginController =
              Provider.of<AppController>(context).loginController;
          return ChangeNotifierProvider.value(
            value: loginController,
            child: Flex(
              direction: Axis.horizontal,
              children: [
                Expanded(
                  flex: 2,
                  child: DevicePreview(
                    enabled: true,
                    isToolbarVisible: false,
                    defaultDevice: Devices.android.samsungGalaxyA50,
                    builder: (context) => const Device(),
                  ),
                ),
                Expanded(
                    child: DefaultTabController(
                  length: 2,
                  child: Scaffold(
                    appBar: const TabBar(
                      labelColor: Colors.black87,
                      tabs: [
                        Tab(
                          icon: Icon(Icons.settings),
                        ),
                        Tab(
                          icon: Icon(Icons.construction_outlined),
                        ),
                      ],
                    ),
                    body: TabBarView(children: [
                      const SettingsTab(),
                      loginController.buildBruteForce(context),
                    ]),
                  ),
                )),
              ],
            ),
          );
        }),
      ),
    );
  }
}
