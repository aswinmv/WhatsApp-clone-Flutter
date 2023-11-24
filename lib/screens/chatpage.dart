import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:whatsapp/provider/chatprovider.dart';
import 'package:whatsapp/screens/imageview.dart';
import 'package:whatsapp/screens/mainpage.dart';

import '../variables/vars.dart';

class ChatPage extends StatefulWidget {
  final String receiverUserId;
  final String receiverUserEmail;
  final String receverName;
  const ChatPage(
      {super.key,
      required this.receiverUserId,
      required this.receiverUserEmail,
      required this.receverName});

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
    return Container(
      decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assets/whats.jpg"), fit: BoxFit.cover)),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          toolbarHeight: 60,
          // ////////////////////////////////////////////////////////////////////
          actions: [
            Row(
              children: [
                IconButton(
                    onPressed: () {
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (context) => const MainPage()));
                    },
                    icon: const Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                      size: 30,
                    )),
                const SizedBox(
                  width: 5,
                ),
                Container(
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                      color: Colors.amber,
                      borderRadius: BorderRadius.circular(30)),
                ),
                const SizedBox(
                  width: 10,
                ),
                Container(
                  color: Colors.transparent,
                  width: MediaQuery.of(context).size.width * 0.3,
                  child: Text(
                    widget.receverName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(
                  width: 50,
                ),
                const Icon(
                  Icons.videocam_rounded,
                  size: 35,
                  color: Colors.white,
                ),
                const SizedBox(
                  width: 20,
                ),
                const Icon(
                  Icons.call,
                  color: Colors.white,
                ),
                const SizedBox(
                  width: 20,
                ),
                const Icon(
                  Icons.more_vert,
                  color: Colors.white,
                )
              ],
            )
          ],
          // title: Padding(
          //   padding: const EdgeInsets.only(left: 20),
          //   child: Text(widget.receverName,
          //       style: const TextStyle(
          //         color: Colors.white,
          //       ),
          //       overflow: TextOverflow.ellipsis),
          // ),
          backgroundColor: const Color(0xff017B6D),
        ),
        body: Column(children: [
          Expanded(child: _chatBilder()),
          SizedBox(
            height: 65,
            child: Row(
              children: [
                Expanded(
                  child: Stack(
                    children: [
                      // IconButton(
                      //     onPressed: () {},
                      //     icon: const Icon(Icons.emoji_emotions_outlined)),
                      Expanded(
                          child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Container(
                              width: 320,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(30)),
                              child: TextField(
                                controller: controller,
                                decoration: const InputDecoration(
                                    hintText: "Message",
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(30)))),
                              ),
                            ),
                          ],
                        ),
                      )),
                      // camera///////////////////////////////////////////////////////////////
                      Align(
                        alignment: const AlignmentDirectional(0.85, 0),
                        child: IconButton(
                            onPressed: () {
                              _pickImage();
                            },
                            icon: const Icon(
                              Icons.photo_camera_outlined,
                            )),
                      ),

                      // attach///////////////////////////////////////////////////////////
                      Align(
                        alignment: const AlignmentDirectional(0.60, 0),
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
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 0, top: 0),
                  child: IconButton(
                      onPressed: () {
                        chatProvider.sendMessage(
                            widget.receiverUserId, controller.text, imageFile);
                        controller.clear();
                      },
                      icon: Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                            color: const Color(0xff017B6D),
                            borderRadius: BorderRadius.circular(25)),
                        child: const Icon(
                          Icons.send_rounded,
                          color: Colors.white,
                        ),
                      )),
                )
              ],
            ),
          )
        ]),
      ),
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
      bool isEmailVisible;
      isEmailVisible =
          data["senderId"] == fireAuth.currentUser!.uid ? false : true;
      return Container(
        padding: const EdgeInsets.all(8),
        alignment: alignment,
        child: Column(
          children: [
            Visibility(
                visible: isEmailVisible, child: Text(data['senderEmail'])),
            InkWell(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => ImageView(
                          image: data['imageUrl'],
                        )));
              },
              child: Container(
                height: 275,
                width: MediaQuery.of(context).size.width * 0.63,
                decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(20)),
                    color: chatColor),
                child: Center(
                  child: Container(
                    height: 260,
                    width: MediaQuery.of(context).size.width * 0.6,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        image: DecorationImage(
                            image: NetworkImage(data['imageUrl']),
                            fit: BoxFit.fitWidth)),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    } else {
      return Container(
        alignment: alignment,
        child: Padding(
          padding:
              const EdgeInsets.only(left: 40, bottom: 5, top: 5, right: 10),
          child: Container(
            // width: MediaQuery.of(context).size.width * .80,
            // height: MediaQuery.of(context).size.height * .1,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5), color: chatColor),
            child: Column(children: [
              // Text(data["senderEmail"]),
              Text(
                data["message"],
                style: const TextStyle(fontSize: 20),
              )
            ]),
          ),
        ),
      );
    }
  }
}
