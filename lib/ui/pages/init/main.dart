import 'package:flutter/material.dart';
import 'package:student/core/databases/shared_prefs.dart';
import 'package:student/core/databases/user.dart';

class Initializer extends StatelessWidget {
  const Initializer({super.key});

  @override
  Widget build(BuildContext context) {
    SharedPrefs.setString("user", "").then((_) => User.initialize());
    return Scaffold();
  }
}
