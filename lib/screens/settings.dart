import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:whatsapp/screens/mainpage.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsState();
}

class _SettingsState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color(0xff017B6B),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => const MainPage()));
            },
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
          ),
          const SizedBox(
            width: 5,
          ),
          const Text(
            "Settings",
            style: TextStyle(color: Colors.white, fontSize: 25),
          ),
          const SizedBox(
            width: 230,
          ),
          const Icon(
            Icons.search,
            color: Colors.white,
          ),
          const SizedBox(
            width: 10,
          )
        ],
      ),
      body: Column(children: [
        Row(
          children: [
            SizedBox(
              height: 70,
              width: MediaQuery.of(context).size.width,
              child: ListView.builder(
                  itemCount: 1,
                  itemBuilder: (context, index) {
                    return ListTile(
                      leading: Container(
                        height: 55,
                        width: 55,
                        decoration: BoxDecoration(
                            color: Colors.deepPurple,
                            borderRadius: BorderRadius.circular(55)),
                      ),
                      title: const Text("Name"),
                      subtitle: const Text("status"),
                      trailing: const Icon(
                        Icons.qr_code_2,
                        size: 30,
                        color: Colors.green,
                      ),
                    );
                  }),
            )
          ],
        ),
        const Divider(),
      ]),
    );
  }
}
