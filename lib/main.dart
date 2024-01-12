import 'package:flutter/material.dart';
import 'package:rbac/screens/profile_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Company Builder',
      // Compare this snippet from lib/profile_page.dart:
      // home: const profile_page(),
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
        primaryColor: Colors.blue,
      ),
      home: profile_page(),
    );
  }
}
