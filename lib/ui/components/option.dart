import 'package:flutter/material.dart';
import 'package:student/ui/components/navigator/navigator.dart';
import 'package:student/ui/components/options.dart';

class Option {
  // Move to option id instead, label goes for translation
  final String id;
  final Widget icon;
  final void Function(BuildContext context) target;
  Option(this.id, this.icon, this.target);
  Option.from(this.id, TypicalPage page)
      : icon = page.icon,
        target = ((context) {});
}

class TextOption extends StatefulWidget {
  final Option option;
  final String? label;
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

  TextOption(
    this.option, {
    super.key,
    this.label,
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
  }) : assert(!funcOptionDictionary.contains(option.id) || label != null,
            'Missing label for generic type option.');

  @override
  State<TextOption> createState() => _TextOptionState();
}

class _TextOptionState extends State<TextOption> {
  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    Widget optionIcon = widget.option.icon is Icon
        ? Icon(
            (widget.option.icon as Icon).icon,
            color: widget.color,
            size: widget.iconSize,
          )
        : widget.option.icon is ImageIcon
            ? ImageIcon(
                (widget.option.icon as ImageIcon).image,
                color: widget.color,
                size: widget.iconSize,
              )
            : widget.option.icon;

    Widget optionWidget = ListTile(
      onTap: () => widget.option.target(context),
      contentPadding: widget.padding,
      shape: (widget.borderRadius == BorderRadius.zero)
          ? null
          : RoundedRectangleBorder(borderRadius: widget.borderRadius),
      title: Text(
        widget.label ?? optionDictionary[widget.option.id]!,
        textAlign: widget.textAlign,
        // overflow: TextOverflow.ellipsis,
        style: textTheme.titleMedium?.copyWith(
          fontWeight: widget.fontWeight,
          color: widget.color,
        ),
      ),
      leading: optionIcon,
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
  final Option option;
  final double iconSize;
  final double? splashRadius;
  final Color? iconColor;
  final Color? backgroundColor;
  final EdgeInsetsGeometry margin;
  final EdgeInsetsGeometry? padding;

  const IconOption(
    this.option, {
    super.key,
    this.iconColor,
    this.backgroundColor,
    this.iconSize = 32,
    this.margin = EdgeInsets.zero,
    this.padding,
    this.splashRadius,
  });

  @override
  State<IconOption> createState() => _IconOptionState();
}

class _IconOptionState extends State<IconOption> {
  @override
  Widget build(BuildContext context) {
    Widget optionIcon = widget.option.icon is Icon
        ? Icon(
            (widget.option.icon as Icon).icon,
            color: widget.iconColor,
            size: widget.iconSize,
          )
        : widget.option.icon is ImageIcon
            ? ImageIcon(
                (widget.option.icon as ImageIcon).image,
                color: widget.iconColor,
                size: widget.iconSize,
              )
            : widget.option.icon;
    Widget optionWidget = IconButton(
      iconSize: widget.iconSize,
      color: widget.iconColor,
      onPressed: () => widget.option.target(context),
      padding: widget.padding,
      // color: widget.backgroundColor
      style: IconButton.styleFrom(
        backgroundColor: widget.backgroundColor,
        // shape: const CircleBorder(),
        // elevation: 0,
        // tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      icon: optionIcon,
      splashRadius: widget.splashRadius,
    );
    // Widget optionWidget =
    return (widget.margin == EdgeInsets.zero)
        ? optionWidget
        : Padding(padding: widget.margin, child: optionWidget);
  }
}
