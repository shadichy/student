import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:flutter/material.dart';
import 'package:student/core/databases/hive.dart';
import 'package:student/core/databases/study_program_basics.dart';
import 'package:student/core/databases/subject.dart';
import 'package:student/core/databases/user.dart';
import 'package:student/core/generator/generator.dart';
import 'package:student/core/routing.dart';
import 'package:student/core/semester/functions.dart';
import 'package:student/misc/iterable_extensions.dart';
import 'package:student/misc/misc_functions.dart';
import 'package:student/misc/misc_widget.dart';

import 'package:student/ui/components/navigator/navigator.dart';

class ToolsTimetableGeneratorPage extends StatefulWidget
    implements TypicalPage {
  const ToolsTimetableGeneratorPage({super.key});

  @override
  State<ToolsTimetableGeneratorPage> createState() =>
      _ToolsTimetableGeneratorPageState();

  @override
  Icon get icon => const Icon(Symbols.calendar_add_on);

  @override
  String get title => "Công cụ tạo lập thời khoá biểu";
}

class _ToolsTimetableGeneratorPageState
    extends State<ToolsTimetableGeneratorPage> {
  // List<WeekTimetable> savedTimetables = [];
  Map<String, SubjectFilter> filterData = {};

  late final GenTimetable generator;

  bool initialized = false;

  @override
  void initState() {
    super.initState();
    initGenerator();
  }

  Future<void> initGenerator() async {
    DateTime now = DateTime.now();
    UserGroup group = SPBasics().userGroup;

    Future<Map<String, dynamic>> getFrom(String route) async =>
        await Storage().endpoint("${group.name}/$route");

    Map<String, dynamic> plan = await getFrom("study_plan");
    DateTime planStart = MiscFns.epoch(plan["startDate"]);

    int semeterInt = 0;
    for (String semesterString in (plan["plan"] as List).cast()) {
      if (planStart.isBefore(now)) break;
      semeterInt++;
      planStart = planStart.add(Duration(days: semesterString.length));
    }
    UserSemester semester = UserSemester.values[semeterInt];

    final baseSubjects = (await getFrom("subjects")).map((k, v) {
      return MapEntry(k, BaseSubject.fromJson(v as Map<String, dynamic>, k));
    });

    final subjects = (await getFrom("${semester.name}/semester")).map((k, v) {
      return MapEntry(
        k,
        Subject.fromBase(
          baseSubjects[k]!,
          (v as Map<String, dynamic>).map((c, t) {
            return MapEntry(c, SubjectCourse.fromList(t as List, c, k));
          }),
        ),
      );
    });

    generator = GenTimetable(subjects);
    setState(() => initialized = true);
    // WidgetsBinding.instance.addPostFrameCallback((_) => searchCourse());
  }

  List<String> searchResult = [];

  @override
  Widget build(BuildContext context) {
    ThemeData d = Theme.of(context);
    ColorScheme c = d.colorScheme;
    TextTheme t = d.textTheme;
    var content = Column(children: [
      Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        padding: const EdgeInsets.only(bottom: 8),
        height: 64,
        child: TextField(
          textAlignVertical: TextAlignVertical.center,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.zero,
            prefixIcon: const Icon(Symbols.search),
            hintText: "widget.hintText",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(32),
              borderSide: BorderSide(color: c.outlineVariant),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(32),
              borderSide: BorderSide(color: c.outline),
            ),
          ),
          onChanged: (query) => setState(() {
            query = query.trim().toLowerCase();
            if (query.isEmpty) {
              searchResult = filterData.keys.toList();
              return;
            }
            bool checkQuery(String? s) =>
                s?.toLowerCase().contains(query) ?? false;
            searchResult = generator.subjectData.values.where((subject) {
              return checkQuery(subject.subjectID) ||
                  checkQuery(subject.subjectAltID);
            }).map((subject) {
              return subject.subjectID;
            }).toList();
          }),
        ),
      ),
      Expanded(
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: ListView.builder(
            itemCount: searchResult.length,
            itemBuilder: (_, i) => ListTile(
              contentPadding: const EdgeInsets.all(16),
              title: Text(
                generator.subjectData[searchResult[i]]!.name,
              ),
              subtitle: Text(searchResult[i]),
              leading: Checkbox(
                tristate: true,
                value: ((SubjectFilter? f) {
                  return f == null
                      ? false
                      : f.isEmpty
                          ? true
                          : null;
                })(filterData[searchResult[i]]),
                onChanged: (value) => setState(() {
                  value == true
                      ? filterData[searchResult[i]] = SubjectFilter()
                      : filterData.remove(searchResult[i]);
                }),
              ),
              trailing: IconButton(
                onPressed: () => showDialog<SubjectFilter>(
                  context: context,
                  builder: (_) => SubjectFilterDialog(
                    filterData[searchResult[i]],
                  ),
                ).then((value) {
                  if (value == null) return;
                  filterData[searchResult[i]] = value;
                  if (context.mounted) setState(() {});
                }),
                icon: const Icon(Symbols.filter_alt),
              ),
            ),
          ),
        ),
      ),
      Container(
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.all(16),
        child: TextButton(
          onPressed: () => Routing.goto(
            context,
            Routing.generator_instance(
              generator.generate(filterData),
            ),
          ),
          style: TextButton.styleFrom(
            backgroundColor: c.primary,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            padding: const EdgeInsets.all(16),
          ),
          child: Text(
            "Generate",
            style: t.labelLarge?.apply(
              color: c.onPrimary,
            ),
          ),
        ),
      ),
    ]);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          onPressed: Navigator.of(context).pop,
          icon: const Icon(Symbols.arrow_back, size: 28),
        ),
        title: Text(
          widget.title,
          textAlign: TextAlign.center,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.headlineSmall,
          maxLines: 3,
        ),
      ),
      body: SafeArea(
        child: initialized ? content : const Center(child: Text("Loading")),
      ),
    );
  }
}

