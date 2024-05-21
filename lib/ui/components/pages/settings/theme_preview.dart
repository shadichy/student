import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:student/misc/misc_functions.dart';

class ThemePreviewBox extends StatelessWidget {
  final ColorScheme colorScheme;
  const ThemePreviewBox(this.colorScheme, {super.key});

  @override
  Widget build(BuildContext context) {
    List<String> colors = [
      colorScheme.primaryContainer,
      colorScheme.primary,
      colorScheme.onSurface,
    ].map((color) {
      return MiscFns.colorCode(color);
    }).toList();

    List<String> preview = [
      '<svg width="360" height="640" xmlns="http://www.w3.org/2000/svg"><rect width="320" height="120" x="20" y="100" rx="30" fill="#${colors[0]}" fill-opacity="1"/><rect width="240" height="115" x="20" y="330" rx="20.002" fill="#${colors[0]}" fill-opacity="1"/><path d="M360 330h-59.998A19.958 19.958 0 00280 350.002v74.996A19.958 19.958 0 00300.002 445H360z" fill="#${colors[0]}" fill-opacity="1"/><g fill="#${colors[1]}" fill-opacity=".05"><rect width="200" height="60" x="20" y="20" rx="30"/><rect width="320" height="70" x="20" y="240" rx="20"/><rect width="360" height="80" y="560" rx="0"/></g><g fill="#${colors[2]}" fill-opacity=".1"><circle cx="259.977" cy="50" r="20"/><circle cx="310" cy="50" r="20"/><circle cx="40" cy="520" r="20"/><rect width="120" height="26.25" x="20" y="465" rx="7.5"/><rect width="180" height="20" x="70" y="510" ry="5"/><rect width="175" height="38.281" x="40" y="125" rx="10.938"/><rect width="180" height="20" x="40" y="360" ry="5"/></g></svg>',
      '<svg width="360" height="640" xmlns="http://www.w3.org/2000/svg"><rect width="360" height="80" y="560" rx="0" fill="#${colors[1]}" fill-opacity=".05"/><circle cx="60" cy="130" r="20" fill="#${colors[2]}" fill-opacity=".1"/><rect width="180" height="20" x="90" y="110" ry="5" fill="#${colors[2]}" fill-opacity=".1"/><g fill="#${colors[2]}" fill-opacity=".1"><circle cx="40" cy="50" r="20"/><circle cx="320" cy="50" r="20"/><rect width="120" height="26.25" x="120" y="36.875" rx="7.5"/><rect width="180" height="20" x="20" y="290" ry="5"/></g><circle cx="60" cy="230" r="20" fill="#${colors[2]}" fill-opacity=".1"/><rect width="180" height="20" x="90" y="210" ry="5" fill="#${colors[2]}" fill-opacity=".1"/><g fill="#${colors[0]}"><rect width="320" height="80" x="20" y="90" rx="15"/><rect width="320" height="80" x="20" y="190" rx="15"/><path d="M40.002 330A19.958 19.958 0 0020 350.002V400h320v-49.998A19.958 19.958 0 00319.998 330H40.002zM20 400v160h320V400H25v5h310v150H25V400z"/></g></svg>'
    ];

    double width = MediaQuery.of(context).size.width;

    return Container(
      width: width,
      margin: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      child: Row(
        children: List.generate(preview.length, (s) {
          double baseWidth = width / 2 - 24;
          return Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: Theme.of(context).colorScheme.outlineVariant,
                width: 4,
              ),
              color: colorScheme.surface,
            ),
            width: baseWidth,
            height: baseWidth * 1.76,
            margin: const EdgeInsets.symmetric(horizontal: 8),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: SvgPicture.string(preview[s]),
            ),
          );
        }),
      ),
    );
  }
}
