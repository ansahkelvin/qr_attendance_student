import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:gctu_students/pages/login.dart';
import 'package:gctu_students/pages/room_details.dart';
import 'package:gctu_students/provider/firebaese_provider.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  static const String routeName = "/home";
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final codeController = TextEditingController();
  final roomController = TextEditingController();

  @override
  void initState() {
    Provider.of<FirebaseProvider>(context, listen: false).getUserData();
    super.initState();
  }

  Future attend() async {
    try {
      final provider = Provider.of<FirebaseProvider>(context, listen: false);
      await provider.attendClass(codeController.text, roomController.text);
      final model = provider.classes;
      if (!mounted) return;
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => RoomDetails(classModel: model[0]),
        ),
      );
    } on FirebaseException catch (e) {
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
      appBar: AppBar(
        title: const Text("Attendance"),
        actions: [
          IconButton(
              onPressed: () {
                FirebaseAuth.instance.signOut();
                Navigator.of(context).pushReplacementNamed(LoginPage.routeName);
              },
              icon: const Icon(Icons.logout))
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                height: 200,
              ),
              TextFormField(
                controller: codeController,
                decoration: const InputDecoration(
                  labelText: "Course Code",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(
                height: 50,
              ),
              TextFormField(
                controller: roomController,
                decoration: const InputDecoration(
                  labelText: "Room Number",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(
                height: 50,
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    minimumSize: Size(MediaQuery.of(context).size.width, 50)),
                onPressed: attend,
                child: const Text("Go to Room"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
