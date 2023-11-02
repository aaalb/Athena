import 'package:flutter/material.dart';

class LibrettoScreen extends StatefulWidget {
  const LibrettoScreen({super.key});

  @override
  State<LibrettoScreen> createState() => _LibrettoScreenState();
}

class _LibrettoScreenState extends State<LibrettoScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(),
    );
  }
}
