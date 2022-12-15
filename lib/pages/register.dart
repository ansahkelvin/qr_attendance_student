import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gctu_students/pages/login.dart';
import 'package:provider/provider.dart';

import '../provider/firebaese_provider.dart';
import 'home.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});
  static const String routeName = "/register";

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final nameController = TextEditingController();
  final indexController = TextEditingController();
  final levelController = TextEditingController();
  bool isLoading = false;

  Future<void> signup() async {
    try {
      setState(() {
        isLoading = true;
      });
      await Provider.of<FirebaseProvider>(context, listen: false).signup(
        email: emailController.text,
        password: passwordController.text,
        name: nameController.text,
        indexNum: indexController.text,
        level: levelController.text,
      );
      if (!mounted) return;
      setState(() {
        isLoading = false;
      });
      Navigator.of(context).pushReplacementNamed(
        HomePage.routeName,
      );
    } on FirebaseAuthException catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.message!),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 16),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const SizedBox(
              height: 18,
            ),
            const Text(
              "Welcome,",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 10,
            ),
            const Text(
              "Enter your credentials to proceed",
              style: TextStyle(color: Colors.black),
            ),
            const SizedBox(
              height: 20,
            ),
            TextFormField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: "Full name",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            TextFormField(
              controller: emailController,
              decoration: const InputDecoration(
                labelText: "Email",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            TextFormField(
              controller: passwordController,
              decoration: const InputDecoration(
                labelText: "Password",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            TextFormField(
              controller: indexController,
              decoration: const InputDecoration(
                labelText: "Index number",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            TextFormField(
              controller: levelController,
              decoration: const InputDecoration(
                labelText: "Level",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                minimumSize: Size(
                  MediaQuery.of(context).size.width,
                  50,
                ),
              ),
              onPressed: signup,
              child: Text(
                isLoading ? "Registering user..." : "Register",
                style: const TextStyle(color: Colors.white),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            TextButton(
              style: TextButton.styleFrom(
                  foregroundColor: const Color(0xff174123)),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const LoginPage(),
                  ),
                );
              },
              child: const Text("Already having an account ? Sign in"),
            )
          ]),
        ),
      ),
    );
  }
}
