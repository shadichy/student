import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:flutter/material.dart';
import 'package:student/core/configs.dart';
import 'package:student/ui/components/interpolator.dart';
import 'package:student/ui/components/pages/settings/components.dart';
import 'package:student/ui/pages/settings/about.dart';
import 'package:student/ui/pages/settings/misc.dart';
import 'package:student/ui/pages/settings/notifications.dart';
import 'package:student/ui/pages/settings/themes.dart';

import 'package:student/ui/components/navigator/navigator.dart';

class SettingsPage extends StatefulWidget implements TypicalPage {
  @override
  Icon get icon => const Icon(Symbols.settings);

  @override
  String get title => "Cài đặt";

  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final Map<String, String> langMap = {
    "vi": "Tiếng Việt",
    "en": "English",
  };
  String lang = AppConfig().getConfig<String>("settings.language") ??
      defaultConfig["settings.language"]!;

  void languageAction(BuildContext context) {
    // ColorScheme colorScheme = Theme.of(context).colorScheme;
    TextTheme textTheme = Theme.of(context).textTheme;

    showDialog<String>(
      context: context,
      builder: (context) {
        List<MapEntry<String, String>> langMapEntry = langMap.entries.toList();
        return SimpleDialog(
          title: Text(
            "Select language",
            style: textTheme.bodyMedium,
          ),
          children: List.generate(langMap.length, (_) {
            return SimpleDialogOption(
              child: Text(
                langMapEntry[_].value,
              ),
              onPressed: () => Navigator.of(context).pop(langMapEntry[_].key),
            );
          }),
        );
      },
    ).then((_) {
      if (_ != null) setLang(_);
    });
  }

  void setLang(String newLang) {
    setState(() {
      lang = newLang;
    });
    AppConfig().setConfig("settings.language", newLang);
  }

  @override
  Widget build(BuildContext context) {
    // ColorScheme colorScheme = Theme.of(context).colorScheme;
    // TextTheme textTheme = Theme.of(context).textTheme;
    List<Widget> subPages = [
      const SubPage(
        label: "Notifications",
        desc: "Configure notifications and reminders",
        target: SettingsNotificationsPage(),
      ),
      const SubPage(
        label: "Theme",
        desc: "Change how the app looks and feels",
        target: SettingsThemesPage(),
      ),
      const SubPage(
        label: "Misc",
        desc: "Additional settings",
        target: SettingsMiscPage(),
      ),
      Opt(
        label: "Language",
        desc: langMap[lang],
        buttonType: ButtonType.select,
        action: languageAction,
      ),
      const SubPage(
        label: "About",
        target: SettingsAboutPage(),
      )
    ];
    return SettingsBase(
      label: "Settings",
      children: [
        SimpleListBuilder(
          builder: ((index) => subPages[index]),
          itemCount: subPages.length,
        ),
      ],
    );
  }
}
