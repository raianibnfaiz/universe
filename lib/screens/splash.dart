import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SplashSreen extends StatelessWidget {
  const SplashSreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Splash Screen'),
      ),
      body: Center(
        child: Text(
          'Splash Screen',
          style: Theme.of(context).textTheme.headline4,
        ),
      ),
    );
  }
}
