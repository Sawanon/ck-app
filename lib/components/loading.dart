import 'package:flutter/material.dart';

class LoadingPage extends StatelessWidget {
  const LoadingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white.withOpacity(0.4),
      child: const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
