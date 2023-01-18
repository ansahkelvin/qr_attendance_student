import 'package:flutter/material.dart';
import 'package:gctu_students/model/Class.dart';
import 'package:gctu_students/pages/scan.dart';

class RoomDetails extends StatefulWidget {
  const RoomDetails({super.key, required this.classModel});
  final ClassModel classModel;

  @override
  State<RoomDetails> createState() => _RoomDetailsState();
}

class _RoomDetailsState extends State<RoomDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.classModel.courseTitle),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.classModel.courseTitle,
                style: const TextStyle(
                  fontSize: 18,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                widget.classModel.roomNumber,
                style: const TextStyle(
                  fontSize: 18,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                widget.classModel.date,
                style: const TextStyle(
                  fontSize: 18,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                widget.classModel.courseId,
                style: const TextStyle(
                  fontSize: 18,
                ),
              ),
              const SizedBox(
                height: 50,
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    minimumSize: Size(MediaQuery.of(context).size.width, 50)),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const Scan(),
                    ),
                  );
                },
                child: const Text("Scan for attendance"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
