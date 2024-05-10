// import 'package:flutter/material.dart';
// import 'package:student/ui/components/option.dart';
// import 'package:student/ui/components/options.dart';

// class OptionIconWidgets extends StatefulWidget {
//   final List<Option> options;
//   const OptionIconWidgets(this.options, {super.key});

//   @override
//   State<OptionIconWidgets> createState() => _OptionIconWidgetsState();
// }

// class _OptionIconWidgetsState extends State<OptionIconWidgets> {
//   @override
//   Widget build(BuildContext context) {
//     ColorScheme colorScheme = Theme.of(context).colorScheme;

//     List<Widget> content = [
//       ...widget.options.map(
//         (Option opt) => IconOption(
//           opt,
//           margin: const EdgeInsets.only(right: 16),
//           padding: const EdgeInsets.all(8),
//           color: colorScheme.onPrimaryContainer,
//           backgroundColor: colorScheme.primaryContainer,
//         ),
//       ),
//       IconOption(
//         Options.add((BuildContext context) {}),
//         padding: const EdgeInsets.all(8),
//         color: colorScheme.onPrimaryContainer,
//         backgroundColor: colorScheme.surface,
//       )
//     ];

//     return SingleChildScrollView(
//       scrollDirection: Axis.horizontal,
//       child: Padding(
//         padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           crossAxisAlignment: CrossAxisAlignment.center,
//           mainAxisSize: MainAxisSize.max,
//           children: content,
//         ),
//       ),
//     );
//   }
// }
