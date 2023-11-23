import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:whatsapp/models/message_model.dart';
import 'package:whatsapp/variables/vars.dart';

class ChatProvider extends ChangeNotifier {
  FirebaseAuth fireAuth = FirebaseAuth.instance;
  FirebaseFirestore fstorage = FirebaseFirestore.instance;

//send message
  Future<void> sendMessage(
      String receiverId, String sendMessage, File? imageFiles) async {
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
        timeStamp: timeStamp,
        imageUrl: null);

    if (imageFiles != null) {
      // If an image is selected, upload it to Firebase Storage
      String imageUrls = await uploadImage(imageFiles);
      messageModel.imageUrl = imageUrls;
      imageFile = null; // made image file null
    }

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

    imageFile = null;
    imageFiles = null;
    messageModel.imageUrl = null;
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

  // File? image;
  // Future pickImage() async {
  //   try {
  //     final image = await ImagePicker().pickImage(source: ImageSource.gallery);
  //     if (image == null) return;
  //     final imageTemp = File(image.path);
  //     this.image = imageTemp;
  //   } on PlatformException catch (e) {
  //     print('Failed to pick image: $e');
  //   }
  // }

  Future<String> uploadImage(File imageFile) async {
    Reference storageReference = FirebaseStorage.instance
        .ref()
        .child("chat_images/${DateTime.now().millisecondsSinceEpoch}");
    UploadTask uploadTask = storageReference.putFile(imageFile);
    TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => null);
    String imageUrl = await taskSnapshot.ref.getDownloadURL();
    return imageUrl;
  }
}
