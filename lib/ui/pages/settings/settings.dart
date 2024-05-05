import 'package:flutter/material.dart';
import 'package:student/ui/components/options.dart';
import 'package:student/ui/components/pages/settings/components.dart';
import 'package:student/ui/pages/settings/themes.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    TextTheme textTheme = Theme.of(context).textTheme;
    List<Widget> subPages = const [
      SubPage(
        label: "Notifications",
        desc: "Configure notifications and reminders",
      ),
      SubPage(
        label: "Theme",
        desc: "Change how the app looks and feels",
        target: SettingsThemesPage(),
      ),
      SubPage(
        label: "Misc",
        desc: "Additional settings",
      ),
      SubPage(
        label: "About",
      )
    ];
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
              'Settings',
              style: textTheme.displaySmall,
              textAlign: TextAlign.left,
            ),
          ),
          ListView.separated(
            shrinkWrap: true,
            itemBuilder: ((context, index) => subPages[index]),
            separatorBuilder: ((context, index) {
              return const Divider(
                height: 8,
                color: Colors.transparent,
              );
            }),
            itemCount: subPages.length,
          ),
        ]),
      ),
    );
  }
}
