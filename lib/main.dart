import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:password_cracker/bruteforce.dart';
import 'package:password_cracker/device/device.dart';
import 'package:password_cracker/device/pages/locked.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(const CrackerApp());
}

class CrackerApp extends StatefulWidget {
  const CrackerApp({super.key});

  @override
  State<CrackerApp> createState() => _CrackerAppState();
}

class _CrackerAppState extends State<CrackerApp> {
  final inputController = PinInputController();

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DevicePreview(
        enabled: true,
        isToolbarVisible: true,
        defaultDevice: Devices.android.samsungGalaxyA50,
        tools: [
          SliverToBoxAdapter(
            child: Builder(builder: (context) {
              return IconButton(
                onPressed: () {
                  showAboutDialog(
                      context: context,
                      applicationName: "PasswordCracker",
                      children: [
                        const Text(
                            'PasswordCracker soll einen Brute-Force-Angriff\n'
                            'visualisieren und damit einen Einstieg in die\n'
                            'Passwortsicherheit bieten.'),
                        InkWell(
                            onTap: () async {
                              final uri = Uri.parse(
                                  "https://github.com/fischerscode/edu-PasswordCracker");
                              launchUrl(uri);
                            },
                            child: Image.asset(
                              "assets/GitHub_Logo.png",
                              height: 50,
                            ))
                      ]);
                },
                icon: const Icon(Icons.question_mark),
              );
            }),
          ),
          BruteForceController(inputController),
        ],
        builder: (context) => Device(inputController),
      ),
    );
  }
}
