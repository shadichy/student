import 'package:flutter/material.dart';

class Option {
  final IconData icon;
  final void Function()? target;
  Option(this.icon, this.target);
}

class TextOption {}

class IconOption extends StatefulWidget {

  final Option id;
  final Color? iconColor;
  final Color? iconBackground;
  final double iconSize;
  final EdgeInsetsGeometry margin;
  final EdgeInsetsGeometry? padding;

  const IconOption(
    this.id, {
    super.key,
    this.iconColor,
    this.iconBackground,
    this.iconSize = 32,
    this.margin = EdgeInsets.zero,
    this.padding,
  });

  @override
  State<IconOption> createState() => _IconOptionState();
}

class _IconOptionState extends State<IconOption> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: widget.margin,
      child: ElevatedButton(
        onPressed: widget.id.target,
        style: ElevatedButton.styleFrom(
          padding: widget.padding,
          shape: const CircleBorder(),
          backgroundColor: widget.iconBackground,
          elevation: 0,
          // tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
        child: Icon(
          widget.id.icon,
          color: widget.iconColor,
          size: widget.iconSize,
        ),
      ),
    );
  }
}
