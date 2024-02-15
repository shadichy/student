import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Glance extends StatefulWidget {
  final Image image;
  final String name;
  const Glance(this.image, this.name, {super.key});

  @override
  State<Glance> createState() => _GlanceState();
}

class _GlanceState extends State<Glance> {
  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      padding: const EdgeInsets.all(16),
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: colorScheme.tertiaryContainer,
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: colorScheme.onTertiaryContainer,
                width: 2.0,
              ),
            ),
            child: Container(
              margin: const EdgeInsets.all(4),
              height: 120,
              width: 120,
              clipBehavior: Clip.antiAlias,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
              ),
              child: widget.image,
            ),
          ),
          Expanded(
            // height: 100,
            // width: MediaQuery.of(context).size.width,
            child: ListTile(
              title: Text(
                "Welcome back,",
                style: GoogleFonts.comfortaa(
                  fontSize: 24,
                  color: colorScheme.onTertiaryContainer,
                  fontWeight: FontWeight.w900,
                ),
                textAlign: TextAlign.start,
              ),
              subtitle: Text(
                widget.name,
                style: GoogleFonts.comfortaa(
                  fontSize: 18,
                  color: colorScheme.onTertiaryContainer.withOpacity(.95),
                ),
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
