import 'package:flutter/material.dart';
import 'package:student/ui/components/pages/settings/components.dart';
import 'package:student/ui/pages/settings/misc.dart';
import 'package:student/ui/pages/settings/notifications.dart';
import 'package:student/ui/pages/settings/themes.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
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
        desc: "Tieng Viet",
        buttonType: ButtonType.select,
        action: (context) {},
      ),
      const SubPage(
        label: "About",
      )
    ];
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(children: [
          const HeadLabel("Settings"),
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
