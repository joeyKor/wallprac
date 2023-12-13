import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class CommentButton extends StatelessWidget {
  void Function()? onTap;
  CommentButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: onTap,
        child: const Icon(
          Icons.comment,
          color: Colors.grey,
        ));
  }
}
