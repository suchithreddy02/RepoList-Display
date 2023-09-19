import 'package:flutter/material.dart';
import 'package:flutter_app/home.dart';
import "package:flutter_dotenv/flutter_dotenv.dart";

void main() async {

  await  dotenv.load(fileName: ".env");
 runApp( MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
        title: 'Github Search',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.deepPurple,
        ),
        home: Home());
  }
}