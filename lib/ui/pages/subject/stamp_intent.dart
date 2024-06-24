import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:student/core/databases/hive.dart';
import 'package:student/core/notification/alarm.dart';

Widget _colMin(List<Widget> children) => Column(
      mainAxisSize: MainAxisSize.min,
      children: children,
    );

Widget _div([double height = 8]) =>
    Divider(color: Colors.transparent, height: height);

Widget _separated(List<Widget> children, [double gap = 12]) {
  return _colMin(List.generate(children.length * 2 - 1, (index) {
    return index % 2 == 0 ? children[index ~/ 2] : _div(gap);
  }));
}

Future<void> _runStop(BuildContext context, int id) async {
  try {
    if (context.mounted && Navigator.canPop(context)) {
      Navigator.pop(context);
    } else {
      throw Exception();
    }
  } catch (_) {
    await SystemNavigator.pop();
  }
  await Storage().register();
  await Storage().initializeMinimal();
  await Alarm.stop(id);
}

class AlarmApp extends StatelessWidget {
  static const seedColor = "seedColor";
  static const font = "font";
  static const themeMode = "themeMode";
  static const eventTitle = "eventTitle";
  static const eventSubtitle = "eventSubtitle";
  static const startTime = "startTime";
  static const location = "location";
  static const id = "id";

  final Map data;

  const AlarmApp(this.data, {super.key});

  @override
  Widget build(BuildContext context) {
    Color seed = Color(data[AlarmApp.seedColor] as int);
    String? font = data[AlarmApp.font];
    ThemeData buildTheme(Brightness brightness) {
      ColorScheme colorScheme = ColorScheme.fromSeed(
        seedColor: seed,
        brightness: brightness,
      );
      Color bgColor = colorScheme.primary.withOpacity(0.05);
      Color textColor = colorScheme.onSurface;
      ThemeData baseTheme = ThemeData(
        brightness: brightness,
        colorScheme: colorScheme,
        useMaterial3: true,
        splashColor: bgColor,
        hoverColor: bgColor,
        focusColor: bgColor,
        highlightColor: bgColor,
        // scaffoldBackgroundColor: colorScheme.surface,
        cardTheme: CardTheme(
          color: bgColor,
          margin: const EdgeInsets.symmetric(horizontal: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      );
      return baseTheme.copyWith(
        textTheme: (font != null
                ? GoogleFonts.getTextTheme(font, baseTheme.textTheme)
                : baseTheme.textTheme)
            .apply(
          displayColor: textColor,
          bodyColor: textColor,
        ),
      );
    }

    return MaterialApp(
      title: "Student alarm",
      theme: buildTheme(Brightness.light),
      darkTheme: buildTheme(Brightness.dark),
      themeMode: ThemeMode.values[data[AlarmApp.themeMode] as int],
      home: AlarmIntent(data),
    );
  }
}

class AlarmIntent extends StatefulWidget {
  final Map data;

  const AlarmIntent(this.data, {super.key});

  @override
  State<AlarmIntent> createState() => _AlarmIntentState();
}

class _AlarmIntentState extends State<AlarmIntent> {
  double dx = 80;
  bool inSwipe = false;
  double maxSize = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    maxSize = MediaQuery.of(context).size.width - 64;
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    TextTheme textTheme = Theme.of(context).textTheme;
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Container(
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: _separated([
              _separated([
                Text(
                  widget.data[AlarmApp.eventTitle],
                  textAlign: TextAlign.center,
                  style: textTheme.displayMedium?.copyWith(
                    color: colorScheme.onSurface,
                  ),
                ),
                Text(
                  widget.data[AlarmApp.eventSubtitle],
                  textAlign: TextAlign.center,
                  style: textTheme.headlineSmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ], 4),
              _colMin([
                Text(
                  "Start at",
                  style: textTheme.titleLarge?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
                Text(
                  widget.data[AlarmApp.startTime],
                  style: textTheme.displayLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                    fontSize: 144,
                    color: colorScheme.onSurface,
                  ),
                ),
                Text(
                  widget.data[AlarmApp.location],
                  style: textTheme.displayMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                    fontSize: 70,
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ]),
              _separated([
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(40),
                    color: colorScheme.surfaceContainer,
                  ),
                  height: 80,
                  child: Stack(children: [
                    Center(
                      child: Text(
                        "Swipe to dismiss",
                        style: textTheme.labelLarge?.copyWith(
                          fontWeight: FontWeight.w500,
                          color: colorScheme.onPrimaryContainer,
                        ),
                      ),
                    ),
                    Positioned(
                      top: 0,
                      left: 0,
                      // bottom: 0,
                      // right: 0,
                      child: GestureDetector(
                        onPanStart: (details) {
                          setState(() {
                            inSwipe = true;
                          });
                        },
                        onPanUpdate: (details) {
                          // if (details.delta.dx < 0) return;
                          setState(() {
                            if (dx == maxSize) return;
                            dx = details.localPosition.dx;
                            if (dx < 80) dx = 80;
                            if (dx > maxSize) dx = maxSize;
                          });
                        },
                        onPanCancel: () {
                          setState(() => dx = 80);
                        },
                        onPanEnd: (details) {
                          setState(() {
                            inSwipe = false;
                            if (dx >= maxSize) {
                              dx = maxSize;
                              _runStop(
                                context,
                                widget.data[AlarmApp.id] as int,
                              );
                            } else {
                              dx = 80;
                            }
                          });
                        },
                        // behavior: HitTestBehavior.translucent,
                        child: AnimatedSize(
                          alignment: Alignment.centerLeft,
                          duration: Duration(milliseconds: inSwipe ? 0 : 300),
                          curve: Curves.ease,
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(40),
                              color: colorScheme.primary,
                            ),
                            height: 80,
                            width: dx,
                            alignment: Alignment.centerRight,
                            child: Container(
                              height: 80,
                              width: 80,
                              alignment: Alignment.center,
                              child: Icon(
                                Symbols.chevron_right,
                                color: colorScheme.onPrimary,
                                size: 48,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ]),
                ),
                TextButton(
                  onPressed: () => _runStop(
                    context,
                    widget.data[AlarmApp.id] as int,
                  ),
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    // foregroundColor: colorScheme.onSurface,
                    surfaceTintColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    overlayColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      side: BorderSide(
                        color: colorScheme.outline,
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                  child: Text(
                    "Remind me in 5 minutes",
                    style: textTheme.labelLarge?.copyWith(
                      fontWeight: FontWeight.w500,
                      color: colorScheme.primary,
                    ),
                  ),
                ),
              ], 32),
            ], 80),
          ),
        ),
      ),
    );
  }
}
