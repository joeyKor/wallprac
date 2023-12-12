import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:wallapp/components/like_button.dart';

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
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isLiked = widget.likes.contains(currentUser.email);
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
      child: Row(
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
        ],
      ),
    );
  }
}