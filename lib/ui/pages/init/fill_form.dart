import 'package:flutter/material.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:restart_app/restart_app.dart';
import 'package:student/core/databases/hive.dart';
import 'package:student/core/databases/user.dart';
import 'package:student/core/default_configs.dart';
import 'package:student/misc/misc_widget.dart';
import 'package:student/ui/components/pages/settings/components.dart';

class FillForm extends StatefulWidget {
  const FillForm({super.key});

  @override
  State<FillForm> createState() => _FillFormState();
}

class _FillFormState extends State<FillForm> {
  TextEditingController lCOCSController = TextEditingController();

  void lCOCSAdd([String? key]) {
    setState(() {
      inLearningCourses.add(key ?? lCOCSController.text);
      lCOCSController.clear();
    });
  }

  void lCOCSRemove(String r) {
    setState(() {
      inLearningCourses.remove(r);
    });
  }

  String? id;
  String? name;
  String? pictureUri;
  UserGroup? group;
  UserSemester? semester;
  int? schoolYear;
  int? currentSchoolYear;
  final List<String> inLearningCourses = [];
  String? major;
  String? majorClass;
  int? majorCred;
  int? credits;

  String query = '';
  Map<String, MapEntry<String, String>> queryData = {};
  List<String> filteredData = [];
  bool fulfillQuery = false;
  bool queryFetched = false;

  String dataUrl = '';

  void Function(T)? _baseInfoFulfilled<T>(void Function(T) pre) {
    return (T value) async {
      setState(() {
        fulfillQuery = false;
        queryFetched = false;
      });
      pre(value);
      for (var f in [
        id,
        name,
        group,
        semester,
        schoolYear,
        currentSchoolYear
      ]) {
        if (f == null) return;
      }
      User().setUser({
        "id": id,
        "name": name,
        "group": group?.index,
        "semester": semester?.index,
        "schoolYear": schoolYear,
        "learning": List.filled(
          currentSchoolYear!,
          List.filled(UserSemester.values.length, []),
        ),
      });
      setState(() {
        fulfillQuery = true;
      });
      await Storage().initialize();
      setState(() {
        queryData = Map.fromEntries(Storage().subjects.map((e) {
          return e.courses.values.map((c) {
            return MapEntry(
              c.courseID,
              MapEntry(
                e.name,
                "${c.courseID} ${e.subjectID} ${e.name}".toLowerCase(),
              ),
            );
          });
        }).fold([], (a, b) => [...a, ...b]));
        queryFetched = true;
      });
    };
  }

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    TextTheme textTheme = Theme.of(context).textTheme;

    OutlineInputBorder roundedBorder = OutlineInputBorder(
      // border radius 16, width 4
      borderRadius: BorderRadius.circular(16),
      borderSide: BorderSide(
        color: colorScheme.primary,
        width: 1,
      ),
    );

    TextStyle? textStyle = textTheme.bodyLarge?.apply(
      color: colorScheme.onPrimaryContainer,
    );

    InputDecorationTheme inputDecorationTheme = InputDecorationTheme(
      border: roundedBorder.copyWith(
        borderSide: BorderSide(color: colorScheme.onSurfaceVariant),
      ),
      enabledBorder: roundedBorder,
      focusedBorder: roundedBorder,
      hintStyle: textStyle,
      labelStyle: textStyle,
    );

    InputDecoration inputDecoration = const InputDecoration().applyDefaults(
      inputDecorationTheme,
    );

    ButtonStyle style = TextButton.styleFrom(
      backgroundColor: colorScheme.primaryContainer,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(16),
      fixedSize: Size.fromWidth(MediaQuery.of(context).size.width),
      textStyle: textStyle,
    );

