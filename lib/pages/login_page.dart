import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wallapp/components/button.dart';
import 'package:wallapp/components/text_field.dart';

class LoginPage extends StatefulWidget {
  final Function()? onTap;

  const LoginPage({super.key, required this.onTap});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailTextController = TextEditingController();
  TextEditingController passwordTextController = TextEditingController();

  void signIn() async {
    showDialog(
        context: context,
        builder: (context) => const Center(
              child: CircularProgressIndicator(),
            ));

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailTextController.text,
          password: passwordTextController.text);
      if (context.mounted) Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context);
      displayMessage(e.code);
    }
  }

  void displayMessage(String message) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text(message),
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            //logo

            //welcom back
            const SizedBox(
              height: 30,
            ),
            // email
            MyTextField(
                controller: emailTextController,
                hintText: 'Email',
                obscureText: false),
            // // password
            MyTextField(
                controller: passwordTextController,
                hintText: 'password',
                obscureText: true),

            const SizedBox(
              height: 40,
            ),
            // sign in button
            MyButton(
                onTap: () {
                  signIn();
                },
                text: 'Sign in'),
            // go to register page
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Not a member  '),
                GestureDetector(
                  onTap: widget.onTap,
                  child: const Text(
                    "register now",
                    style: TextStyle(
                        color: Colors.blue, fontWeight: FontWeight.bold),
                  ),
                )
              ],
            )
          ]),
        ),
      ),
    );
  }
}
