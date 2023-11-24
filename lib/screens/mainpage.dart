import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:whatsapp/provider/fireservice.dart';
import 'package:whatsapp/screens/settings.dart';
import 'package:whatsapp/screens/updates.dart';
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
      initialIndex: 1,
      length: 10,
      child: Scaffold(
          backgroundColor: Colors.white,
          floatingActionButton: FloatingActionButton(
            onPressed: () {},
            backgroundColor: const Color(0xff017B6B),
            child: Transform.rotate(
              angle: 135.1,
              child: const Icon(
                Icons.message_rounded,
                color: Colors.white,
              ),
            ),
          ),
          appBar: AppBar(
            toolbarHeight: 85,
            title: const Text(
              "WhatsApp",
              style: TextStyle(color: Colors.white),
            ),
            automaticallyImplyLeading: false,
            bottom: const TabBar(tabs: [
              Tab(
                  child: Icon(
                Icons.groups_2,
                color: Colors.grey,
              )),
              Tab(
                  child: Text(
                "Chats",
                style: TextStyle(color: Colors.white, fontSize: 18),
              )),
              Tab(
                  child: Text(
                "Updates",
                style: TextStyle(color: Colors.white, fontSize: 18),
              )),
              Tab(
                  child: Text(
                "Calls",
                style: TextStyle(color: Colors.white, fontSize: 18),
              ))
            ]),
            backgroundColor: const Color(0xff017B6B),
            actions: [
              IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.camera_alt_outlined,
                    color: Colors.white,
                  )),
              IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.search,
                    color: Colors.white,
                  )),
              // popup menu button ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
              PopupMenuButton(
                iconColor: Colors.white,
                iconSize: 28,
                color: Colors.white,
                onSelected: (value) {
                  // your logic
                },
                itemBuilder: (BuildContext bc) {
                  return [
                    PopupMenuItem(
                      // value: '/Settings',
                      child: TextButton(
                          onPressed: () {}, child: const Text("New group")),
                    ),
                    PopupMenuItem(
                      // value: '/Logout',
                      child: TextButton(
                          onPressed: () {
                            authServices.signOut();
                          },
                          child: const Text("Logout/boadcast")),
                    ),
                    PopupMenuItem(
                      // value: '/Settings',
                      child: TextButton(
                          onPressed: () {},
                          child: const Text("Linked devices")),
                    ),
                    PopupMenuItem(
                      // value: '/Settings',
                      child: TextButton(
                          onPressed: () {},
                          child: const Text("Starred messages")),
                    ),
                    PopupMenuItem(
                      // value: '/Settings',
                      child: TextButton(
                          onPressed: () {}, child: const Text("Payments")),
                    ),
                    PopupMenuItem(
                      // value: '/Settings',
                      child: TextButton(
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => const SettingsPage()));
                          },
                          child: const Text("Settings")),
                    ),
                  ];
                },
              ),
            ],
          ),
          body: TabBarView(
            children: [
              const Icon(
                Icons.whatshot_sharp,
                size: 155,
              ),
              _userList(),
              const UpdatePage(),
              const Calls()
            ],
          )),
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
            borderRadius: BorderRadius.all(Radius.circular(40)),
            color: Colors.deepPurple,
          ),
        ),
        title: InkWell(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => ChatPage(
                  receiverUserId: data["uid"],
                  receiverUserEmail: data["email"],
                  receverName: data["name"],
                ),
              ));
            },
            child: Text(
              data["email"],
            )),
        subtitle: const Text("Last Message"),
        trailing: const Icon(Icons.notifications_none_rounded),
      );
    } else {
      return Container(
        color: Colors.amber,
      );
    }
  }
}
