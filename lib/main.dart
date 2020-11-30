import 'package:flutter/material.dart';
import './ui/scan.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'AAPG Voting',
        theme: ThemeData(
            primaryColor: new Color(0xFF8B1122),
            primarySwatch: Colors.red
        ),
        home: HomePage()
    );
  }
}
