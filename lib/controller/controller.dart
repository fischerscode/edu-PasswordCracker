import 'package:flutter/material.dart';
import 'package:password_cracker/controller/pin/controller.dart';

class AppController extends ChangeNotifier {
  LoginController _loginController = RandomPinController();

  LoginController get loginController => _loginController;

  void setLoginController(LoginController loginController) {
    _loginController.dispose();
    _loginController = loginController;
    notifyListeners();
  }
}

abstract class LoginController extends ChangeNotifier {
  // Future<bool> validate(T input);

  LoginController();

  Widget buildSettings(BuildContext context);
  Widget buildSimulation(BuildContext context);
  Widget buildBruteForce(BuildContext context);
}
