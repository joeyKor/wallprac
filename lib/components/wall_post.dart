import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:wallapp/components/comment.dart';
import 'package:wallapp/components/comment_button.dart';
import 'package:wallapp/components/like_button.dart';
import 'package:wallapp/help/helper_methods.dart';

class WallPost extends StatefulWidget {
  final String message;
  final String user;
  final String postId;
  final List<String> likes;

  const WallPost(
      {super.key,
      required this.message,
      required this.user,
      required this.postId,
      required this.likes});

  @override
  State<WallPost> createState() => _WallPostState();
}

class _WallPostState extends State<WallPost> {
  final currentUser = FirebaseAuth.instance.currentUser!;
  bool isLiked = false;

  final _commentTextController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isLiked = widget.likes.contains(currentUser.email);
  }

  void addCommnet(String commentText) {
    FirebaseFirestore.instance
        .collection('User Posts')
        .doc(widget.postId)
        .collection("Comments")
        .add({
      "CommentText": commentText,
      "CommentedBy": currentUser.email,
      "CommentTime": Timestamp.now() // remember to formatn this when displaying
    });

    _commentTextController.clear();
    Navigator.pop(context);
  }

  void showCommnetDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("add commnet"),
        content: TextField(
          controller: _commentTextController,
          decoration: const InputDecoration(hintText: "Write a comment"),
        ),
        actions: [
          TextButton(
              onPressed: () => addCommnet(_commentTextController.text),
              child: const Text("Post")),
          TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'))
        ],
      ),
    );
  }

  void toggleLIkes() {
    setState(() {
      isLiked = !isLiked;
    });
    //access the document is firebase
    DocumentReference postRef =
        FirebaseFirestore.instance.collection('User Posts').doc(widget.postId);

    if (isLiked) {
      postRef.update({
        "Likes": FieldValue.arrayUnion([currentUser.email])
      });
    } else {
      postRef.update({
        "Likes": FieldValue.arrayRemove([currentUser.email])
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Colors.deepOrange[100]),
      margin: const EdgeInsets.only(top: 25, left: 25, right: 25),
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Row(
            children: [
              Column(
                children: [
                  LikeButton(isLiked: isLiked, onTap: toggleLIkes),
                  Text(widget.likes.length.toString())
                ],
              ),
              // Container(
              //   decoration:
              //       BoxDecoration(shape: BoxShape.circle, color: Colors.grey[400]),
              //   padding: const EdgeInsets.all(10),
              //   child: const Icon(
              //     Icons.person,
              //     color: Colors.white,
              //   ),
              // ),
              const SizedBox(
                width: 20,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.message,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(widget.user)
                ],
              ),
              Column(
                children: [
                  CommentButton(onTap: () {
                    showCommnetDialog();
                  }),
                  Text(widget.likes.length.toString())
                ],
              ),
            ],
          ),
          StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('User Posts')
                  .doc(widget.postId)
                  .collection('Comments')
                  .orderBy("CommentTime", descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                return ListView(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  children: snapshot.data!.docs.map((doc) {
                    final commentData = doc.data() as Map<String, dynamic>;
                    return Comment(
                        text: commentData['CommentText'],
                        time: formatData(commentData['CommentTime']),
                        user: commentData['CommentedBy']);
                  }).toList(),
                );
              })
        ],
      ),
    );
  }
}
