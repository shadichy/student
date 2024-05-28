import 'package:flutter/material.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:student/core/databases/hive.dart';
import 'package:student/core/databases/user.dart';

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
      borderRadius: BorderRadius.circular(16),
      borderSide: BorderSide(color: colorScheme.primary.withOpacity(0.05)),
    );

    InputDecoration inputDecoration = InputDecoration(
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
      enabledBorder: roundedBorder,
      focusedBorder: roundedBorder,
      hintStyle:
          textTheme.bodyLarge?.apply(color: colorScheme.onSurfaceVariant),
      labelStyle:
          textTheme.bodyLarge?.apply(color: colorScheme.onPrimaryContainer),
    );

    ButtonStyle style = TextButton.styleFrom(
      backgroundColor: colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.all(16),
      fixedSize: Size.fromWidth(MediaQuery.of(context).size.width),
    );
    Map<String, void Function()> btnMap = {
      "Cancel": () {
        Navigator.pop(context);
      },
      "Submit": () {
        List<List<List<String>>> learningCourses = List.generate(currentSchoolYear!, (i)=>List.generate(UserSemester.values.length, (j)=>[]));
        learningCourses[currentSchoolYear!-1][semester!.index] = inLearningCourses;
        Storage().setUser({
          "id": id,
          "name": name,
          "picture": pictureUri,
          "group": group?.index,
          "semester": semester?.index,
          "schoolYear": schoolYear,
          "learningCourses": learningCourses,
          "major": major,
          "majorClass": majorClass,
          "majorCred": majorCred,
          "credits": credits,
        });
      }
    };

    return Scaffold(
      appBar: AppBar(
        title: const Text("Fill your info"),
      ),
      body: SingleChildScrollView(
        child: Column(children: [
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
              hintText:
                  "Enter your photo URL (e.g. https://example.com/image.jpg)",
            ),
          ),
          TextField(
            onChanged: (value) => schoolYear = int.parse(value),
            decoration: inputDecoration.copyWith(
              labelText: "Enroll School Year",
              hintText:
                  "Enter your school school age at the time you enrolled",
            ),
            keyboardType: TextInputType.number,
          ),
          TextField(
            onChanged: (value) => currentSchoolYear = int.parse(value),
            decoration: inputDecoration.copyWith(
              labelText: "Current School Year",
              hintText:
              "Enter your current school year (e.g year 1, 2)",
            ),
            keyboardType: TextInputType.number,
          ),
          DropdownMenu<UserGroup>(
            initialSelection: group,
            onSelected: (UserGroup? newValue) => group = newValue,
            dropdownMenuEntries: UserGroup.values.map((UserGroup group) {
              return DropdownMenuEntry<UserGroup>(
                value: group,
                label: group.name,
              );
            }).toList(),
          ),
          DropdownMenu<UserSemester>(
            initialSelection: semester,
            onSelected: (UserSemester? newValue) => semester = newValue,
            dropdownMenuEntries:
                UserSemester.values.map((UserSemester semester) {
              return DropdownMenuEntry<UserSemester>(
                value: semester,
                label: semester.name,
              );
            }).toList(),
          ),
          TextField(
            controller: lCOCSController,
            onSubmitted: (value) => lCOCSAdd(),
            decoration: inputDecoration.copyWith(
              labelText: "Courses",
              hintText: "Enter your currently learning courses ID/name",
              suffixIcon: IconButton(
                onPressed: lCOCSAdd,
                icon: Icon(Symbols.add),
              ),
            ),
          ),
          Wrap(
            spacing: 8,
            children: inLearningCourses.map((e) => Text(e)).toList(),
          ),
          TextField(
            onChanged: (value) => major = value,
            decoration: inputDecoration.copyWith(
              labelText:
                  "Major/Field of Study (or intended major if undecided)",
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
        ]),
      ),
    );
  }
}
