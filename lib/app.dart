import 'package:flutter/material.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('BlurHash'),
      ),
      body: Container(
        alignment: Alignment.center,
        child: const Text(
          'Hello World, BlurHash Minimal Code Example!',
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
