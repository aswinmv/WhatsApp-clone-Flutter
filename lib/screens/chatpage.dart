import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:whatsapp/provider/chatprovider.dart';
import 'package:whatsapp/screens/imageview.dart';

import '../variables/vars.dart';

class ChatPage extends StatefulWidget {
  final String receiverUserId;
  final String receiverUserEmail;
  const ChatPage(
      {super.key,
      required this.receiverUserId,
      required this.receiverUserEmail});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  ChatProvider chatProvider = ChatProvider();
  TextEditingController controller = TextEditingController();
  FirebaseAuth fireAuth = FirebaseAuth.instance;
  FirebaseFirestore fstorage = FirebaseFirestore.instance;

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        imageFile = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.receiverUserEmail, overflow: TextOverflow.ellipsis),
        backgroundColor: const Color(0xff017B6D),
      ),
      body: Column(children: [
        Expanded(child: _chatBilder()),
        Stack(
          children: [
            // IconButton(
            //     onPressed: () {},
            //     icon: const Icon(Icons.emoji_emotions_outlined)),
            Expanded(
                child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                height: 50,
                width: 350,
                child: TextField(
                  controller: controller,
                  decoration: const InputDecoration(
                      hintText: "Message",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(30)))),
                ),
              ),
            )),
            Padding(
              padding: const EdgeInsets.only(left: 300, top: 10),
              child: IconButton(
                  onPressed: () {
                    _pickImage();
                  },
                  icon: const Icon(
                    Icons.photo_camera_outlined,
                  )),
            ),
            // attach///////////////////////////////////////////////////////////
            Padding(
              padding: const EdgeInsets.only(left: 260, top: 10),
              child: IconButton(
                  onPressed: () {
                    _pickImage();
                  },
                  icon: Transform.rotate(
                    angle: 100,
                    child: const Icon(
                      Icons.attach_file_outlined,
                    ),
                  )),
            ),
            // send/////////////////////////////////////////////////
            Padding(
              padding: const EdgeInsets.only(left: 350, top: 10),
              child: IconButton(
                  onPressed: () {
                    chatProvider.sendMessage(
                        widget.receiverUserId, controller.text, imageFile);
                    controller.clear();
                  },
                  icon: const Icon(Icons.send)),
            )
          ],
        )
      ]),
    );
  }

  Widget _chatBilder() {
    return StreamBuilder(
        stream: chatProvider.getMessages(
            fireAuth.currentUser!.uid, widget.receiverUserId),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Text("Error");
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return ListView(
              reverse: true,
              children: snapshot.data!.docs
                  .map((docs) => _chatItemBuilder(docs))
                  .toList(),
            );
          }
        });
  }

  Widget _chatItemBuilder(DocumentSnapshot document) {
    Map<String, dynamic> data = document.data() as Map<String, dynamic>;
    var alignment = data["senderId"] == fireAuth.currentUser!.uid
        ? Alignment.centerRight
        : Alignment.centerLeft;
    var chatColor = data["senderId"] == fireAuth.currentUser!.uid
        ? const Color.fromARGB(255, 209, 242, 188)
        : Colors.white;

    if (data['imageUrl'] != null) {
      return Container(
        padding: const EdgeInsets.all(8),
        alignment: alignment,
        child: Column(
          children: [
            Text(data['senderEmail']),
            InkWell(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => ImageView(
                          image: data['imageUrl'],
                        )));
              },
              child: Container(
                height: 250,
                width: MediaQuery.of(context).size.width * 0.6,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    image: DecorationImage(
                        image: NetworkImage(data['imageUrl']),
                        fit: BoxFit.fitWidth)),
              ),
            ),
          ],
        ),
      );
    } else {
      return Container(
        alignment: alignment,
        child: Padding(
          padding: const EdgeInsets.only(left: 10, bottom: 10, top: 10),
          child: Container(
            // width: MediaQuery.of(context).size.width * .45,
            // height: MediaQuery.of(context).size.height * .1,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10), color: chatColor),
            child: Column(
                children: [Text(data["senderEmail"]), Text(data["message"])]),
          ),
        ),
      );
    }
  }
}
