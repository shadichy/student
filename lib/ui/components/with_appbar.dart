import 'package:flutter/material.dart';

class TopBar extends StatelessWidget implements PreferredSizeWidget {
  final Widget child;
  final double height;
  const TopBar(this.child, {super.key, this.height = 72});

  @override
  Size get preferredSize => Size.fromHeight(height);

  @override
  Widget build(BuildContext context) {
    // ColorScheme colorScheme = Theme.of(context).colorScheme;
    return Container(
      height: height,
      padding: const EdgeInsets.all(16).copyWith(
        top: MediaQuery.paddingOf(context).top + 16,
      ),
      child: child,
    );
  }
}

class WithAppbar extends StatelessWidget {
  final Widget appBar;
  final List<Widget> body;
  final double height;
  const WithAppbar({
    super.key,
    required this.appBar,
    required this.body,
    this.height = 72,
  });

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          automaticallyImplyLeading: false,
          toolbarHeight: height,
          elevation: 0,
          scrolledUnderElevation: 4,
          surfaceTintColor: Colors.transparent,
          shadowColor: colorScheme.shadow,
          floating: true,
          flexibleSpace: TopBar(appBar, height: height),
        ),
        SliverList(delegate: SliverChildListDelegate([Column(children: body)])),
      ],
    );
  }
}
