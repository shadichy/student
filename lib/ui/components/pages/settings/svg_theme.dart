import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

String colorCode(Color color) => color.value.toRadixString(16).substring(2, 8);

class SvgIcon extends StatelessWidget {
  final Color primary, container, tertiary;
  final double size;
  const SvgIcon({
    super.key,
    required this.primary,
    required this.container,
    required this.tertiary,
    this.size = 32,
  });

  @override
  Widget build(BuildContext context) {
    return SvgPicture.string(
      '<svg viewBox="0 0 24 24"><path d="M0 12A12 12 0 0112 0a12 12 0 0112 12H12z" fill="#${colorCode(container)}"/><path d="M12 24a12 12 0 01-8.485-3.515A12 12 0 010 12h12z" fill="#${colorCode(tertiary)}"/><path d="M24 12a12 12 0 01-12 12V12z" fill="#${colorCode(primary)}"/></svg>',
      width: size,
      height: size,
    );
  }
}
