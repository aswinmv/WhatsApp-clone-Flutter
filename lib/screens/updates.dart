import 'package:flutter/material.dart';

class UpdatePage extends StatefulWidget {
  const UpdatePage({super.key});

  @override
  State<UpdatePage> createState() => _UpdatePageState();
}

class _UpdatePageState extends State<UpdatePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(children: [
        const Align(
          alignment: Alignment.topLeft,
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              "Status",
              style: TextStyle(fontSize: 23, fontWeight: FontWeight.w500),
            ),
          ),
        ),
        const SizedBox(
          height: 15,
        ),
        SingleChildScrollView(
          child: Row(
            children: [
              const SizedBox(
                width: 15,
              ),
              // my status////////////////////////////////////////////////////////////////////////////////////////////////////
              Column(
                children: [
                  Container(
                    height: 60,
                    width: 60,
                    decoration: BoxDecoration(
                        color: Colors.amber,
                        borderRadius: BorderRadius.circular(35)),
                  ),
                  const Text("My Status")
                ],
              ),
              SizedBox(
                height: 80,
                width: 330,
                child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: 10,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(left: 15),
                        child: Column(
                          children: [
                            Container(
                              height: 60,
                              width: 60,
                              decoration: BoxDecoration(
                                  color: Colors.amber,
                                  borderRadius: BorderRadius.circular(35)),
                            ),
                            const Text(
                              "My Status",
                              overflow: TextOverflow.ellipsis,
                            )
                          ],
                        ),
                      );
                    }),
              )
            ],
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        const Divider(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                "Channels",
                style: TextStyle(fontSize: 23, fontWeight: FontWeight.w500),
              ),
            ),
            IconButton(onPressed: () {}, icon: Icon(Icons.add))
          ],
        ),
      ]),
    );
  }
}

class Calls extends StatelessWidget {
  const Calls({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.deepOrange,
    );
  }
}
