import 'package:flutter/material.dart';
import 'package:snake_game/main_body.dart';

void main() {
  runApp( HomePage());
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MainBody(),
      theme: ThemeData(brightness: Brightness.dark),
    );
  }
}
