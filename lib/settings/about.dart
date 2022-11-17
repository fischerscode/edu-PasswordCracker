import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutButtons extends StatelessWidget {
  const AboutButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        IconButton(
          onPressed: () async {
            String version = (await PackageInfo.fromPlatform()).version;
            showAboutDialog(
                context: context,
                applicationVersion: "v$version",
                applicationName: "PasswordCracker",
                children: [
                  const Text('PasswordCracker soll einen Brute-Force-Angriff\n'
                      'visualisieren und damit einen Einstieg in die\n'
                      'Passwortsicherheit bieten.'),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      InkWell(
                          onTap: () async {
                            final uri = Uri.parse(
                                "https://github.com/fischerscode/edu-PasswordCracker");
                            launchUrl(uri);
                          },
                          child: Image.asset(
                            "assets/GitHub_Logo.png",
                            height: 50,
                          )),
                      const _DownloadButton(),
                    ],
                  )
                ]);
          },
          icon: const Icon(Icons.question_mark),
        ),
        const _DownloadButton(),
      ],
    );
  }
}

class _DownloadButton extends StatelessWidget {
  const _DownloadButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        final uri = Uri.parse(
            "https://github.com/fischerscode/edu-PasswordCracker/releases/latest/");
        launchUrl(uri);
      },
      icon: const Icon(Icons.download),
    );
  }
}
