import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:flutter/material.dart';
import 'package:student/core/routing.dart';
import 'package:student/ui/components/option.dart';

class HomeTopBar extends StatelessWidget {
  const HomeTopBar({super.key});
  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    TextTheme textTheme =
        Theme.of(context).textTheme.apply(bodyColor: colorScheme.onSurface);
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: [
        Expanded(
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16),
            dense: true,
            onTap: () => Routing.goto(context, Routing.search),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            tileColor: colorScheme.primary.withOpacity(0.05),
            leading: Icon(
              Symbols.search,
              color: colorScheme.onSurface,
              size: 20,
            ),
            title: Text(
              "Search",
              style: textTheme.titleMedium,
            ),
          ),
        ),
        // Expanded(
        //   flex: 1,
        //   child: Container(
        //     decoration: BoxDecoration(
        //       borderRadius: BorderRadius.circular(30),
        //       color: colorScheme.surfaceVariant,
        //     ),
        //     child: InkWell(
        //       onTap: () => Options.search.target(context),
        //       borderRadius: BorderRadius.circular(30),
        //       child: Padding(
        //         padding:
        //             const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        //         child: Row(
        //           children: [
        //             Icon(
        //               const Icon(Symbols.search),
        //               color: colorScheme.onSurfaceVariant,
        //               size: 20,
        //             ),
        //             const SizedBox(width: 8),
        //             Text(
        //               "Search",
        //               style: TextStyle(
        //                 color: colorScheme.onSurfaceVariant,
        //                 fontSize: 16,
        //               ),
        //             ),
        //           ],
        //         ),
        //       ),
        //     ),
        //   ),
        // ),
        const VerticalDivider(
          width: 4,
          color: Colors.transparent,
        ),
        SizedBox(
          height: 32,
          width: 32,
          child: IconOption(
            'notif',
            iconSize: 20,
            padding: EdgeInsets.zero,
            color: colorScheme.onSurface,
            backgroundColor: colorScheme.surface,
          ),
        ),
        const VerticalDivider(
          width: 4,
          color: Colors.transparent,
        ),
        SizedBox(
          height: 32,
          width: 32,
          child: IconButton(
            icon: const Icon(Symbols.menu),
            onPressed: Scaffold.of(context).openDrawer,
            iconSize: 20,
            padding: EdgeInsets.zero,
            color: colorScheme.onSurface,
            style: IconButton.styleFrom(
              backgroundColor: colorScheme.surface,
            ),
          ),
        ),
      ],
    );
  }
}
