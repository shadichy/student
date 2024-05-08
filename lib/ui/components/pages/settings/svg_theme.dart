import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:scroll_snap_list/scroll_snap_list.dart';
import 'package:student/misc/misc_functions.dart';
import 'package:student/misc/iterable_extensions.dart';

class SvgIcon extends StatelessWidget {
  final Color primary, container, tertiary;
  final double size;
  const SvgIcon({
    super.key,
    required this.primary,
    required this.container,
    required this.tertiary,
    this.size = 32,
  });

  SvgIcon.fromPalette(
    ColorScheme palette, {
    super.key,
    this.size = 32,
  })  : primary = palette.primaryContainer,
        container = palette.primary,
        tertiary = palette.tertiary;

  @override
  Widget build(BuildContext context) {
    return SvgPicture.string(
      '<svg viewBox="0 0 24 24"><path d="M0 12A12 12 0 0112 0a12 12 0 0112 12H12z" fill="#${MiscFns.colorCode(container)}"/><path d="M12 24a12 12 0 01-8.485-3.515A12 12 0 010 12h12z" fill="#${MiscFns.colorCode(tertiary)}"/><path d="M24 12a12 12 0 01-12 12V12z" fill="#${MiscFns.colorCode(primary)}"/></svg>',
      width: size,
      height: size,
    );
  }
}

class PaletteSelector extends StatefulWidget {
  final void Function(int colorCode)? action;
  const PaletteSelector(this.action, {super.key});

  @override
  State<PaletteSelector> createState() => _PaletteSelectorState();
}

class _PaletteSelectorState extends State<PaletteSelector> {
  @override
  Widget build(BuildContext context) {
    Iterable<Iterable<Color>> colors =
        [...Colors.primaries, ...Colors.accents].chunked(4);

    Widget previewBox(Color color) {
      Widget content = Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          color: Theme.of(context).colorScheme.primary.withOpacity(0.05),
        ),
        child: SvgIcon.fromPalette(ColorScheme.fromSeed(
          seedColor: color,
        )),
      );
      return widget.action != null
          ? InkWell(
              borderRadius: BorderRadius.circular(24),
              onTap: () => widget.action!(color.value),
              child: content,
            )
          : content;
    }

    List<Widget> colorRow = colors.map((chunk) {
      return Container(
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: chunk.map((color) => previewBox(color)).toList(),
        ),
      );
    }).toList();

    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: 96,
      child: ScrollSnapList(
        itemBuilder: (context, index) => colorRow[index],
        itemCount: colorRow.length,
        itemSize: MediaQuery.of(context).size.width,
        onItemFocus: (index) {},
        padding: const EdgeInsets.symmetric(vertical: 16),
        shrinkWrap: true,
        scrollPhysics:
            widget.action != null ? null : const NeverScrollableScrollPhysics(),
      ),
    );
  }
}
