import 'package:flutter/material.dart';
import 'package:student/core/routing.dart';
import 'package:student/ui/components/navigator/navigator.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  int _t = 0;
  final List<TypicalPage> _nav = Routing.mainNavigators;

  void _onItemTapped(int t) => setState(() => _t = t);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: _nav[_t]),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _t,
        onDestinationSelected: _onItemTapped,
        destinations: List.generate(_nav.length, (i) {
          return NavigationDestination(
            icon: _nav[i].icon,
            label: _nav[i].title,
          );
        }),
      ),
      drawer: const Drawer(),
    );
  }
}
