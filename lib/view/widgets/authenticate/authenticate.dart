import 'package:budget_app/view/pages/authenticate/login_page.dart';
import 'package:budget_app/view/pages/authenticate/register_page.dart';
import 'package:flutter/material.dart';

class Authenticate extends StatefulWidget {
  @override
  _AuthenticateState createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {
  bool showSignIn = true;

  void toggleView() {
    setState(() {
      showSignIn = !showSignIn;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showSignIn) {
      return Scaffold(
        body: LoginPage(toggleView: toggleView),
      );
    }else{
      return Scaffold(
        body: RegisterPage(toggleView: toggleView),
      );
    }
  }
}
