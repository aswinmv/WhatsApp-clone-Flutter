import 'package:cloud_firestore/cloud_firestore.dart';

class MessageModel {
  final String senderId;
  final String senderEmail;
  final String receiverId;
  final String message;
  final Timestamp timeStamp;
  dynamic imageUrl;

  MessageModel(
      {required this.senderId,
      required this.senderEmail,
      required this.receiverId,
      required this.message,
      required this.timeStamp,
      required this.imageUrl});

  Map<String, dynamic> toMap() {
    return {
      "senderId": senderId,
      "senderEmail": senderEmail,
      "reveiverId": receiverId,
      "message": message,
      "timeStamp": timeStamp,
      "imageUrl": imageUrl
    };
  }
}
