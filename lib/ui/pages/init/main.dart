import 'dart:async';
import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:restart_app/restart_app.dart';
import 'package:student/core/databases/server.dart';
import 'package:student/core/databases/shared_prefs.dart';
import 'package:student/ui/pages/help/mdviewer.dart';
import 'package:student/ui/pages/init/fill_form.dart';
// import 'package:student/core/databases/user.dart';

class Initializer extends StatefulWidget {
  const Initializer({super.key});

  @override
  State<Initializer> createState() => _InitializerState();
}

class _InitializerState extends State<Initializer> {
  double invalidOpacity = 0;
  final MobileScannerController controller = MobileScannerController(
    formats: [BarcodeFormat.qrCode],
    // required options for the scanner
  );

  void checkValidUser(Map<String, dynamic> data) {
    data["id"] as String;
    data["name"] as String;
    data["group"] as int;
    data["semester"] as int;
    data["schoolYear"] as int;
    data["learning"] as List;
  }

  void _handleBarcode(BarcodeCapture? barcodes) {
    if (barcodes == null || !mounted) return;

    Barcode? barcode = barcodes.barcodes.firstOrNull;
    if (barcode == null) return;

    Server.iCM.downloadFile(barcode.displayValue!).then((value) {
      Map<String, dynamic> parsed = jsonDecode(value.file.readAsStringSync());

      try {
        checkValidUser(parsed["user"]);
        SharedPrefs.setString("user", parsed["user"]).then((_) {
          SharedPrefs.setString("env", parsed["env"]).then(
            (_) => Restart.restartApp(),
          );
        });
      } catch (e) {
        setState(() {
          invalidOpacity = 1;
        });
        SharedPrefs.clear();
        Future.delayed(const Duration(seconds: 3), () {
          setState(() {
            invalidOpacity = 0;
          });
        });
      }
    });
  }

  @override
  Future<void> dispose() async {
    super.dispose();
    await controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    // TextTheme textTheme = Theme.of(context).textTheme;
    ButtonStyle style = TextButton.styleFrom(
      backgroundColor: colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.all(16),
      fixedSize: Size.fromWidth(MediaQuery.of(context).size.width),
    );
    Map<MapEntry<String,IconData>, void Function()> btnMap = {
      const MapEntry("Use picture",Symbols.upload): () {
        FilePicker.platform.pickFiles(type: FileType.image).then((f) {
          if (f == null) return;
          controller.analyzeImage(f.files.single.path!).then(_handleBarcode);
        });
      },
      const MapEntry("Fill manually",Symbols.edit): () {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => const FillForm(),
        ));
      }
    };
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("Scan generated code"),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                return const HelpMDViewerPage();
              }));
            },
            icon: const Icon(Symbols.help),
          )
        ],
      ),
      body: Stack(children: [
        MobileScanner(
          controller: controller,
          // fit: BoxFit.contain,
          onDetect: _handleBarcode,
        ),
        Positioned(
          bottom: 16,
          child: Row(
            children: btnMap
                .map((key, value) {
                  return MapEntry(
                    key,
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 2,
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: TextButton.icon(
                          onPressed: value,
                          icon: Icon(key.value),
                          label: Text(key.key),
                          style: style,
                        ),
                      ),
                    ),
                  );
                })
                .values
                .toList(),
          ),
        ),
        Positioned(
          bottom: 64,
          child: AnimatedOpacity(
            opacity: invalidOpacity,
            duration: const Duration(milliseconds: 300),
            child: Container(
              padding: const EdgeInsets.all(16),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: colorScheme.surface,
              ),
              child: const Text(
                "QR Code scanned is invalid, please try again!",
              ),
            ),
          ),
        )
      ]),
    );
  }
}
