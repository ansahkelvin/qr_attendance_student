import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gctu_students/model/Class.dart';
import 'package:intl/intl.dart';

class FirebaseProvider with ChangeNotifier {
  String? name;
  String? email;
  String? indexNo;
  String? level;
  List<ClassModel> classes = [];

  final firebase = FirebaseAuth.instance;
  final firestore = FirebaseFirestore.instance;
  final currentUser = FirebaseAuth.instance.currentUser;
  get firebaseUser => firebase.authStateChanges();
  ClassModel classModel = ClassModel(
      date: "",
      courseTitle: "",
      courseId: "",
      docId: "",
      roomNumber: "",
      secretKey: "",
      time: "",
      userId: "");

  get username => name;
  get useremail => email;
  get userIndex => indexNo;
  get userLevel => level;

  Future<void> signInUser(
      {required String email, required String password}) async {
    await firebase.signInWithEmailAndPassword(email: email, password: password);
    notifyListeners();
  }

  Future<void> signup(
      {required String email,
      required String password,
      required String indexNum,
      required String level,
      required String name}) async {
    final user = await firebase.createUserWithEmailAndPassword(
        email: email, password: password);

    firestore
        .doc("students/${user.user!.uid}")
        .set({"name": name, "email": email, "index": indexNum, "level": level});
    notifyListeners();
  }

  Future<void> takeAttendance({required String docId}) async {
    await firestore.doc("class/$docId/attendance/${currentUser!.uid}").set({
      "docId": docId,
      "name": name,
      "index": indexNo,
      "time": DateFormat.j().format(DateTime.now()),
    });

    notifyListeners();
  }

  Future<void> getUserData() async {
    final snapshot = await firestore
        .doc("students/${FirebaseAuth.instance.currentUser!.uid}")
        .get();
    final data = snapshot.data() as Map<String, dynamic>;
    name = data["name"];
    email = data["email"];
    indexNo = data["index"];
    level = data["level"];
    notifyListeners();
  }

  Future<ClassModel> attendClass(String courseId, String roomNumber) async {
    final snapshots = await firestore
        .collection("class")
        .where("courseId", isEqualTo: courseId)
        .where("roomNumber", isEqualTo: roomNumber)
        .limit(1)
        .get();

    final data = snapshots.docs
        .map((doc) => ClassModel(
              date: doc.data()["date"],
              courseTitle: doc.data()["courseTitle"],
              courseId: doc.data()["courseId"],
              docId: doc.id,
              roomNumber: doc.data()["roomNumber"],
              secretKey: doc.data()["secretKey"],
              time: doc.data()["time"],
              userId: doc.data()["userId"],
            ))
        .toList();
    classes = data;
    notifyListeners();

    return classModel;
  }
}
