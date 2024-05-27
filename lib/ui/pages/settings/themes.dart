import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:student/core/databases/hive.dart';
import 'package:student/ui/components/pages/settings/components.dart';
import 'package:student/ui/components/pages/settings/searchable_selector_dialog.dart';
import 'package:student/ui/components/pages/settings/svg_theme.dart';
import 'package:student/ui/components/pages/settings/theme_preview.dart';
import 'package:flutter/foundation.dart' show defaultTargetPlatform;
import 'package:student/ui/connect.dart';
import 'package:system_theme/system_theme.dart';

import 'package:student/ui/components/navigator/navigator.dart';

class SettingsThemesPage extends StatefulWidget implements TypicalPage {
  @override
  Icon get icon => const Icon(Symbols.contrast_circle);

  @override
  String get title => "Giao diện";

  const SettingsThemesPage({super.key});

  @override
  State<SettingsThemesPage> createState() => _SettingsThemesPageState();
}

class _SettingsThemesPageState extends State<SettingsThemesPage> {
  bool useSystem = Storage().fetch<bool>("theme.systemTheme") ?? false;
  late int? colorCode = useSystem
      ? SystemTheme.accentColor.accent.value
      : Storage().fetch<int>("theme.accentColor");
  late bool darkMode = Storage().fetch<int>("theme.themeMode") == 2;
  late String? currentFont = Storage().fetch<String>("theme.appFont");

  void switchUseSystem(bool newState) {
    setState(() {
      useSystem = newState;
    });
    Storage().put("theme.systemTheme", newState);
  }

  void changePalette(int color) {
    setState(() {
      colorCode = color;
    });
    Storage().put("theme.accentColor", color);
  }

  void setDarkMode(bool newState) {
    setState(() {
      darkMode = newState;
    });
    Storage().put("theme.themeMode", newState ? 2 : 1);
  }

  void setFont(String fontName) {
    setState(() {
      currentFont = fontName;
    });
    Storage().put("theme.appFont", fontName == "System" ? null : fontName);
  }

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    TextTheme textTheme = Theme.of(context).textTheme;

    Brightness brightness = useSystem
        ? Theme.of(context).brightness
        : Brightness.values[darkMode ? 0 : 1];

    return SettingsBase(
      label: "Themes",
      onPopInvoked: (didPop) {
        if (didPop) {
          StudentApp.action(context, AppAction.reload);
        }
      },
      children: [
        if (defaultTargetPlatform.supportsAccentColor)
          Opt(
            label: "System theme",
            desc: "Use theme provided by system",
            buttonType: ButtonType.switcher,
            switcherDefaultValue: useSystem,
            switcherAction: switchUseSystem,
          ),
        ThemePreviewBox((colorCode is int
            ? ColorScheme.fromSeed(
                seedColor: Color(colorCode!),
                brightness: brightness,
              )
            : colorScheme.copyWith(
                brightness: brightness,
              ))),
        // disabled: useSystem,
        PaletteSelector(useSystem ? null : changePalette),
        Opt(
          label: "Dark mode",
          desc: "Use dark theme",
          buttonType: ButtonType.switcher,
          switcherDefaultValue: darkMode,
          switcherAction: setDarkMode,
          disabled: useSystem,
        ),
        Opt(
          label: "Font",
          desc: currentFont ?? "System",
          buttonType: ButtonType.select,
          action: (context) {
            showDialog<String>(
              context: context,
              builder: (context) {
                List<String> availableFonts = GoogleFonts.asMap().keys.toList();
                List<String> fontList = ["System", ...availableFonts];
                return SearchableSelectorDialog(
                  title: Text(
                    "Select font",
                    style: textTheme.bodyMedium,
                  ),
                  hintText: "Search font",
                  items: fontList,
                  itemBuilder: (context, item) {
                    return Row(children: [
                      SizedBox(
                        width: 48,
                        child: Text(
                          "ABC",
                          textAlign: TextAlign.right,
                          style: (item == "System")
                              ? null
                              : GoogleFonts.getFont(item),
                        ),
                      ),
                      Text(" \u2022 $item"),
                    ]);
                  },
                  searchMethod: (query, items) {
                    String k = query.toLowerCase();
                    return items.skip(1).where((i) {
                      return i.toLowerCase().contains(k);
                    }).toList();
                  },
                );
              },
            ).then((font) {
              if (font != null) setFont(font);
            });
          },
          disabled: useSystem,
        ),
      ],
    );
  }
}
