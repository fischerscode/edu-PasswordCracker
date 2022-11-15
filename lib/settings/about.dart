import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutButton extends StatelessWidget {
  const AboutButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        showAboutDialog(
            context: context,
            applicationName: "PasswordCracker",
            children: [
              const Text('PasswordCracker soll einen Brute-Force-Angriff\n'
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
  }
}
