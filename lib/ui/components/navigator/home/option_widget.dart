import 'package:flutter/material.dart';
import 'package:student/ui/components/options.dart';
import 'package:student/ui/components/quick_option.dart';

class OptionIconWidgets extends StatefulWidget {
  final List<Option> options;
  const OptionIconWidgets(this.options, {super.key});

  @override
  State<OptionIconWidgets> createState() => _OptionIconWidgetsState();
}

class _OptionIconWidgetsState extends State<OptionIconWidgets> {
  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;

    List<IconOption> configIconOptions = widget.options
            .map(
              (Option e) => IconOption(
                e,
                padding: const EdgeInsets.all(8),
                iconColor: colorScheme.onTertiaryContainer,
                iconBackground: colorScheme.tertiaryContainer,
              ),
            )
            .toList() +
        [
          IconOption(
            Options.add(() => {}),
            padding: const EdgeInsets.all(8),
            iconColor: colorScheme.onTertiaryContainer,
            iconBackground: colorScheme.background,
          ),
        ];
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: configIconOptions,
          ),
        ),
      ),
    );
  }
}

class OptionLabelWidgets extends StatefulWidget {
  final List<Option> options;
  const OptionLabelWidgets(this.options, {super.key});

  @override
  State<OptionLabelWidgets> createState() => _OptionLabelWidgetsState();
}

class _OptionLabelWidgetsState extends State<OptionLabelWidgets> {
  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;

    List<IconOption> configIconOptions = widget.options
            .map(
              (Option e) => IconOption(
                e,
                padding: const EdgeInsets.all(8),
                iconColor: colorScheme.onTertiaryContainer,
                iconBackground: colorScheme.tertiaryContainer,
              ),
            )
            .toList() +
        [
          IconOption(
            Options.add(() => {}),
            padding: const EdgeInsets.all(8),
            iconColor: colorScheme.onTertiaryContainer,
            iconBackground: colorScheme.background,
          ),
        ];
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
      padding: const EdgeInsets.all(0),
      width: MediaQuery.of(context).size.width,
      decoration: const BoxDecoration(
        color: Color(0x00000000),
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.zero,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 0, horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                Text(
                  "Quick actions",
                  textAlign: TextAlign.start,
                  overflow: TextOverflow.clip,
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    fontStyle: FontStyle.normal,
                    fontSize: 20,
                    color: Color(0xff000000),
                  ),
                ),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8, horizontal: 0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                ListTile(
                  tileColor: Color(0x00000000),
                  title: Text(
                    "Cài đặt",
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontStyle: FontStyle.normal,
                      fontSize: 16,
                      color: Color(0xff000000),
                    ),
                    textAlign: TextAlign.start,
                  ),
                  dense: false,
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                  selected: false,
                  selectedTileColor: Color(0x42000000),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.zero,
                  ),
                  leading:
                      Icon(Icons.settings, color: Color(0xff212435), size: 24),
                ),
                ListTile(
                  tileColor: Color(0x00000000),
                  title: Text(
                    "Chương trình đào tạo",
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontStyle: FontStyle.normal,
                      fontSize: 16,
                      color: Color(0xff000000),
                    ),
                    textAlign: TextAlign.start,
                  ),
                  dense: false,
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                  selected: false,
                  selectedTileColor: Color(0x42000000),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.zero,
                  ),
                  leading: Icon(Icons.book, color: Color(0xff212435), size: 24),
                ),
                ListTile(
                  tileColor: Color(0x00000000),
                  title: Text(
                    "Kết quả học tập",
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontStyle: FontStyle.normal,
                      fontSize: 16,
                      color: Color(0xff000000),
                    ),
                    textAlign: TextAlign.start,
                  ),
                  dense: false,
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                  selected: false,
                  selectedTileColor: Color(0x42000000),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.zero,
                  ),
                  leading: Icon(Icons.description,
                      color: Color(0xff212435), size: 24),
                ),
                ListTile(
                  tileColor: Color(0x00000000),
                  title: Text(
                    "Tài chính sinh viên",
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontStyle: FontStyle.normal,
                      fontSize: 16,
                      color: Color(0xff000000),
                    ),
                    textAlign: TextAlign.start,
                  ),
                  dense: false,
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                  selected: false,
                  selectedTileColor: Color(0x42000000),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.zero,
                  ),
                  leading: Icon(Icons.credit_card,
                      color: Color(0xff212435), size: 24),
                ),
                ListTile(
                  tileColor: Color(0x00000000),
                  title: Text(
                    "Hướng dẫn sử dụng app",
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontStyle: FontStyle.normal,
                      fontSize: 16,
                      color: Color(0xff000000),
                    ),
                    textAlign: TextAlign.start,
                  ),
                  dense: false,
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                  selected: false,
                  selectedTileColor: Color(0x42000000),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.zero,
                  ),
                  leading: Icon(Icons.help, color: Color(0xff212435), size: 24),
                ),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.all(0),
            padding: const EdgeInsets.all(0),
            width: 200,
            decoration: BoxDecoration(
              color: const Color(0x15000000),
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(32.0),
            ),
            child: const ListTile(
              tileColor: Color(0x00000000),
              title: Text(
                "Thêm shortcut",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontStyle: FontStyle.normal,
                  fontSize: 14,
                  color: Color(0xff000000),
                ),
                textAlign: TextAlign.start,
              ),
              dense: true,
              contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 16),
              selected: false,
              selectedTileColor: Color(0x42000000),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.zero,
              ),
              leading: Icon(Icons.add, color: Color(0xff212435), size: 24),
            ),
          ),
        ],
      ),
    );
  }
}
