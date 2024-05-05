import 'package:flutter/material.dart';
import 'package:student/ui/components/option.dart';

class SectionLabel extends StatelessWidget {
  final String label;
  final Option? option;
  final FontWeight? fontWeight;
  final TextStyle? textStyle;
  final Color? color;
  final Color? backgroundColor;
  const SectionLabel(
    this.label,
    this.option, {
    super.key,
    this.textStyle,
    this.fontWeight,
    this.color,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    Color fColor = color ?? Colors.transparent;
    Color fBackgroundColor = backgroundColor ?? Colors.transparent;

    return Padding(
      padding: const EdgeInsets.only(
        left: 16,
        right: 16,
        top: 16,
        bottom: 8,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          Text(
            label,
            // textAlign: TextAlign.start,
            // overflow: TextOverflow.clip,
            style: textStyle?.copyWith(
              fontWeight: fontWeight,
              // fontStyle: FontStyle.normal,
              // fontSize: fontSize,
              color: fColor,
            ),
          ),
          if (option is Option)
            IconOption(
              option!,
              backgroundColor: fBackgroundColor,
              iconColor: fColor,
              iconSize: 28,
              // padding: const EdgeInsets.all(8),
            ),
        ],
      ),
    );
  }
}
