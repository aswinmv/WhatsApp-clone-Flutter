import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:whatsapp/models/message_model.dart';

class ChatProvider extends ChangeNotifier {
  FirebaseAuth fireAuth = FirebaseAuth.instance;
  FirebaseFirestore fstorage = FirebaseFirestore.instance;

//send message
  Future<void> sendMessage(String receiverId, String sendMessage) async {
// //
    final String currentUserEmail = fireAuth.currentUser!.email.toString();
    final String currentUserId = fireAuth.currentUser!.uid;
    final Timestamp timeStamp = Timestamp.now();
// //
    MessageModel messageModel = MessageModel(
        senderId: currentUserId,
        senderEmail: currentUserEmail,
        receiverId: receiverId,
        message: sendMessage,
        timeStamp: timeStamp);
// model
    List<String> ids = [currentUserId, receiverId];
// creating chat room id
    ids.sort();
// by sorting / adding
    final String chatRoomId = ids.join("_");

//
    fstorage
        .collection("chatroom")
        .doc(chatRoomId)
        .collection("chats")
        .add(messageModel.toMap());
  }

  //get chats
  Stream<QuerySnapshot> getMessages(
    String currentId,
    String oppUid,
  ) {
    List<String> ids = [currentId, oppUid];

    ids.sort();

    final String chatRoomId = ids.join("_");

    return fstorage
        .collection("chatroom")
        .doc(chatRoomId)
        .collection("chats")
        .orderBy('timeStamp', descending: true)
        .snapshots();
  }

  File? image;
  Future pickImage() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) return;
      final imageTemp = File(image.path);
      this.image = imageTemp;
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }
}