    List<Widget> fields = [
      TextField(
        onChanged: _baseInfoFulfilled((value) => id = value),
        decoration: inputDecoration.copyWith(
          labelText: "Student ID",
          hintText: "Enter your ID",
        ),
      ),
      TextField(
        onChanged: _baseInfoFulfilled((value) => name = value),
        decoration: inputDecoration.copyWith(
          labelText: "Student Name",
          hintText: "Enter your name",
        ),
      ),
      TextField(
        onChanged: (value) => pictureUri = value,
        decoration: inputDecoration.copyWith(
          labelText: "Photo URL (Optional)",
          hintText: "Enter your photo URL (e.g. https://example.com/image.jpg)",
        ),
      ),
      TextField(
        onChanged: _baseInfoFulfilled((value) => schoolYear = int.parse(value)),
        decoration: inputDecoration.copyWith(
          labelText: "Generation",
          hintText: "Enter your generation age",
        ),
        keyboardType: TextInputType.number,
      ),
      TextField(
        onChanged: _baseInfoFulfilled((value) {
          currentSchoolYear = int.parse(value);
          int c = currentSchoolYear!;
          List uEnum = UserGroup.values;
          setState(() {
            group = uEnum[c >= uEnum.length ? 0 : uEnum.length - c];
          });
        }),
        decoration: inputDecoration.copyWith(
          labelText: "Year",
          hintText: "Enter your current school year (e.g year 1, 2)",
        ),
        keyboardType: TextInputType.number,
      ),
      DropdownMenu<UserGroup>(
        initialSelection: group,
        onSelected:
            _baseInfoFulfilled((UserGroup? newValue) => group = newValue),
        dropdownMenuEntries: UserGroup.values.map((UserGroup group) {
          return DropdownMenuEntry<UserGroup>(
            value: group,
            label: group.name.toUpperCase(),
          );
        }).toList(),
        label: const Text("Group"),
        hintText: "Select your current student group",
        // width: MediaQuery.of(context).size.width,
        width: MediaQuery.of(context).size.width * .5 - 20,
        inputDecorationTheme: inputDecorationTheme,
      ),
      DropdownMenu<UserSemester>(
        initialSelection: semester,
        onSelected:
            _baseInfoFulfilled((UserSemester? newValue) => semester = newValue),
        dropdownMenuEntries: UserSemester.values.map((UserSemester semester) {
          return DropdownMenuEntry<UserSemester>(
            value: semester,
            label: semester.name.toUpperCase(),
          );
        }).toList(),
        label: const Text("Semester"),
        hintText: "Select your current semester",
        width: MediaQuery.of(context).size.width * .5 - 20,
        inputDecorationTheme: inputDecorationTheme,
      ),
      TextField(
        controller: lCOCSController,
        onSubmitted: (value) => lCOCSAdd(),
        decoration: inputDecoration.copyWith(
          labelText: "Courses",
          hintText: "Enter your currently learning courses ID/name",
          suffixIcon: IconButton(
            onPressed: lCOCSAdd,
            icon: const Icon(Symbols.add),
          ),
        ),
      ),
      // list added entries within a container (Chip), background primary with opacity 5%, and an x on the right of each entry
      Wrap(
        spacing: 8,
        children: inLearningCourses.map((e) {
          return Chip(
            label: Text(e),
            backgroundColor: Theme.of(context).primaryColor.withOpacity(0.05),
            deleteIcon: const Icon(Symbols.close),
            onDeleted: () => lCOCSRemove(e),
          );
        }).toList(),
      ),
      TextField(
        onChanged: (value) => major = value,
        decoration: inputDecoration.copyWith(
          labelText: "Major/Field of Study",
          hintText:
              "Enter your major/field of study (or intended major if undecided)",
        ),
      ),
      TextField(
        onChanged: (value) => majorClass = value,
        decoration: inputDecoration.copyWith(
          labelText: "Major Class ID/name",
          hintText: "Enter your major class ID/name",
        ),
      ),
      TextField(
        onChanged: (value) => majorCred = int.parse(value),
        decoration: inputDecoration.copyWith(
          labelText: "Graduation Credits",
          hintText:
              "Enter your school major/field of study standard/minimum credit requirement for graduation",
        ),
        keyboardType: TextInputType.number,
      ),
      TextField(
        onChanged: (value) => credits = int.parse(value),
        decoration: inputDecoration.copyWith(
          labelText: "Your credits",
          hintText: "Enter your total credits earned so far",
        ),
        keyboardType: TextInputType.number,
      ),
      TextField(
        onChanged: (value) => dataUrl = value,
        decoration: inputDecoration.copyWith(
          labelText: "Host url",
          hintText: "https:///...",
        ),
      )
    ];

    Widget pcf(Widget w, double d) => SizedBox(
          width: MediaQuery.of(context).size.width * d - 20,
          child: w,
        );

    Widget pcf2(Widget w) => pcf(w, 0.5);

    Widget rowMid(Widget a, Widget b) =>
        Row(children: [a, MWds.vDivider(8), b]);
    Widget rowPcfRat(Widget wa, Widget wb, double d) =>
        rowMid(pcf(wa, d), pcf(wb, 1 - d));
    Widget rowPcf2(Widget wa, Widget wb) => rowMid(pcf2(wa), pcf2(wb));

