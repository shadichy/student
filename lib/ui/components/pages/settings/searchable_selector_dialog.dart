import 'package:flutter/material.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';

class SearchableSelectorDialog<T> extends StatefulWidget {
  final Widget? title;
  final String? hintText;
  final List<T> items;
  final Widget? Function(BuildContext context, T item) itemBuilder;
  final List<T>? Function(String query, List<T> items) searchMethod;
  const SearchableSelectorDialog({
    super.key,
    this.title,
    required this.items,
    required this.itemBuilder,
    required this.searchMethod,
    this.hintText,
  });

  @override
  State<SearchableSelectorDialog<T>> createState() =>
      _SearchableSelectorDialogState<T>();
}

class _SearchableSelectorDialogState<T>
    extends State<SearchableSelectorDialog<T>> {
  late List<T> items = widget.items;

  void onSearch(String query) {
    setState(() {
      items = widget.searchMethod(query, widget.items) ?? widget.items;
    });
  }

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    TextTheme textTheme = Theme.of(context).textTheme;
    return SimpleDialog(
      title: widget.title,
      titleTextStyle: textTheme.bodyMedium?.copyWith(
        fontWeight: FontWeight.bold,
      ),
      titlePadding: const EdgeInsets.fromLTRB(32.0, 24.0, 32.0, 0.0),
      children: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          padding: const EdgeInsets.only(bottom: 8),
          height: 64,
          child: TextField(
            textAlignVertical: TextAlignVertical.center,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.zero,
              prefixIcon: const Icon(Symbols.search),
              hintText: widget.hintText,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(32),
                borderSide: BorderSide(color: colorScheme.outlineVariant),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(32),
                borderSide: BorderSide(color: colorScheme.outline),
              ),
            ),
            onChanged: onSearch,
          ),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height / 2,
          width: MediaQuery.of(context).size.width * .8,
          child: ListView.builder(
            itemBuilder: (context, index) {
              return SimpleDialogOption(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: widget.itemBuilder(context, items[index]),
                ),
                onPressed: () => Navigator.of(context).pop(items[index]),
              );
            },
            itemCount: items.length,
            shrinkWrap: true,
          ),
        ),
      ],
    );
  }
}
