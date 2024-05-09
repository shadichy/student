
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:flutter/material.dart';
import 'package:student/ui/components/options.dart';

class SettingsBase extends StatelessWidget {
  final String label;
  final void Function(bool)? onPopInvoked;
  final List<Widget> children;
  const SettingsBase({
    super.key,
    required this.label,
    required this.children,
    this.onPopInvoked,
  });

  final double _kToolbarMaxHeight = 160;
  final double _kToolbarMinHeight = 64;

  final double _kTitleMaxPadding = 56;
  final double _kTitleMinPadding = 16;

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      /* appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(Symbols.arrow_back, size: 28),
        ),
      ), */
      body: PopScope(
        onPopInvoked: onPopInvoked,
        /* child: SingleChildScrollView(
          child: Column(children: [
            Container(
              padding: const EdgeInsets.only(
                top: 64,
                bottom: 32,
                left: 16,
                right: 16,
              ),
              alignment: Alignment.centerLeft,
              child: Text(
                label,
                style: Theme.of(context).textTheme.displaySmall,
                textAlign: TextAlign.left,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            ...children,
          ]),
        ), */
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              toolbarHeight: _kToolbarMinHeight,
              expandedHeight: _kToolbarMaxHeight,
              elevation: 0,
              scrolledUnderElevation: 0,
              surfaceTintColor: Colors.transparent,
              shadowColor: colorScheme.shadow,
              floating: true,
              pinned: true,
              snap: true,
              leading: IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(Symbols.arrow_back, size: 28),
              ),
              flexibleSpace: LayoutBuilder(
                builder: (context, constraints) {
                  // print(MediaQuery.of(context).size.height);
                  // print((constraints.biggest.height - _kToolbarMinHeight) /
                  // (_kToolbarMaxHeight - _kToolbarMinHeight));
                  return FlexibleSpaceBar(
                    // collapseMode: CollapseMode.none,
                    titlePadding: EdgeInsets.symmetric(
                      vertical: 16,
                      horizontal: _kTitleMaxPadding -
                          (_kTitleMaxPadding - _kTitleMinPadding) *
                              (constraints.biggest.height -
                                  _kToolbarMinHeight) /
                              (_kToolbarMaxHeight - _kToolbarMinHeight),
                    ),
                    centerTitle: false,
                    stretchModes: const [StretchMode.fadeTitle],
                    title: Text(
                      label,
                      style: Theme.of(context).textTheme.headlineSmall,
                      textAlign: TextAlign.left,
                      overflow: TextOverflow.ellipsis,
                    ),
                  );
                },
              ),
            ),
            SliverList(
              delegate: SliverChildListDelegate([Column(children: children)]),
            ),
          ],
        ),
      ),
    );
  }
}

enum ButtonType { page, select, switcher }

enum SwitcherType { basic, extended }

class SubPage extends StatelessWidget {
  final String label;
  final String? desc;
  final Widget? target;
  final void Function(BuildContext context)? action;
  final Widget? icon;
  final double? minVerticalPadding;
  const SubPage({
    super.key,
    required this.label,
    this.desc,
    this.target,
    this.action,
    this.icon,
    this.minVerticalPadding,
  });

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    return ListTile(
      minVerticalPadding: minVerticalPadding ?? 12,
      title: Text(label, style: textTheme.titleLarge),
      subtitle: desc != null ? Text(desc!, style: textTheme.bodyMedium) : null,
      leading: icon,
      onTap: target != null
          ? () => Options.goto(context, target!)
          : action != null
              ? () => action!(context)
              : null,
    );
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
    TextTheme textTheme = Theme.of(context).textTheme.apply(
        bodyColor:
            widget.disabled ? colorScheme.onSurface.withOpacity(0.38) : null);

    return ListTile(
      // contentPadding: const EdgeInsets.symmetric(vertical: 8),
      minVerticalPadding: 12,
      title: Text(widget.label, style: textTheme.titleLarge),
      subtitle: widget.desc != null
          ? Text(widget.desc!, style: textTheme.bodyMedium)
          : null,
      leading: widget.icon,
      trailing: widget.buttonType == ButtonType.switcher
          ? Row(
              mainAxisSize: MainAxisSize.min,
              children: [
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
          : null,
      onTap: widget.disabled
          ? null
          : () {
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
                      if (widget.action != null) {
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
    );
  }
}
