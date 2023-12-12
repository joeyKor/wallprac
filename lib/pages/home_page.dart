import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:wallapp/components/drawer.dart';
import 'package:wallapp/components/text_field.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wallapp/components/wall_post.dart';
import 'package:wallapp/pages/profile_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final textController = TextEditingController();
  final currentUser = FirebaseAuth.instance.currentUser!;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MyDrawer(onProfileTap: goToProfilePage, onSignOut: signOut),
      appBar: AppBar(
        backgroundColor: Colors.grey[300],
        title: const Text("Joy stargram"),
        actions: [
          IconButton(onPressed: signOut, icon: const Icon(Icons.logout))
        ],
      ),
      body: Center(
        child: Column(
          children: [
            Expanded(
                child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('User Posts')
                  .orderBy('TimeStamp', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        final post = snapshot.data!.docs[index];
                        return WallPost(
                            message: post['Message'],
                            user: post['UserEmail'],
                            postId: post.id,
                            likes: List<String>.from(post['Likes'] ?? []));
                      });
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text('Error${snapshot.error}'),
                  );
                }
                return const Center(
                  child: CircularProgressIndicator(),
                );
              },
            )),
            Row(
              children: [
                Expanded(
                  child: MyTextField(
                      controller: textController,
                      hintText: 'write sth',
                      obscureText: false),
                ),
                IconButton(
                    onPressed: postMessage,
                    icon: const Icon(Icons.arrow_circle_up))
              ],
            )
          ],
        ),
      ),
    );
  }

  void signOut() {
    FirebaseAuth.instance.signOut();
  }

  postMessage() {
    if (textController.text.isNotEmpty) {
      FirebaseFirestore.instance.collection('User Posts').add({
        'UserEmail': currentUser.email,
        'Message': textController.text,
        'TimeStamp': Timestamp.now(),
        'Likes': [],
      });
    }

    setState(() {
      textController.clear();
    });
  }

  void goToProfilePage() {
    Navigator.pop(context);

    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const ProfilePage()));
  }
}