    Text label(String data) => Text(
          data,
          style: textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w500,
            color: colorScheme.onSurface,
          ),
        );

    Widget separated(List<Widget> children) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: List.generate(children.length * 2, (index) {
          return index % 2 == 0 ? children[index ~/ 2] : MWds.divider(12);
        }),
      );
    }

    List<Widget> content = [
      label("(Optional) Host server url"),
      fields[fields.length - 1],
      label("Personal info"),
      rowPcfRat(fields[0], fields[1], .4),
      rowPcf2(fields[3], fields[4]),
      rowPcf2(fields[5], fields[6]),
      AnimatedCrossFade(
        duration: const Duration(milliseconds: 300),
        crossFadeState:
            fulfillQuery ? CrossFadeState.showSecond : CrossFadeState.showFirst,
        firstCurve: Curves.easeInOut,
        secondCurve: Curves.easeInOut,
        sizeCurve: Curves.easeInOut,
        firstChild: SizedBox(width: MediaQuery.of(context).size.width),
        secondChild: AnimatedCrossFade(
          duration: const Duration(milliseconds: 300),
          crossFadeState: queryFetched
              ? CrossFadeState.showSecond
              : CrossFadeState.showFirst,
          firstCurve: Curves.easeInOut,
          secondCurve: Curves.easeInOut,
          sizeCurve: Curves.easeInOut,
          alignment: Alignment.center,
          firstChild: const Center(
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: SizedBox(
                width: 48,
                height: 48,
                child: CircularProgressIndicator(),
              ),
            ),
          ),
          secondChild: separated([
            label("Academic info"),
            Container(
              decoration: BoxDecoration(
                border: Border.fromBorderSide(roundedBorder.borderSide),
                borderRadius: roundedBorder.borderRadius,
              ),
              width: MediaQuery.of(context).size.width - 32,
              height: 360,
              child: Column(children: [
                TextField(
                  textAlignVertical: TextAlignVertical.center,
                  autofocus: true,
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.fromLTRB(16, 16, 4, 16),
                    hintText: "Select your courses",
                    prefixIcon: Icon(Symbols.search, size: 28),
                  ),
                  onChanged: (k) => setState(() {
                    query = k.toLowerCase();
                    filteredData = k.isEmpty
                        ? inLearningCourses
                        : queryData.entries
                            .where((e) => e.value.value.contains(query))
                            .map((e) => e.key)
                            .toList();
                  }),
                ),
                SizedBox(
                  height: 300,
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      if (filteredData.isEmpty) {
                        return const Align(
                          alignment: Alignment.topCenter,
                          child: Padding(
                            padding: EdgeInsets.all(16),
                            child: Text("Type anything to start..."),
                          ),
                        );
                      }
                      String key = filteredData[index];

                      return ListTile(
                        title: Text(key),
                        subtitle: Text(queryData[key]!.key),
                        onTap: () => inLearningCourses.contains(key)
                            ? lCOCSRemove(key)
                            : lCOCSAdd(key),
                        leading: Container(
                          width: 48,
                          height: 48,
                          alignment: Alignment.center,
                          child: Checkbox(
                            value: inLearningCourses.contains(key),
                            onChanged: null,
                          ),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 8,
                          horizontal: 16,
                        ),
                      );
                    },
                    itemCount: query.isEmpty
                        ? inLearningCourses.isEmpty
                            ? 1
                            : inLearningCourses.length
                        : filteredData.length,
                    physics: const AlwaysScrollableScrollPhysics(),
                  ),
                ),
              ]),
            ),
            fields[9],
            rowPcf2(fields[12], fields[11]),
            TextButton.icon(
              // onPressed: value,
              icon: const Icon(Symbols.check),
              label: const Text("Verify"),
              style: style,
              onPressed: () async {
                for (var field in [
                  id,
                  name,
                  group,
                  semester,
                  schoolYear,
                  currentSchoolYear,
                  inLearningCourses.firstOrNull
                ]) {
                  if (field == null) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text("Required fields are not fulfilled!"),
                    ));
                    return;
                  }
                }
                List<List<List<String>>> learningCourses = List.generate(
                  currentSchoolYear!,
                  (i) => List.generate(UserSemester.values.length, (j) => []),
                );
                learningCourses[currentSchoolYear! - 1][semester!.index] =
                    inLearningCourses;
                await Storage().clear();
                if (dataUrl.isEmpty) return;
                try {
                  Uri uri = Uri.parse(dataUrl);
                  for (var entry in ({
                    Config.env.fetchDomain: uri.authority,
                    Config.env.apiPrefix: uri.path,
                  }).entries) {
                    await Storage().setEnv(entry.key, entry.value);
                  }
                } catch (_) {}
                await Storage().setUser({
                  "id": id,
                  "name": name,
                  "picture": pictureUri,
                  "group": group?.index,
                  "semester": semester?.index,
                  "schoolYear": schoolYear,
                  "learning": learningCourses,
                  "major": major,
                  "majorClass": majorClass,
                  "majorCred": majorCred,
                  "credits": credits,
                });
                await Restart.restartApp();
              },
            )
          ]),
        ),
      ),
    ];

    return SettingsBase(
      label: "Import manually",
      children: [
        Container(
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: separated(content),
        )
      ],
    );
  }
}
