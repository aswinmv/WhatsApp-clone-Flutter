import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:whatsapp/provider/fireservice.dart';

import 'chatpage.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    final authServices = Provider.of<FireService>(context);
    return DefaultTabController(
      length: 10,
      child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.amber,
            actions: [
              IconButton(
                icon: const Icon(Icons.login_outlined),
                onPressed: () {
                  authServices.signOut();
                },
                color: Colors.white,
              )
            ],
          ),
          body: _userList()),
    );
  }

//list view
  Widget _userList() {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection("Users").snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Text("Error");
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else {
          return ListView(
            children:
                snapshot.data!.docs.map((docs) => _userItem(docs)).toList(),
          );
        }
      },
    );
  }

//list item
  Widget _userItem(DocumentSnapshot document) {
    Map<String, dynamic> data = document.data() as Map<String, dynamic>;

    if (FirebaseAuth.instance.currentUser!.email != data["email"]) {
      return ListTile(
        leading: Container(
          height: 60,
          width: 60,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(35)),
            color: Colors.amber,
          ),
        ),
        title: InkWell(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => ChatPage(
                  receiverUserId: data["uid"],
                  receiverUserEmail: data["email"],
                ),
              ));
            },
            child: Text(
              data["email"],
            )),
        subtitle: Text("Last Message"),
        trailing: const Icon(Icons.notifications_none_rounded),
      );
    } else {
      return Container(
        color: Colors.amber,
      );
    }
  }
}
