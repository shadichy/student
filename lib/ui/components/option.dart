import 'package:flutter/material.dart';

class Option {
  final IconData icon;
  final String label;
  final void Function()? target;
  Option(this.icon, this.label, this.target);
}

class TextOption extends StatefulWidget {
  final Option id;
  final Color? color;
  final Color? backgroundColor;
  final double iconSize;
  final double fontSize;
  final FontWeight? fontWeight;
  final TextAlign? textAlign;
  final EdgeInsetsGeometry margin;
  final EdgeInsetsGeometry? padding;
  final BorderRadiusGeometry borderRadius;
  final bool? dense;
  final Widget? subtitle;
  final Widget? trailing;

  const TextOption(
    this.id, {
    super.key,
    this.color,
    this.backgroundColor,
    this.iconSize = 32,
    this.fontSize = 16,
    this.fontWeight,
    this.textAlign,
    this.margin = EdgeInsets.zero,
    this.padding,
    this.borderRadius = BorderRadius.zero,
    this.dense,
    this.subtitle,
    this.trailing,
  });

  @override
  State<TextOption> createState() => _TextOptionState();
}

class _TextOptionState extends State<TextOption> {
  @override
  Widget build(BuildContext context) {
    // ColorScheme colorScheme = Theme.of(context).colorScheme;
    // Widget optionWidget = ElevatedButton(
    //   onPressed: widget.id.target,
    //   style: ElevatedButton.styleFrom(
    //     padding: widget.padding,
    //     shape: (widget.borderRadius == BorderRadius.zero)
    //         ? null
    //         : RoundedRectangleBorder(borderRadius: widget.borderRadius),
    //     backgroundColor: widget.iconBackground,
    //     elevation: 0,
    //   ),
    //   child: Icon(
    //     widget.id.icon,
    //     color: widget.iconColor,
    //     size: widget.iconSize,
    //   ),
    // );
    Widget optionWidget = ListTile(
      onTap: widget.id.target,
      contentPadding: widget.padding,
      shape: (widget.borderRadius == BorderRadius.zero)
          ? null
          : RoundedRectangleBorder(borderRadius: widget.borderRadius),
      title: Text(
        widget.id.label,
        textAlign: widget.textAlign,
        // overflow: TextOverflow.ellipsis,
        style: TextStyle(
          fontWeight: widget.fontWeight,
          fontSize: 16,
          color: widget.color,
        ),
      ),
      leading: Icon(
        widget.id.icon,
        color: widget.color,
        size: widget.iconSize,
      ),
      trailing: widget.trailing,
      subtitle: widget.subtitle,
      tileColor: widget.backgroundColor,
      dense: widget.dense,
    );
    return (widget.margin == EdgeInsets.zero)
        ? optionWidget
        : Padding(padding: widget.margin, child: optionWidget);
  }
}

class IconOption extends StatefulWidget {
  final Option id;
  final Color? iconColor;
  final Color? backgroundColor;
  final double iconSize;
  final EdgeInsetsGeometry margin;
  final EdgeInsetsGeometry? padding;

  const IconOption(
    this.id, {
    super.key,
    this.iconColor,
    this.backgroundColor,
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
    Widget optionWidget = ElevatedButton(
      onPressed: widget.id.target,
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.all(8),
        shape: const CircleBorder(),
        backgroundColor: widget.backgroundColor,
        elevation: 0,
        // tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      child: Padding(
        padding: widget.padding ?? EdgeInsets.zero,
        child: Icon(
          widget.id.icon,
          color: widget.iconColor,
          size: widget.iconSize,
        ),
      ),
    );
    // Widget optionWidget =
    return (widget.margin == EdgeInsets.zero)
        ? optionWidget
        : Padding(padding: widget.margin, child: optionWidget);
  }
}
