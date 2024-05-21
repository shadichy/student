import 'package:flutter/material.dart';

class FillForm extends StatelessWidget {
  const FillForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Fill your info"),
      ),
      body: Form(child: Column(children: [
        TextFormField(),
        TextFormField(),
        TextFormField(),
        TextFormField(),
      ])),
    );
  }
}
