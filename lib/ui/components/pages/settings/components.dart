import 'package:flutter/material.dart';
import 'package:student/ui/components/options.dart';

enum ButtonType { page, select, switcher }

enum SwitcherType { basic, extended }

class SubPage extends StatelessWidget {
  final String label;
  final String? desc;
  final Widget? target;
  final void Function(BuildContext context)? action;
  final Widget? icon;
  const SubPage({
    super.key,
    required this.label,
    this.desc,
    this.target,
    this.action,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    Widget mainText = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(label, style: textTheme.titleLarge),
        if (desc is String) Text(desc!, style: textTheme.titleSmall)
      ],
    );
    Widget content = Container(
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 4,
      ),
      height: 64,
      child: icon != null
          ? Row(children: [
              Padding(
                padding: const EdgeInsets.only(right: 16),
                child: icon,
              ),
              mainText
            ])
          : mainText,
    );
    return (target != null || action != null)
        ? InkWell(
            onTap: () {
              target != null
                  ? Options.goto(context, target!)
                  : action!(context);
            },
            child: content,
          )
        : content;
  }
}

class Opt extends StatefulWidget {
  final ButtonType buttonType;
  final SwitcherType switcherType;
  final void Function(bool newValue)? switcherAction;
  final bool? switcherDefaultValue;
  final bool disabled;

  final String label;
  final String? desc;
  final Widget? target;
  final void Function(BuildContext context)? action;
  final Widget? icon;

  const Opt({
    required this.label,
    this.desc,
    required this.buttonType,
    this.switcherType = SwitcherType.basic,
    this.disabled = false,
    this.target,
    this.switcherAction,
    this.action,
    this.switcherDefaultValue,
    this.icon,
    super.key,
  })  : assert(buttonType != ButtonType.page || target != null,
            'Page button must have a target destination.'),
        assert(buttonType != ButtonType.select || action != null,
            'Selector button must have an action.'),
        assert(
            buttonType != ButtonType.switcher || switcherDefaultValue != null,
            'Switcher must have default value'),
        assert(buttonType != ButtonType.switcher || switcherAction != null,
            'Switcher must have an switching action.'),
        assert(
            buttonType != ButtonType.switcher ||
                switcherType != SwitcherType.extended ||
                action != null ||
                target != null,
            'Extended switcher must have either an action or a target.');

  @override
  State<Opt> createState() => _OptState();
}

class _OptState extends State<Opt> {
  late bool? switcherDefaultValue = widget.switcherDefaultValue;

  void switcherChangeState(bool newState) {
    setState(() {
      switcherDefaultValue = newState;
    });
    widget.switcherAction!(newState);
  }

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    TextTheme textTheme = Theme.of(context).textTheme;
    textTheme = widget.disabled
        ? textTheme.apply(bodyColor: colorScheme.onSurface.withOpacity(0.38))
        : textTheme;

    Widget mainTexts = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          widget.label,
          style: textTheme.titleLarge,
        ),
        if (widget.desc is String)
          Text(
            widget.desc!,
            style: textTheme.titleSmall,
          )
      ],
    );

    Widget rendered = widget.icon != null
        ? Row(children: [
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: widget.icon,
            ),
            mainTexts
          ])
        : mainTexts;

    Widget mainContent = Container(
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 4,
      ),
      height: 64,
      child: widget.buttonType == ButtonType.switcher
          ? Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                rendered,
                if (widget.switcherType == SwitcherType.extended)
                  SizedBox(
                    height: 48,
                    child: VerticalDivider(
                      width: 16,
                      color: colorScheme.outlineVariant,
                      thickness: 0,
                    ),
                  ),
                Switch(
                  value: switcherDefaultValue!,
                  onChanged: widget.disabled ? null : switcherChangeState,
                )
              ],
            )
          : rendered,
    );

    Widget mainInkBox = InkWell(
      onTap: () {
        switch (widget.buttonType) {
          case ButtonType.page:
            Options.goto(context, widget.target!);
            break;
          case ButtonType.select:
            widget.action!(context);
            break;
          case ButtonType.switcher:
            switch (widget.switcherType) {
              case SwitcherType.extended:
                if (widget.action is void Function(BuildContext)) {
                  widget.action!(context);
                } else {
                  Options.goto(context, widget.target!);
                }
                break;
              default:
                switcherChangeState(!switcherDefaultValue!);
                break;
            }
            break;
        }
      },
      child: mainContent,
    );

    return widget.disabled ? mainContent : mainInkBox;
    // };
  }
}
