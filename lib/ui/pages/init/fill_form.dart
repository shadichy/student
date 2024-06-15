import 'package:flutter/material.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:restart_app/restart_app.dart';
import 'package:student/core/databases/hive.dart';
import 'package:student/core/databases/user.dart';
import 'package:student/misc/misc_widget.dart';

class FillForm extends StatefulWidget {
  const FillForm({super.key});

  @override
  State<FillForm> createState() => _FillFormState();
}

class _FillFormState extends State<FillForm> {
  TextEditingController lCOCSController = TextEditingController();
  void lCOCSAdd() {
    setState(() {
      inLearningCourses.add(lCOCSController.text);
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

    InputDecoration inputDecoration =
        const InputDecoration().applyDefaults(inputDecorationTheme);

    ButtonStyle style = TextButton.styleFrom(
      backgroundColor: colorScheme.primaryContainer,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.all(16),
      fixedSize: Size.fromWidth(MediaQuery.of(context).size.width),
      textStyle: textStyle,
    );
    Map<String, void Function()> btnMap = {
      "Cancel": () {
        Navigator.pop(context);
      },
      "Submit": () {
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
            (i) => List.generate(UserSemester.values.length, (j) => []));
        learningCourses[currentSchoolYear! - 1][semester!.index] =
            inLearningCourses;
        Storage().setUser({
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
        }).then((_) => Restart.restartApp());
      }
    };

    List<Widget> fields = [
      TextField(
        onChanged: (value) => id = value,
        decoration: inputDecoration.copyWith(
          labelText: "Student ID",
          hintText: "Enter your ID",
        ),
      ),
      TextField(
        onChanged: (value) => name = value,
        decoration: inputDecoration.copyWith(
          labelText: "Name",
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
        onChanged: (value) => schoolYear = int.parse(value),
        decoration: inputDecoration.copyWith(
          labelText: "Enroll School Year",
          hintText: "Enter your school school age at the time you enrolled",
        ),
        keyboardType: TextInputType.number,
      ),
      TextField(
        onChanged: (value) => currentSchoolYear = int.parse(value),
        decoration: inputDecoration.copyWith(
          labelText: "Current School Year",
          hintText: "Enter your current school year (e.g year 1, 2)",
        ),
        keyboardType: TextInputType.number,
      ),
      DropdownMenu<UserGroup>(
        initialSelection: group,
        onSelected: (UserGroup? newValue) => group = newValue,
        dropdownMenuEntries: UserGroup.values.map((UserGroup group) {
          return DropdownMenuEntry<UserGroup>(
            value: group,
            label: group.name.toUpperCase(),
          );
        }).toList(),
        label: const Text("Current Group"),
        hintText: "Select your current student group",
        width: MediaQuery.of(context).size.width,
        inputDecorationTheme: inputDecorationTheme,
      ),
      DropdownMenu<UserSemester>(
        initialSelection: semester,
        onSelected: (UserSemester? newValue) => semester = newValue,
        dropdownMenuEntries: UserSemester.values.map((UserSemester semester) {
          return DropdownMenuEntry<UserSemester>(
            value: semester,
            label: semester.name.toUpperCase(),
          );
        }).toList(),
        label: const Text("Current Semester"),
        hintText: "Select your current semester",
        width: MediaQuery.of(context).size.width,
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
          labelText: "Major/Field of Study (or intended major if undecided)",
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
          labelText: "Major Graduation Credits",
          hintText:
              "Enter your school major/field of study standard/minimum credit requirement for graduation",
        ),
        keyboardType: TextInputType.number,
      ),
      TextField(
        onChanged: (value) => credits = int.parse(value),
        decoration: inputDecoration.copyWith(
          labelText: "Total Credits Earned",
          hintText: "Enter your total credits earned so far",
        ),
        keyboardType: TextInputType.number,
      ),
    ];

    List<Widget> content = [
      ...fields.map(
        (f) => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: f,
        ),
      ),
      Row(
        children: btnMap
            .map((key, value) {
              return MapEntry(
                key,
                SizedBox(
                  width: MediaQuery.of(context).size.width / 2,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: TextButton(
                      onPressed: value,
                      style: style,
                      child: Text(key),
                    ),
                  ),
                ),
              );
            })
            .values
            .toList(),
      ),
    ];
    return Scaffold(
      appBar: AppBar(
        title: const Text("Fill your info"),
      ),
      body: SingleChildScrollView(
        child: ListView.separated(
          itemBuilder: (c, i) => content[i],
          separatorBuilder: (c, i) => MWds.divider(8),
          itemCount: content.length,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
        ),
      ),
    );
  }
}
