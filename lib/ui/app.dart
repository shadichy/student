import 'package:flutter/material.dart';
import 'package:student/core/routing.dart';
import 'package:student/ui/components/navigator/navigator.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  int _selectedTab = 0;
  final List<int> _visitedTabs = [];
  final List<TypicalPage> _defaultRoutes = Routing.mainNavigators;

  void callbackAdd(int page) {
    setState(() => _visitedTabs.add(page));
    // print(lastVisited);
  }

  void _onItemTapped(int t) {
    setState(() {
      _selectedTab = t;
      if (t == 0) {
        _visitedTabs.clear();
      }
    });
    callbackAdd(t);
  }

  // void goBack(int t) {
  //   if (t == 0) lastVisited.clear();
  //   lastVisited.add(t);
  // }

  void callGoBack() {
    setState(() {
      _visitedTabs.removeLast();
      _selectedTab = _visitedTabs.isNotEmpty ? _visitedTabs.last : 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    // ColorScheme colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      body: PopScope(
        canPop: _visitedTabs.isEmpty,
        onPopInvoked: (didPop) => callGoBack(),
        child: SafeArea(child: _defaultRoutes[_selectedTab]),
      ),
      // appBar: AppBar(
      //   toolbarHeight: 72,
      //   elevation: 0,
      //   scrolledUnderElevation: 4,
      //   surfaceTintColor: Colors.transparent,
      //   shadowColor: colorScheme.shadow,
      //   flexibleSpace: HomeTopBar(),
      // ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedTab,
        onDestinationSelected: _onItemTapped,
        // destinations: const <NavigationDestination>[
        //   NavigationDestination(
        //     icon: Icon(Symbols.home),
        //     label: "Home",
        //   ),
        //   NavigationDestination(
        //     icon: Icon(Symbols.calendar_month),
        //     label: "Time table",
        //   ),
        //   NavigationDestination(
        //     icon: Icon(Symbols.school),
        //     label: "School",
        //   ),
        //   NavigationDestination(
        //     icon: Icon(Symbols.person),
        //     label: "Student",
        //   ),
        // ],
        destinations: List.generate(_defaultRoutes.length, (_) {
          return NavigationDestination(
            icon: _defaultRoutes[_].icon,
            label: _defaultRoutes[_].title,
          );
        }),
      ),
    );
  }
}