class SubjectFilterDialog extends StatefulWidget {
  final SubjectFilter? filter;
  const SubjectFilterDialog(this.filter, {super.key});

  @override
  State<SubjectFilterDialog> createState() => _SubjectFilterDialogState();
}

class _SubjectFilterDialogState extends State<SubjectFilterDialog> {
  late SubjectFilter filter;

  @override
  void initState() {
    filter = widget.filter ?? SubjectFilter();
    super.initState();
  }

  TableRow entryRow<T>({
    required String label,
    required List<T> items,
    required Widget Function(T item) builder,
    required void Function(T item) onRemove,
    required void Function(String value) onAdd,
  }) {
    ThemeData d = Theme.of(context);
    ColorScheme c = d.colorScheme;
    TextTheme t = d.textTheme;

    TextEditingController ctl = TextEditingController();

    OutlineInputBorder outlineInputBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(width: 1, color: c.outline),
    );
    return TableRow(children: [
      Text(label),
      MWds.vDivider(16),
      Column(mainAxisSize: MainAxisSize.min, children: [
        Wrap(
          children: items
              .map<Widget>((item) {
                return Chip(
                  label: builder(item),
                  onDeleted: () => setState(() => onRemove(item)),
                );
              })
              .separatedBy(MWds.vDivider(8))
              .toList(),
        ),
        Container(
          // width: 120,
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(children: [
            Expanded(
              child: TextFormField(
                controller: ctl,
                decoration: InputDecoration(border: outlineInputBorder),
              ),
            ),
            IconButton(
              onPressed: () => setState(() => onAdd(ctl.text)),
              icon: Icon(Symbols.add, color: c.tertiary),
            )
          ]),
        ),
      ])
    ]);
  }

  @override
  Widget build(BuildContext context) {
    ThemeData d = Theme.of(context);
    ColorScheme c = d.colorScheme;
    TextTheme t = d.textTheme;
    return AlertDialog(
      title: const Text("Filter"),
      content: Column(
        children: [
          SizedBox(
            width: 600,
            child: Table(
              columnWidths: const {
                0: IntrinsicColumnWidth(),
                1: FixedColumnWidth(16),
              },
              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
              children: [
                entryRow(
                  label: "Included classes",
                  items: filter.inClass,
                  builder: Text.new,
                  onRemove: filter.inClass.remove,
                  onAdd: filter.inClass.add,
                ),
                entryRow(
                  label: "Excluded classes",
                  items: filter.notInClass,
                  builder: Text.new,
                  onRemove: filter.notInClass.remove,
                  onAdd: filter.notInClass.add,
                ),
                entryRow(
                  label: "Included teachers",
                  items: filter.includeTeacher,
                  builder: Text.new,
                  onRemove: filter.includeTeacher.remove,
                  onAdd: filter.includeTeacher.add,
                ),
                entryRow(
                  label: "Excluded teacher",
                  items: filter.excludeTeacher,
                  builder: Text.new,
                  onRemove: filter.excludeTeacher.remove,
                  onAdd: filter.excludeTeacher.add,
                ),
              ],
            ),
          ),
          SizedBox(
            width: 600,
            child: Table(
              columnWidths: const {0: IntrinsicColumnWidth()},
              children: const [],
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          style: TextButton.styleFrom(
            minimumSize: const Size(82, 32),
            padding: const EdgeInsets.all(12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(32),
              side: BorderSide(color: c.outline),
            ),
          ),
          onPressed: Navigator.of(context).pop,
          child: Text(
            "Cancel",
            style: t.bodyMedium?.apply(
              color: c.onSurface,
            ),
          ),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context, filter),
          style: TextButton.styleFrom(
            minimumSize: const Size(82, 32),
            padding: const EdgeInsets.all(12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(32),
            ),
            backgroundColor: c.primaryContainer,
          ),
          child: Text(
            "Done",
            style: t.bodyMedium?.apply(
              color: c.onPrimaryContainer,
            ),
          ),
        ),
      ],
    );
  }
}

final class FilterWithId {
  final String id;
  final SubjectFilter? filter;
  FilterWithId({required this.id, this.filter});

  MapEntry<String, SubjectFilter> get entry =>
      MapEntry(id, filter ?? SubjectFilter());

  @override
  bool operator ==(Object other) => other is FilterWithId && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
