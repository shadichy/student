import 'package:flutter/material.dart';
import 'package:student/core/databases/user.dart';

class HomeGlance extends StatefulWidget {
  const HomeGlance({super.key});

  @override
  State<HomeGlance> createState() => _HomeGlanceState();
}

class _HomeGlanceState extends State<HomeGlance> {
  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    ColorScheme colorScheme = theme.colorScheme;
    TextTheme textTheme = theme.textTheme.apply(displayColor: colorScheme.onPrimaryContainer,bodyColor: colorScheme.onPrimaryContainer);
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      padding: const EdgeInsets.all(16),
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: colorScheme.primaryContainer,
        // border: Border.all(color: colorScheme.primaryContainer, width:2,),
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          // Container(
          //   width: 80,
          //   height: 80,
          //   decoration: BoxDecoration(
          //     shape: BoxShape.circle,
          //     border: Border.all(
          //       color: colorScheme.onPrimaryContainer,
          //       width: 2.0,
          //     ),
          //   ),
          //   child: Container(
          //     margin: const EdgeInsets.all(4),
          //     height: 120,
          //     width: 120,
          //     clipBehavior: Clip.antiAlias,
          //     decoration: const BoxDecoration(
          //       shape: BoxShape.circle,
          //     ),
          //     child: widget.image,
          //   ),
          // ),
          Expanded(
            // height: 100,
            // width: MediaQuery.of(context).size.width,
            child: ListTile(
              title: Text(
                "Welcome back,",
                style: textTheme.headlineSmall!.copyWith(
                  fontWeight: FontWeight.w500,
                ),
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.start,
              ),
              subtitle: Text(
                User().name,
                style: textTheme.titleMedium,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.start,
              ),
              dense: false,
              contentPadding: const EdgeInsets.only(left: 16),
            ),
          ),
        ],
      ),
    );
  }
}
