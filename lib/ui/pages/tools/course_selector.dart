import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:flutter/material.dart';

import 'package:student/ui/components/navigator/navigator.dart';

class ToolsCourseSelectorPage extends StatefulWidget implements TypicalPage {
  const ToolsCourseSelectorPage({super.key});

  @override
  State<ToolsCourseSelectorPage> createState() =>
      _ToolsCourseSelectorPageState();

  @override
  Icon get icon => const Icon(Symbols.calendar_add_on);

  @override
  String get title => "Danh sách môn học kỳ tới";
}

class _ToolsCourseSelectorPageState extends State<ToolsCourseSelectorPage> {
  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    TextTheme textTheme = Theme.of(context).textTheme;
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
      body: const SingleChildScrollView(
        child: Column(
          children: [
            // Container(
            //   margin: const EdgeInsets.symmetric(horizontal: 16),
            //   padding: const EdgeInsets.only(bottom: 8),
            //   height: 64,
            //   child: TextField(
            //     textAlignVertical: TextAlignVertical.center,
            //     decoration: InputDecoration(
            //       contentPadding: EdgeInsets.zero,
            //       prefixIcon: const Icon(Symbols.search),
            //       hintText: widget.hintText,
            //       border: OutlineInputBorder(
            //         borderRadius: BorderRadius.circular(32),
            //         borderSide: BorderSide(color: colorScheme.outlineVariant),
            //       ),
            //       focusedBorder: OutlineInputBorder(
            //         borderRadius: BorderRadius.circular(32),
            //         borderSide: BorderSide(color: colorScheme.outline),
            //       ),
            //     ),
            //     onChanged: onSearch,
            //   ),
            // ),
            // SizedBox(
            //   height: MediaQuery.of(context).size.height / 2,
            //   width: MediaQuery.of(context).size.width * .8,
            //   child: ListView.builder(
            //     itemBuilder: (context, index) => SimpleDialogOption(
            //       child: Padding(
            //         padding: const EdgeInsets.symmetric(horizontal: 8),
            //         child: widget.itemBuilder(context, items[index]),
            //       ),
            //       onPressed: () => Navigator.of(context).pop(items[index]),
            //     ),
            //     itemCount: items.length,
            //     shrinkWrap: true,
            //   ),
            // ),
            ExpansionPanelList(
              // padding: const EdgeInsets.fromLTRB(32.0, 24.0, 32.0, 0.0),
              children: [
              ],
            ),
          ],
        ),
      ),
    );
  }
}
