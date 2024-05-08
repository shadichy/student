import 'package:flutter/material.dart';

abstract interface class TypicalPage extends Widget {
  const TypicalPage({super.key});

  @factory
  Icon get icon;

  @factory
  String get title;
}
