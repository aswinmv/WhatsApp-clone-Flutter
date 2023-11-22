import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:whatsapp/provider/fireservice.dart';
import 'package:whatsapp/util/loginpage.dart';

class RegisPage extends StatefulWidget {
  const RegisPage({super.key});

  @override
  State<RegisPage> createState() => _RegisPageState();
}

class _RegisPageState extends State<RegisPage> {
  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController pass = TextEditingController();
  var formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final authServices = Provider.of<FireService>(context, listen: true);

    return Scaffold(
      backgroundColor: Colors.green.shade300,
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 170,
              width: double.infinity,
              child: Center(
                  child: Text(
                "Register",
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.w500),
              )),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(30)),
                  color: Colors.grey[300],
                ),
                height: MediaQuery.of(context).size.height * .6,
                width: MediaQuery.of(context).size.width,
                child: Form(
                  key: formkey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: SizedBox(
                          height: 80,
                          width: MediaQuery.of(context).size.width * 0.9,
                          child: TextFormField(
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "field can't be empty";
                              }
                              return null;
                            },
                            decoration: const InputDecoration(
                                border: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20))),
                                hintText: "Name"),
                            controller: name,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: SizedBox(
                          height: 80,
                          width: MediaQuery.of(context).size.width * 0.9,
                          child: TextFormField(
                            validator: (value) {
                              if (value!.isEmpty ||
                                  !RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                      .hasMatch(value)) {
                                return 'Enter a valid email!';
                              }
                              return null;
                            },
                            decoration: const InputDecoration(
                                border: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20))),
                                hintText: "Email"),
                            controller: email,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: SizedBox(
                          height: 80,
                          width: MediaQuery.of(context).size.width * 0.9,
                          child: TextFormField(
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Password is required";
                              }
                              // Perform custom password validation here
                              if (value.length < 8) {
                                return "Password must be at least 8 characters long";
                              }
                              if (!value.contains(RegExp(r'[A-Z]'))) {
                                return "Password must contain at least one uppercase letter";
                              }
                              if (!value.contains(RegExp(r'[a-z]'))) {
                                return "Password must contain at least one lowercase letter";
                              }
                              if (!value.contains(RegExp(r'[0-9]'))) {
                                return "Password must contain at least one numeric character";
                              }
                              if (!value.contains(
                                  RegExp(r'[!@#\$%^&*()<>?/|}{~:]'))) {
                                return "Password must contain at least one special character";
                              }

                              return null; // Password is valid
                            },
                            decoration: const InputDecoration(
                                border: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20))),
                                hintText: "Password"),
                            controller: pass,
                          ),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          bool isValid = formkey.currentState!.validate();
                          if (isValid) {
                            authServices.registerUser(
                                email.text, pass.text, name.text);
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => const LoginPage(),
                            ));
                          } else {
                            if (kDebugMode) {
                              print("error");
                            }
                          }
                        },
                        child: const Text("Register"),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context)
                              .pushReplacement(MaterialPageRoute(
                            builder: (context) => const LoginPage(),
                          ));
                        },
                        child: const Text("Go to Login"),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
