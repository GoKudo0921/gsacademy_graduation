import 'package:flutter/material.dart';

class PerformancePage extends StatefulWidget {
  const PerformancePage({super.key});

  @override
  State<PerformancePage> createState() => _PerformancePageState();
}

class _PerformancePageState extends State<PerformancePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('演出の紹介'),
      ),
      body: const Center(child: Text('ここはv2で開発予定',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),)),
    );
  }
}
