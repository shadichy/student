import 'package:flutter/material.dart';
import 'package:student/ui/components/option.dart';
import 'package:student/ui/components/options.dart';
import 'package:student/ui/components/pages/settings/components.dart';
import 'package:student/ui/components/section_label.dart';

class OptionLabelWidgets extends StatefulWidget {
  final List<Option> options;
  final String headingLabel;
  const OptionLabelWidgets(
    this.options, {
    super.key,
    this.headingLabel = "Quick actions",
  });

  @override
  State<OptionLabelWidgets> createState() => _OptionLabelWidgetsState();
}

class _OptionLabelWidgetsState extends State<OptionLabelWidgets> {
  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    TextTheme textTheme = Theme.of(context).textTheme;

    List<Widget> content = [
      SectionLabel(
        widget.headingLabel,
        Options.add("", (BuildContext context) {}),
        // fontWeight: FontWeight.w300,
        textStyle: textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
        color: colorScheme.onPrimaryContainer,
      ),
      ListView.separated(
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: ((context, index) {
          return SubPage(
            label: widget.options[index].label,
            action: widget.options[index].target,
            icon: widget.options[index].icon is Icon
                ? Icon(
                    (widget.options[index].icon as Icon).icon,
                    size: 28,
                  )
                : widget.options[index].icon is ImageIcon
                    ? ImageIcon(
                        (widget.options[index].icon as ImageIcon).image,
                        size: 28,
                      )
                    : widget.options[index].icon,
          );
        }),
        separatorBuilder: ((context, index) {
          return const Divider(
            color: Colors.transparent,
            height: 4,
          );
        }),
        itemCount: widget.options.length,
        shrinkWrap: true,
      ),
      SizedBox(
        width: 220,
        child: TextOption(
          Options.add("Thêm shortcut", (BuildContext context) {}),
          margin: const EdgeInsets.symmetric(vertical: 8),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          color: colorScheme.onPrimaryContainer,
          backgroundColor: colorScheme.primaryContainer,
          fontWeight: FontWeight.w700,
          textAlign: TextAlign.center,
          iconSize: 24,
          fontSize: 12,
          borderRadius: const BorderRadius.all(Radius.circular(30)),
          dense: true,
        ),
      ),
    ];

    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Column(
        children: content,
      ),
    );
  }
}
