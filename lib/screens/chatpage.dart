import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:whatsapp/provider/chatprovider.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.receiverUserEmail, overflow: TextOverflow.ellipsis),
        backgroundColor: Colors.green.shade300,
      ),
      body: Column(children: [
        Expanded(child: _chatBilder()),
        Row(
          children: [
            Expanded(
                child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: controller,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(30)))),
              ),
            )),
            // attach///////////////////////////////////////////////////////////
            IconButton(
                onPressed: () {
                  chatProvider.pickImage();
                },
                icon: const Icon(
                  Icons.attach_file_outlined,
                )),
            // send/////////////////////////////////////////////////
            IconButton(
                onPressed: () {
                  chatProvider.sendMessage(
                      widget.receiverUserId, controller.text);
                  controller.clear();
                },
                icon: const Icon(Icons.send))
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

    return Container(
      color: Colors.grey[300],
      alignment: alignment,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          width: MediaQuery.of(context).size.width * .45,
          height: MediaQuery.of(context).size.height * .1,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: Colors.deepPurple[200],
          ),
          child: Column(
              children: [Text(data["senderEmail"]), Text(data["message"])]),
        ),
      ),
    );
  }
}
