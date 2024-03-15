import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:chat_app/widgets/chat/message_bubble.dart';

class Messages extends StatelessWidget {
  const Messages({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: FirebaseAuth.instance.authStateChanges().first,
        builder: (ctx, futureSnapshot) {
          if (futureSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('chat')
                  .orderBy('createdAt', descending: true)
                  .snapshots(),
              builder: (ctx, chatSnapshots) {
                if (chatSnapshots.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                final chatDocs = chatSnapshots.data!.docs;
                return ListView.builder(
                  reverse: true,
                  itemCount: chatDocs.length,
                  itemBuilder: (context, index) => MessageBubble(
                    chatDocs[index]['text'],
                    chatDocs[index]['userId'] == futureSnapshot.data!.uid,
                    chatDocs[index]['username'],
                    chatDocs[index]['userImage'],
                    key: ValueKey(chatDocs[index].id),
                  ),
                );
              });
        });
  }
}
