import 'package:flutter/material.dart';
import 'package:student/ui/navigator/home.dart';
import 'package:student/ui/navigator/school.dart';
import 'package:student/ui/navigator/student.dart';
import 'package:student/ui/navigator/timetable.dart';


class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  int _selectedTab = 0;
  final List<int> _visitedTabs = [];
  // final Map<int, Widget> _defaultRoutes = {0: const Home()};
  // final Map<int, Widget> _defaultRoutes = {0: const Timetable()};
  final List<Widget> _defaultRoutes = [
    HomePage(),
    TimetablePage(),
    SchoolPage(),
    StudentPage(),
  ];

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
      if (_visitedTabs.isNotEmpty) _selectedTab = _visitedTabs.last;
    });
  }

  @override
  Widget build(BuildContext context) {
    // ColorScheme colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      body: PopScope(
        onPopInvoked: (bool didPop) {
          if (didPop) callGoBack();
        },
        child: SafeArea(child: _defaultRoutes[_selectedTab]),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedTab,
        onDestinationSelected: _onItemTapped,
        destinations: const <NavigationDestination>[
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            label: "Home",
          ),
          NavigationDestination(
            icon: Icon(Icons.calendar_month_outlined),
            label: "Time table",
          ),
          NavigationDestination(
            icon: Icon(Icons.school_outlined),
            label: "School",
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outlined),
            label: "Student",
          ),
        ],
      ),
    );
  }
}
