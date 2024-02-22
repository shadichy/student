import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:student/ui/navigator/home.dart';
import 'package:student/ui/navigator/school.dart';
import 'package:student/ui/navigator/student.dart';
import 'package:student/ui/navigator/timetable.dart';

class App extends StatelessWidget {
  const App({super.key});
  ThemeData _buildTheme() {
    ThemeData baseTheme = ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.deepPurple,
        brightness: Brightness.light,
      ),
      useMaterial3: true,
    );

    return baseTheme.copyWith(
      textTheme: GoogleFonts.getTextTheme("Varela Round", baseTheme.textTheme),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: _buildTheme(),
      home: const Main(),
    );
  }
}

class Main extends StatefulWidget {
  const Main({super.key});

  @override
  State<Main> createState() => _MainState();
}

class _MainState extends State<Main> {
  int _selectedTab = 0;
  final List<int> _visitedTabs = [];
  // final Map<int, Widget> _defaultRoutes = {0: const Home()};
  final List<Widget> _defaultRoutes = const [
    Home(),
    Timetable(),
    School(),
    Student()
  ];
  // final Map<int, Widget> _defaultRoutes = {0: const Timetable()};

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

  @deprecated
  Widget mapRoute(int index) {
    _defaultRoutes[index] = () {
      switch (index) {
        case 1:
          return const Timetable();
        case 2:
          return const School();
        case 3:
          return const Student();
        default:
          return _defaultRoutes[0]!;
      }
    }();
    return _defaultRoutes[index]!;
  }

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: PopScope(
        onPopInvoked: (bool didPop) {
          if (didPop) callGoBack();
        },
        child: _defaultRoutes[_selectedTab],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedTab,
        onDestinationSelected: _onItemTapped,
        destinations: const <NavigationDestination>[
          NavigationDestination(
            icon: Icon(Icons.home),
            label: "Home",
          ),
          NavigationDestination(
            icon: Icon(Icons.calendar_month),
            label: "Time table",
          ),
          NavigationDestination(
            icon: Icon(Icons.school),
            label: "School",
          ),
          NavigationDestination(
            icon: Icon(Icons.person),
            label: "Student",
          ),
        ],
      ),
    );
  }
}
