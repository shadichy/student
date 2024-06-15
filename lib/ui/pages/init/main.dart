import 'dart:async';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:restart_app/restart_app.dart';
import 'package:student/core/databases/hive.dart';
import 'package:student/ui/pages/help/mdviewer.dart';
import 'package:student/ui/pages/init/fill_form.dart';
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

    Storage().download(Uri.parse(barcode.displayValue!)).then((parsed) {
      // Map<String, dynamic> parsed = jsonDecode(value.file.readAsStringSync());

      try {
        checkValidUser(parsed["user"]);
        // User().setUser(parsed["user"]);
        Storage().setUser(parsed["user"]).then((_) {
          (parsed["env"] as Map<String, dynamic>).forEach((key, value) async {
            await Storage().setEnv(key, value);
          });
        }).then((_) => Restart.restartApp());
        // SharedPrefs.setString("user", parsed["user"]).then((_) {
        //   SharedPrefs.setString("env", parsed["env"]).then(
        //     (_) => Restart.restartApp(),
        //   );
        // });
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("QR Code scanned is invalid, please try again!"),
        ));
        // SharedPrefs.clear();
        Storage().clear();
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
        )
      ]),
    );
  }
}
