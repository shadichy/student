import 'package:flutter/material.dart';
import 'package:student/ui/components/options.dart';
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
    return Column(
      children: [
        SectionLabel(
          "Thông tin ngành học",
          Options.forward("", (context) {}),
          fontWeight: FontWeight.bold,
          fontSize: 16,
          color: colorScheme.onSurface,
        ),
        Card.filled(
          color: colorScheme.primary.withOpacity(0.05),
          margin: const EdgeInsets.symmetric(horizontal: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: InkWell(
            onTap: () {},
            hoverColor: Colors.transparent,
            focusColor: Colors.transparent,
            borderRadius: BorderRadius.circular(16),
            child: Column(children: [
              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: 800,
              ),
            ]),
          ),
        ),
      ],
    );
  }
}
