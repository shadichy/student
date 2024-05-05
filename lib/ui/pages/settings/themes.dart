import 'package:flutter/material.dart';
import 'package:student/core/configs.dart';
import 'package:student/ui/components/pages/settings/components.dart';
import 'package:student/ui/components/pages/settings/svg_theme.dart';
import 'package:student/ui/components/pages/settings/theme_preview.dart';
import 'package:flutter/foundation.dart' show defaultTargetPlatform;
import 'package:system_theme/system_theme.dart';

class SettingsThemesPage extends StatefulWidget {
  const SettingsThemesPage({super.key});

  @override
  State<SettingsThemesPage> createState() => _SettingsThemesPageState();
}

class _SettingsThemesPageState extends State<SettingsThemesPage> {
  bool useSystem = AppConfig().getConfig<bool>("theme.systemTheme") ?? false;
  int? colorCode = AppConfig().getConfig<bool>("theme.systemTheme") == true
      ? SystemTheme.accentColor.accent.value
      : AppConfig().getConfig<int>("theme.accentColor");
  bool darkMode = AppConfig().getConfig<int>("theme.themeMode") == 2;
  String currentFont =
      AppConfig().getConfig<String>("theme.appFont") ?? "Roboto";

  void switchUseSystem(bool newState) {
    setState(() {
      useSystem = newState;
    });
    AppConfig().setConfig("theme.systemTheme", newState);
  }

  void changePalette(int color) {
    setState(() {
      colorCode = color;
    });
    AppConfig().setConfig("theme.accentColor", color);
  }

  void setDarkMode(bool newState) {
    setState(() {
      darkMode = newState;
    });
    AppConfig().setConfig("theme.themeMode", newState ? 2 : 1);
  }

  void setFont(String fontName) {
    setState(() {
      currentFont = fontName;
    });
    AppConfig().setConfig("theme.appFont", fontName);
  }

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    TextTheme textTheme = Theme.of(context).textTheme;

    Brightness brightness =
        AppConfig().getConfig<bool>("theme.systemTheme") == true
            ? Theme.of(context).brightness
            : Brightness.values[darkMode ? 0 : 1];

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(children: [
          Container(
            padding: const EdgeInsets.only(
              top: 120,
              bottom: 32,
              left: 16,
              right: 16,
            ),
            alignment: Alignment.centerLeft,
            child: Text(
              'Themes',
              style: textTheme.displaySmall,
              textAlign: TextAlign.left,
            ),
          ),
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
            desc: "Change the app font",
            buttonType: ButtonType.select,
            action: (context) {
              //
            },
            disabled: useSystem,
          ),
        ]),
      ),
    );
  }
}
