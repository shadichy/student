import 'package:flutter/material.dart';
import 'package:student/ui/components/option.dart';
import 'package:student/ui/components/section_label.dart';

class URL {
  final String url;
  const URL(this.url);
}

class UpdatedNews extends StatefulWidget {
  final List<URL> news;
  const UpdatedNews(this.news, {super.key});

  @override
  State<UpdatedNews> createState() => _UpdatedNewsState();
}

class _UpdatedNewsState extends State<UpdatedNews> {
  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    return Column(
      children: [
        SectionLabel(
          "Tài liệu mới cập nhật",
          Option(Icons.arrow_forward, "", () {}),
          fontWeight: FontWeight.w900,
          fontSize: 20,
        ),
        Container(
          width: MediaQuery.of(context).size.width,
          height: 200,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                Card(
                  color: colorScheme.primary.withAlpha(20),
                )
              ],
            ),
          ),
        )
      ],
    );
  }
}
