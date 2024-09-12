import 'package:flutter/material.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';

class EventPage extends StatelessWidget {
  final String label;
  final String title;
  final String? subtitle;
  final List<Widget> children;
  final Map<String, double>? padding;
  const EventPage({
    super.key,
    required this.label,
    required this.title,
    this.subtitle,
    required this.children,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    // ColorScheme colorScheme = Theme.of(context).colorScheme;
    // TextTheme textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          onPressed: Navigator.of(context).pop,
          icon: const Icon(Symbols.arrow_back, size: 28),
        ),
        title: Text(
          label,
          textAlign: TextAlign.center,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.headlineSmall,
          maxLines: 3,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(children: [
          Container(
            padding: EdgeInsets.only(
              top: padding?["top"] ?? 64,
              bottom: padding?["bottom"] ?? 32,
              left: padding?["left"] ?? 16,
              right: padding?["right"] ?? 16,
            ),
            alignment: Alignment.centerLeft,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.displaySmall,
                  textAlign: TextAlign.left,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 3,
                ),
                if (subtitle != null)
                  Text(
                    subtitle!,
                    style: Theme.of(context).textTheme.labelLarge,
                    maxLines: 3,
                    textAlign: TextAlign.left,
                  ),
              ],
            ),
          ),
          ...children,
        ]),
      ),
    );
  }
}
