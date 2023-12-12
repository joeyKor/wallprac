import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  final Function()? onTap;
  final String text;

  const MyButton({super.key, required this.onTap, required this.text});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.grey,
        ),
        child: Center(
            child: Text(
          text,
          style: const TextStyle(fontSize: 30),
        )),
      ),
    );
  }
}
