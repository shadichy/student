import 'package:flutter/widgets.dart';
import 'package:student/ui/components/pages/settings/components.dart';

class SubjectDetailPage extends StatelessWidget {
  final List<SubPage> content;
  final String label;
  const SubjectDetailPage({
    required this.label,
    required this.content,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SettingsBase(
      label: label,
      children: content,
    );
  }
}
