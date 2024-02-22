import 'package:flutter/material.dart';
import 'package:student/ui/components/option.dart';
import 'package:student/ui/components/options.dart';

class HomeTopBar extends StatefulWidget {
  const HomeTopBar({super.key});

  @override
  State<HomeTopBar> createState() => _HomeTopBarState();
}

class _HomeTopBarState extends State<HomeTopBar> {
  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          IconOption(
            Option(Icons.menu, "", Scaffold.of(context).openDrawer),
            padding: const EdgeInsets.all(4),
            iconSize: 28,
            iconColor: colorScheme.onSurface,
            backgroundColor: colorScheme.surface,
          ),
          Expanded(
            flex: 1,
            child: ElevatedButton(
              onPressed: Options.search.target,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                backgroundColor: colorScheme.surfaceVariant,
                elevation: 0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Text(
                    "Search",
                    style: TextStyle(
                      color: colorScheme.onSurfaceVariant,
                      fontSize: 16,
                    ),
                  ),
                  Icon(
                    Icons.search,
                    color: colorScheme.onSurfaceVariant,
                    size: 24,
                  ),
                ],
              ),
            ),
          ),
          IconOption(
            Options.notifications,
            padding: const EdgeInsets.all(4),
            iconSize: 28,
            iconColor: colorScheme.onSurface,
            backgroundColor: colorScheme.surface,
          ),
        ],
      ),
    );
  }
}

            //       Container(
            //         padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
            //         height: 48,
            //         decoration: BoxDecoration(borderRadius: BorderRadius.circular(24)),
            //         color: colorScheme.secondaryContainer.withOpacity(.5),
            // child: Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //   crossAxisAlignment: CrossAxisAlignment.center,
            //   mainAxisSize: MainAxisSize.max,
            //   children: [Text("Search", style: TextStyle(color: colorScheme.onSecondaryContainer,fontSize: 14,),),],
            // )
            //       ),
            // TextField(
            //   controller: TextEditingController(),
            //   obscureText: false,
            //   textAlign: TextAlign.start,
            //   maxLines: 1,
            //   style: TextStyle(
            //     fontWeight: FontWeight.w400,
            //     fontSize: 14,
            //     color: colorScheme.onSecondaryContainer,
            //   ),
            //   // const TextStyle(
            //   //   fontWeight: FontWeight.w400,
            //   //   fontStyle: FontStyle.normal,
            //   //   fontSize: 18,
            //   //   color: Color(0xff000000),
            //   // ),
            //   decoration: InputDecoration(
            //     border: OutlineInputBorder(
            //       borderRadius: BorderRadius.circular(24.0),
            //       borderSide:
            //           const BorderSide(color: Colors.transparent),
            //     ),
            //     // focusedBorder: OutlineInputBorder(
            //     //   borderRadius: BorderRadius.circular(24.0),
            //     //   borderSide:
            //     //       const BorderSide(color: Color(0x00000000), width: 1),
            //     // ),
            //     enabledBorder: OutlineInputBorder(
            //       borderRadius: BorderRadius.circular(24.0),
            //       borderSide:
            //           const BorderSide(color: Colors.transparent, width: 1),
            //     ),
            //     labelText: "Search",
            //     // labelStyle: const TextStyle(
            //     //   fontWeight: FontWeight.w400,
            //     //   fontStyle: FontStyle.normal,
            //     //   fontSize: 14,
            //     //   color: Color(0xff000000),
            //     // ),
            //     hintText: "Enter Text",
            //     // hintStyle: const TextStyle(
            //     //   fontWeight: FontWeight.w400,
            //     //   fontStyle: FontStyle.normal,
            //     //   fontSize: 14,
            //     //   color: Color(0xff000000),
            //     // ),
            //     filled: true,
            //     fillColor: colorScheme.secondaryContainer.withOpacity(.5),
            //     isDense: false,
            //     contentPadding:
            //         const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
            //     suffixIcon: Icon(Icons.search,
            //         color: colorScheme.onSecondaryContainer, size: 24,),
            //   ),
            // ),