import 'dart:async';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:restart_app/restart_app.dart';
import 'package:student/core/databases/hive.dart';
import 'package:student/core/default_configs.dart';
import 'package:student/core/routing.dart';
import 'package:student/misc/misc_widget.dart';
import 'package:student/ui/pages/init/fill_form.dart';
import 'package:system_theme/system_theme.dart';
// import 'package:student/core/databases/user.dart';

class Initializer extends StatefulWidget {
  const Initializer({super.key});

  @override
  State<Initializer> createState() => _InitializerState();
}

class _InitializerState extends State<Initializer> {
  final MobileScannerController controller = MobileScannerController(
    formats: [BarcodeFormat.qrCode],
    // required options for the scanner
  );

  ColorScheme darkColorScheme = ColorScheme.fromSeed(
    seedColor: Storage().fetch<bool>(Config.theme.systemTheme) == true
        ? SystemTheme.accentColor.accent
        : Color(Storage().fetch<int>(Config.theme.accentColor)!),
    brightness: Brightness.dark,
  );

  void checkValidUser(Map<String, dynamic> data) {
    data["id"] as String;
    data["name"] as String;
    data["group"] as int;
    data["semester"] as int;
    data["schoolYear"] as int;
    data["learning"] as List;
  }

  void showErr(String errMsg, Object e, StackTrace s) {
    // print(s);
    double margSide = MediaQuery.of(context).size.width * .18;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      // width: MediaQuery.of(context).size.width * ,
      // width: 312,
      duration: const Duration(seconds: 10),
      margin: EdgeInsets.only(
        bottom: 136,
        left: margSide,
        right: margSide,
      ),
      dismissDirection: DismissDirection.horizontal,
      backgroundColor: darkColorScheme.surfaceContainer,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      behavior: SnackBarBehavior.floating,
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "An error occurred",
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: darkColorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w500,
                ),
          ),
          MWds.divider(4),
          Text(
            errMsg,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: darkColorScheme.onSurfaceVariant,
                ),
            maxLines: 10,
          )
        ],
      ),
    ));
  }

  void _handleBarcode(BarcodeCapture? barcodes) async {
    if (barcodes == null || !mounted) return;

    Barcode? barcode = barcodes.barcodes.firstOrNull;
    if (barcode == null) return;
    Map parsed;

    try {
      parsed = await Storage().download(Uri.parse(barcode.displayValue!));
    } catch (e, s) {
      return showErr("Please check your internet connection", e, s);
    }

    try {
      checkValidUser(parsed["user"] as Map<String, dynamic>);
    } catch (e, s) {
      return showErr("Invalid QR", e, s);
    }

    if (Storage().initialized) await Storage().clear();

    await Storage().setUser(parsed["user"]);
    if (parsed["env"] != null) {
      for (var entry in (parsed["env"] as Map<String, dynamic>).entries) {
        await Storage().setEnv(entry.key, entry.value);
      }
    }
    await Restart.restartApp();
  }

  @override
  Future<void> dispose() async {
    super.dispose();
    await controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    ButtonStyle style = TextButton.styleFrom(
      backgroundColor: darkColorScheme.primary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(32),
      ),
      // padding: const EdgeInsets.all(16),
      textStyle: textTheme.labelLarge?.apply(
        color: darkColorScheme.onPrimary,
      ),
      fixedSize: Size.fromWidth(MediaQuery.of(context).size.width / 2 - 48),
    );
    Map<MapEntry<String, IconData>, void Function()> btnMap = {
      const MapEntry("Use picture", Symbols.upload): () {
        FilePicker.platform.pickFiles(type: FileType.image).then((f) {
          if (f == null) return;
          controller.analyzeImage(f.files.single.path!).then(_handleBarcode);
        });
      },
      const MapEntry("Fill manually", Symbols.edit): () {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => const FillForm(),
        ));
      }
    };
    return Scaffold(
      backgroundColor: darkColorScheme.surface,
      body: SafeArea(
        child: Stack(children: [
          MobileScanner(
            controller: controller,
            // fit: BoxFit.contain,
            onDetect: _handleBarcode,
          ),
          Positioned(
            bottom: 0,
            child: Container(
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 32),
              color: darkColorScheme.surface.withOpacity(.75),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: btnMap.entries.map((e) {
                  return Padding(
                    padding: const EdgeInsets.all(8),
                    child: TextButton.icon(
                      onPressed: e.value,
                      icon: Icon(e.key.value),
                      label: Text(e.key.key),
                      style: style,
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          Positioned(
            top: 0,
            child: Container(
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 32),
              color: darkColorScheme.surface.withOpacity(.75),
              child: Column(children: [
                Text(
                  "Scan your QR code",
                  style: textTheme.headlineLarge?.apply(
                    color: darkColorScheme.onSurface,
                  ),
                ),
                MWds.divider(20),
                Text(
                  "Scan the code provided by extension\nYou only need to do this once",
                  style: textTheme.bodyLarge?.apply(
                    color: darkColorScheme.onSurface,
                  ),
                  maxLines: 2,
                  textAlign: TextAlign.center,
                ),
              ]),
            ),
          ),
          Positioned(
            top: 0,
            right: 0,
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: IconButton(
                padding: const EdgeInsets.all(8),
                onPressed: () => Routing.goto(context, Routing.help),
                icon: Icon(Symbols.help, color: darkColorScheme.onSurface),
              ),
            ),
          )
        ]),
      ),
    );
  }
}
