import 'package:flutter/material.dart';

import '../Components/Helpers/firebase_auth_helper.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    final GlobalKey<FormState> loginPageKey = GlobalKey<FormState>();
    TextEditingController emailController = TextEditingController();
    TextEditingController passwordContoller = TextEditingController();
    String? email;
    String? Password;
    return Scaffold(
      appBar: AppBar(),
      body: Form(
        key: loginPageKey,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.only(top: 24, right: 24, left: 24),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      height: 150,
                      width: 150,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        image: DecorationImage(
                            image: NetworkImage(
                                "https://mir-s3-cdn-cf.behance.net/project_modules/hd/7fa98b78083395.5c9a8329bfaf3.gif"),
                            fit: BoxFit.cover),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  const Center(
                    child: Text(
                      "Login",
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 30,
                      ),
                    ),
                  ),
                  const Text(
                    "Email",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  TextFormField(
                    controller: emailController,
                    textInputAction: TextInputAction.next,
                    validator: (val) {
                      if (val!.isEmpty) {
                        return "Your email id";
                      }
                      return null;
                    },
                    onSaved: (val) {
                      email = val!;
                    },
                    decoration:
                        const InputDecoration(hintText: "Enter Your Email id"),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Text(
                    "Password",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  TextFormField(
                    controller: passwordContoller,
                    textInputAction: TextInputAction.next,
                    obscureText: true,
                    validator: (val) {
                      if (val!.isEmpty) {
                        return "Your Password";
                      }
                      return null;
                    },
                    onSaved: (val) {
                      Password = val!;
                    },
                    decoration:
                        const InputDecoration(hintText: "Enter Your Password"),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pushNamed('forget_password_screen');
                    },
                    child: const Text(
                      "Forget Password ?",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Center(
                    child: ElevatedButton(
                      onPressed: () async {
                        if (loginPageKey.currentState!.validate()) {
                          loginPageKey.currentState!.save();
                          Map<String, dynamic> res = await Auth_Helper
                              .auth_helper
                              .SignIn(email: email!, password: Password!);
                          if (res['user'] != null) {
                            Navigator.pushNamed(context, "home");
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text("Login SuccessFully...."),
                              ),
                            );
                          } else if (res['error'] != null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text("Login Failed...."),
                              ),
                            );
                          }
                        }
                      },
                      child: const Text(
                        "Log in",
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Center(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).pushNamed('signup_screen');
                      },
                      child: const Text(
                        "Don't have an account? Sign-UP",
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
