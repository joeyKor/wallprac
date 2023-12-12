import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:wallapp/components/button.dart';
import 'package:wallapp/components/text_field.dart';

class RegisterPage extends StatefulWidget {
  final Function()? onTap;
  const RegisterPage({super.key, required this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final emailTextController = TextEditingController();
  final passwordTextController = TextEditingController();
  final confirmPasswordTextController = TextEditingController();

  void signUp() async {
    showDialog(
        context: context,
        builder: (context) => const Center(
              child: CircularProgressIndicator(),
            ));

    if (passwordTextController.text != confirmPasswordTextController.text) {
      Navigator.pop(context);
      displayMessage('password Dont match');
      return;
    }

    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailTextController.text,
          password: passwordTextController.text);
      if (context.mounted) Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
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
            const SizedBox(
              height: 10,
            ),
            // // password
            MyTextField(
                controller: passwordTextController,
                hintText: 'password',
                obscureText: true),
            const SizedBox(
              height: 10,
            ),
            // // password
            MyTextField(
                controller: confirmPasswordTextController,
                hintText: 'confirm password',
                obscureText: true),
            const SizedBox(
              height: 40,
            ),
            // sign in button
            MyButton(
                onTap: () {
                  signUp();
                },
                text: 'Sign Up'),
            // go to register page
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Already have an account?  '),
                GestureDetector(
                  onTap: widget.onTap,
                  child: const Text(
                    "Login Now",
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
