
import 'package:flutter/material.dart';
import 'package:speak_ez/Controllers/global_controller.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: Text("Hi, ${globalController.currentUser.value!.displayName}"),
      ),
    );
  }
}
