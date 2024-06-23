import 'package:flutter/material.dart';

abstract final class MWds {
  static Widget divider([double height = 8]) =>
      Divider(color: Colors.transparent, height: height);

  static Widget vDivider([double width = 8]) =>
      VerticalDivider(color: Colors.transparent, width: width);
}
