import 'package:flutter/material.dart';
import 'package:student/ui/components/navigator/clickable_card.dart';
import 'package:student/ui/components/section_label.dart';

class MajorInfoWidget extends StatefulWidget {
  const MajorInfoWidget({super.key});

  @override
  State<MajorInfoWidget> createState() => _MajorInfoWidgetState();
}

class _MajorInfoWidgetState extends State<MajorInfoWidget> {
  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    TextTheme textTheme = Theme.of(context).textTheme;
    return Column(
      children: [
        SectionLabel(
          "Thông tin ngành học",
          route: 'major',
          fontWeight: FontWeight.bold,
          textStyle: textTheme.titleMedium,
          color: colorScheme.onSurface,
        ),
        ClickableCard(
          target: () {},
          child: Column(children: [
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: 800,
            ),
          ]),
        ),
      ],
    );
  }
}
