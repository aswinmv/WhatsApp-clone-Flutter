import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:whatsapp/provider/fireservice.dart';

import 'package:whatsapp/util/registration.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController email = TextEditingController();
  TextEditingController pass = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final authServices = Provider.of<FireService>(context);

    return Scaffold(
      backgroundColor: Colors.green.shade400,
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 170,
              width: double.infinity,
              child: Center(
                  child: Text(
                "Login Page",
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.w500),
              )),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  color: Colors.grey[300],
                ),
                height: MediaQuery.of(context).size.height * .4,
                width: MediaQuery.of(context).size.width,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: SizedBox(
                        height: 60,
                        width: MediaQuery.of(context).size.width * 0.9,
                        child: TextField(
                          decoration: const InputDecoration(
                              border: OutlineInputBorder(), hintText: "Email"),
                          controller: email,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: SizedBox(
                        height: 60,
                        width: MediaQuery.of(context).size.width * 0.9,
                        child: TextField(
                          decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: "Password"),
                          controller: pass,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const RegisPage(),
                        ));
                      },
                      child: const Text("Register"),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        authServices.loginUser(email.text, pass.text);
                        // Navigator.of(context).push(MaterialPageRoute(
                        //   builder: (context) => const MainPage(),
                        // ));
                      },
                      child: const Text("Login"),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
