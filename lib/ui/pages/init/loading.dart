import 'dart:async';

import 'package:flutter/material.dart';
import 'package:student/misc/misc_widget.dart';

class Loading extends StatefulWidget {
  const Loading({super.key});

  @override
  State<Loading> createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  double _opacity = 0;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 10), () => _opacity = 1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(16),
        alignment: Alignment.center,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(
              width: 100,
              height: 100,
              child: CircularProgressIndicator(),
            ),
            MWds.divider(16),
            AnimatedOpacity(
              opacity: _opacity,
              duration: const Duration(milliseconds: 300),
              child: const Text(
                "First initialization requires network connection.\nPlease connect to wifi or mobile data to continue.",
                maxLines: 2,
              ),
            )
          ],
        ),
      ),
    );
  }
}
