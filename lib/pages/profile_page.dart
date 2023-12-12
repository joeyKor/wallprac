import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:wallapp/components/text_box.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final currentUser = FirebaseAuth.instance.currentUser!;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[300],
        appBar: AppBar(
          title: const Text("Profile Page"),
          backgroundColor: Colors.grey[900],
        ),
        body: ListView(
          children: [
            const SizedBox(
              height: 50,
            ),
            const Icon(
              Icons.person,
              size: 72,
            ),
            Text(
              currentUser.email!,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey[700]),
            ),
            MyTextBox(
              text: 'BIo',
              sectionName: 'Samsung BIo',
              onPressed: () {},
            ),
          ],
        ));
  }
}
