import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:gctu_students/pages/home.dart';
import 'package:gctu_students/pages/login.dart';
import 'package:gctu_students/pages/scan.dart';
import 'package:gctu_students/provider/firebaese_provider.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: ((context) => FirebaseProvider()))
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: theme(context),
        home: const LoginPage(),
        routes: {
          HomePage.routeName: (BuildContext context) => const HomePage(),
          LoginPage.routeName: (BuildContext context) => const LoginPage(),
        },
      ),
    );
  }

  ThemeData theme(BuildContext context) {
    return ThemeData(
      appBarTheme: AppBarTheme(
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        iconTheme: const IconThemeData(color: Colors.black),
        actionsIconTheme: const IconThemeData(color: Colors.black),
        titleTextStyle: const TextStyle(
          color: Colors.black,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
