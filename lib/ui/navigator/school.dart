import 'package:flutter/material.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:student/ui/components/navigator/navigator.dart';
import 'package:student/ui/components/navigator/quick_navigators.dart';
import 'package:student/ui/components/navigator/school/glance_widget.dart';
import 'package:student/ui/components/navigator/school/searchbar_widget.dart';
import 'package:student/ui/components/navigator/school/topbar_widget.dart';
import 'package:student/ui/components/navigator/school/updated_news.dart';
import 'package:student/ui/components/with_appbar.dart';

class SchoolPage extends StatefulWidget implements TypicalPage {
  const SchoolPage({super.key});

  @override
  State<SchoolPage> createState() => _SchoolPageState();

  @override
  Icon get icon => const Icon(Symbols.school);

  @override
  String get title => "School";
}

class _SchoolPageState extends State<SchoolPage> {
  late final bool hasData = [].isNotEmpty;

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;

    return WithAppbar(
      appBar: const SchoolTopBar(),
      body: [
        // const SchoolTopBar(),
        SchoolGlance(AssetImage(
          "assets/images/wide_logo${Theme.of(context).brightness == Brightness.light ? '' : "_dark"}.png",
        )),
        const SchoolSearchBar(),
        const UpdatedNews([
          URL(
            "label1",
            "https://service.teamfuho.net/wp-content/uploads/2024/02/2024-02-10_22.06.19.jpg",
          ),
          URL(
            "label2",
            "https://service.teamfuho.net/wp-content/uploads/2024/02/2024-02-10_22.06.19.jpg",
          ),
          URL(
            "label3",
            "https://service.teamfuho.net/wp-content/uploads/2024/02/2024-02-10_22.06.19.jpg",
          ),
          URL(
            "label4",
            "https://service.teamfuho.net/wp-content/uploads/2024/02/2024-02-10_22.06.19.jpg",
          ),
        ]),
        OptionLabelWidgets(widget.title),
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Visit ",
                style: TextStyle(
                  color: colorScheme.onSurface,
                ),
              ),
              InkWell(
                onTap: () {},
                child: Text(
                  "https://thanglong.edu.vn",
                  style: TextStyle(
                    color: colorScheme.primary,
                  ),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
