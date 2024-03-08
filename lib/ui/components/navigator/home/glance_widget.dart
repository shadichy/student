import 'package:flutter/material.dart';

class HomeGlance extends StatefulWidget {
  final Image image;
  final String name;
  const HomeGlance(this.image, this.name, {super.key});

  @override
  State<HomeGlance> createState() => _HomeGlanceState();
}

class _HomeGlanceState extends State<HomeGlance> {
  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      padding: const EdgeInsets.all(16),
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: colorScheme.primaryContainer,
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
                color: colorScheme.onPrimaryContainer,
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
                style: TextStyle(
                  fontSize: 24,
                  color: colorScheme.onPrimaryContainer,
                  fontWeight: FontWeight.w700,
                ),
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.start,
              ),
              subtitle: Text(
                widget.name,
                style: TextStyle(
                  fontSize: 18,
                  color: colorScheme.onPrimaryContainer.withOpacity(.95),
                ),
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
