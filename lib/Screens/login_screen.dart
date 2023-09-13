import 'dart:developer';

import 'package:chat_app_af_12/Components/Helpers/firebase_auth_helper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';

class Login_Screen extends StatefulWidget {
  const Login_Screen({super.key});

  @override
  State<Login_Screen> createState() => _Login_ScreenState();
}

class _Login_ScreenState extends State<Login_Screen> {
  @override
  Widget build(BuildContext context) {
    return FlutterLogin(
      headerWidget: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: () {
              Auth_Helper.auth_helper.SigninAnonymous().then(
                    (value) => Navigator.pushNamed(
                      context,
                      'home',
                    ),
                  );
            },
            child: Text("Sign in Anonymously"),
          ),
          ElevatedButton(
            onPressed: () async {
              User? res = await Auth_Helper.auth_helper.signInWithGoogle();
              if (res != null) {
                Navigator.pushReplacementNamed(context, "home", arguments: res);
              } else {}
            },
            child: Text("Google Sign in"),
          ),
        ],
      ),
      onSignup: (val) {
        Auth_Helper.auth_helper
            .SignUp(email: val.name!, password: val.password!);
        Navigator.pop(context);
      },
      logo: NetworkImage("https://freepngimg.com/thumb/categories/1452.png"),
      title: "WhatsApp",
      initialAuthMode: AuthMode.signup,
      userType: LoginUserType.email,
      onLogin: (LoginData val) async {
        Map<String, dynamic> res = await Auth_Helper.auth_helper
            .SignIn(email: val.name, password: val.password);
        if (res['user'] != null) {
          Navigator.pushNamed(context, "home");
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Login SuccessFully...."),
            ),
          );
        } else if (res['error'] != null) {
          Navigator.pushNamed(context, '/');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Login Failed...."),
            ),
          );
        }
      },
      onRecoverPassword: (val) {},
    );
  }
}
