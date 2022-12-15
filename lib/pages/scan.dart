import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gctu_students/pages/home.dart';
import 'package:gctu_students/provider/firebaese_provider.dart';
import 'package:provider/provider.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class Scan extends StatefulWidget {
  const Scan({super.key});

  @override
  State<Scan> createState() => _ScanState();
}

class _ScanState extends State<Scan> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? result;
  QRViewController? controller;
  @override
  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    } else if (Platform.isIOS) {
      controller!.resumeCamera();
    }
  }

  void _onQRViewCreated(QRViewController controller) async {
    final provider = Provider.of<FirebaseProvider>(context, listen: false);
    final key = provider.classes[0].secretKey;
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) async {
      setState(() {
        result = scanData;
      });
      if (result!.code == key) {
        try {
          await provider.takeAttendance(docId: provider.classes[0].docId);
          if (!mounted) return;
        } on FirebaseException catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(e.message!),
            ),
          );
        }
      }
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      alignment: Alignment.center,
      children: [
        buildView(context),
        Positioned(bottom: 10, child: builResult())
      ],
    ));
  }

  Widget buildView(BuildContext context) => GestureDetector(
        onDoubleTap: () {
          controller!.flipCamera();
        },
        child: QRView(
          key: qrKey,
          onQRViewCreated: _onQRViewCreated,
          overlay: QrScannerOverlayShape(
            borderRadius: 10,
            borderLength: 20,
            cutOutSize: MediaQuery.of(context).size.width * 0.8,
          ),
        ),
      );

  builResult() => Container(
        padding: const EdgeInsets.all(12),
        decoration: const BoxDecoration(
          color: Colors.white24,
        ),
        child: Text(
          result != null ? "Scanning complete" : "Scan for attendance",
          maxLines: 3,
        ),
      );
}
