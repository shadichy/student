import 'package:flutter/material.dart';
import 'package:student/core/databases/shared_prefs.dart';
// import 'package:student/core/databases/user.dart';
import 'package:student/ui/connect.dart';

class Initializer extends StatelessWidget {
  const Initializer({super.key});

  @override
  Widget build(BuildContext context) {
    SharedPrefs.setString(
      "user",
      '{"id":"A47548","name":"Sadashi Ken Ichi","group":2,"semester":1,"schoolYear":36,"passed":[],"learning":[]}',
    ).then((_) => StudentApp.action(context, AppAction.init));
    return const Scaffold();
  }
}
