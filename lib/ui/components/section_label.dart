import 'package:flutter/material.dart';
import 'package:student/ui/components/option.dart';

class SectionLabel extends StatelessWidget {
  final String label;
  final Widget? icon;
  final void Function()? target;
  final String? route;
  final FontWeight? fontWeight;
  final TextStyle? textStyle;
  final Color? color;
  final Color? backgroundColor;
  const SectionLabel(
    this.label, {
    this.route,
    this.icon,
    this.target,
    super.key,
    this.textStyle,
    this.fontWeight,
    this.color,
    this.backgroundColor,
  }) : assert(
            (icon == null && target == null) ||
                (icon != null && target != null),
            'missing target for icon');

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
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
              color: color,
            ),
          ),
          if (route != null)
            IconOption(
              route!,
              backgroundColor: backgroundColor,
              color: color,
              iconSize: 28,
            ),
          if (icon is Icon)
            IconButton(
              icon: icon!,
              onPressed: target,
              style: IconButton.styleFrom(
                backgroundColor: backgroundColor,
              ),
              color: color,
              iconSize: 28,
              // padding: const EdgeInsets.all(8),
            ),
        ],
      ),
    );
  }
}
