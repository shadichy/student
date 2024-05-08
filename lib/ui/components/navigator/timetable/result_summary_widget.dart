import 'package:flutter/material.dart';
import 'package:student/ui/components/navigator/clickable_card.dart';
import 'package:student/ui/components/options.dart';
import 'package:student/ui/components/section_label.dart';

class ResultSummaryWidget extends StatefulWidget {
  const ResultSummaryWidget({super.key});

  @override
  State<ResultSummaryWidget> createState() => _ResultSummaryWidgetState();
}

class _ResultSummaryWidgetState extends State<ResultSummaryWidget> {
  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    TextTheme textTheme = Theme.of(context).textTheme;
    return Column(
      children: [
        SectionLabel(
          "Kết quả học tập kì trước",
          Options.forward((context) {}),
          fontWeight: FontWeight.bold,
          textStyle: textTheme.titleMedium,
          color: colorScheme.onSurface,
        ),
        ClickableCard(
          target: () {},
          child: Column(children: [
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: 400,
            ),
          ]),
        ),
      ],
    );
  }
}
