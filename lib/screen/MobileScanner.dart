import 'package:audioplayers/audioplayers.dart';
import 'package:empire_ios/main.dart';
import 'package:empire_ios/screen/GatePass/scanner_error_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class MobileScannerScreen extends StatefulWidget {
  const MobileScannerScreen({Key? key}) : super(key: key);

  @override
  State<MobileScannerScreen> createState() => _MobileScannerScreenState();
}

class _MobileScannerScreenState extends State<MobileScannerScreen> {
  MobileScannerController cameraController = MobileScannerController();
  bool _isFlashOn = false;
  bool _isFrontCamera = false;
  bool _hasScanned = false;
  final player = AudioPlayer();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan QR Code'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: () => _toggleFlash(),
            icon: Icon(_isFlashOn ? Icons.flash_on : Icons.flash_off),
          ),
          IconButton(
            onPressed: () => _switchCamera(),
            icon: Icon(_isFrontCamera ? Icons.camera_rear : Icons.camera_front),
          ),
        ],
      ),
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          MobileScanner(
            onDetect: (capture) {
              final List<Barcode> barcodes = capture.barcodes;
              if (barcodes.isNotEmpty && !_hasScanned) {
                setState(() {
                  _hasScanned = true; // Prevent multiple triggers
                });
                _onBarcodeDetected(barcodes.first);
              }
            },
          ),
          // Overlay with scanning frame
          Container(
            decoration: ShapeDecoration(
              shape: ScannerOverlayShape(
                borderColor: Colors.white,
                borderRadius: 10,
                borderLength: 30,
                borderWidth: 10,
                cutOutSize: 250,
              ),
            ),
          ),
          // Instructions
          Positioned(
            bottom: 100,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(20),
              child: const Text(
                'Place the QR code or barcode inside the frame to scan',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  backgroundColor: Colors.black54,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _onBarcodeDetected(Barcode barcode) async {
    // Stop the camera
    cameraController.stop();

    // Vibrate on successful scan
    HapticFeedback.mediumImpact();
    await player.play(AssetSource("img/search.mp3"));
    // Show result dialog
    Navigator.pop(context, barcode.displayValue); // Close the scanner screen
    // showDialog(
    //   context: context,
    //   barrierDismissible: false,
    //   builder: (BuildContext context) {
    //     return AlertDialog(
    //       title: const Text('Scan Result'),
    //       content: Column(
    //         mainAxisSize: MainAxisSize.min,
    //         crossAxisAlignment: CrossAxisAlignment.start,
    //         children: [
    //           Text('Type: ${barcode.type.name}'),
    //           const SizedBox(height: 10),
    //           Text('Value: ${barcode.displayValue ?? 'No value'}'),
    //         ],
    //       ),
    //       actions: [
    //         TextButton(
    //           onPressed: () {
    //             Clipboard.setData(
    //               ClipboardData(text: barcode.displayValue ?? ''),
    //             );
    //             ScaffoldMessenger.of(context).showSnackBar(
    //               const SnackBar(content: Text('Copied to clipboard')),
    //             );
    //           },
    //           child: const Text('Copy'),
    //         ),
    //         TextButton(
    //           onPressed: () {
    //             Navigator.of(context).pop();
    //             cameraController.start(); // Restart camera
    //           },
    //           child: const Text('Scan Again'),
    //         ),
    //         TextButton(
    //           onPressed: () {
    //             Navigator.of(context).pop();
    //             Navigator.of(context).pop(); // Go back to home
    //           },
    //           child: const Text('Done'),
    //         ),
    //       ],
    //     );
    //   },
    // );
  }

  void _toggleFlash() {
    setState(() {
      _isFlashOn = !_isFlashOn;
    });
    cameraController.toggleTorch();
  }

  void _switchCamera() {
    setState(() {
      _isFrontCamera = !_isFrontCamera;
    });
    cameraController.switchCamera();
  }

  @override
  void dispose() {
    cameraController.dispose();
    player.dispose();
    super.dispose();
  }
}

// Custom scanner overlay shape
class ScannerOverlayShape extends ShapeBorder {
  final Color borderColor;
  final double borderWidth;
  final Color overlayColor;
  final double borderRadius;
  final double borderLength;
  final double cutOutSize;

  const ScannerOverlayShape({
    this.borderColor = Colors.red,
    this.borderWidth = 3.0,
    this.overlayColor = const Color.fromRGBO(0, 0, 0, 80),
    this.borderRadius = 0,
    this.borderLength = 40,
    this.cutOutSize = 250,
  });

  @override
  EdgeInsetsGeometry get dimensions => const EdgeInsets.all(10);

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) {
    return Path()
      ..fillType = PathFillType.evenOdd
      ..addPath(getOuterPath(rect), Offset.zero);
  }

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    Path path = Path()..addRect(rect);
    Path innerPath = Path()
      ..addRRect(
        RRect.fromRectAndRadius(
          Rect.fromCenter(
            center: rect.center,
            width: cutOutSize,
            height: cutOutSize,
          ),
          Radius.circular(borderRadius),
        ),
      );
    return Path.combine(PathOperation.difference, path, innerPath);
  }

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {
    final width = rect.width;
    final borderWidthSize = width / 2;
    final height = rect.height;
    final borderOffset = borderWidth / 2;
    final mBorderLength = borderLength > cutOutSize / 2 + borderWidth * 2 ? borderWidthSize / 2 : borderLength;
    final mCutOutSize = cutOutSize < width ? cutOutSize : width - borderOffset;

    final backgroundPaint = Paint()
      ..color = overlayColor
      ..style = PaintingStyle.fill;

    final borderPaint = Paint()
      ..color = borderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = borderWidth;

    final backgroundRect = Rect.fromLTWH(0, 0, width, height);
    final cutOutRect = Rect.fromCenter(
      center: Offset(width / 2, height / 2),
      width: mCutOutSize,
      height: mCutOutSize,
    );

    canvas.drawPath(
      Path.combine(
        PathOperation.difference,
        Path()..addRect(backgroundRect),
        Path()
          ..addRRect(
            RRect.fromRectAndRadius(
              cutOutRect,
              Radius.circular(borderRadius),
            ),
          ),
      ),
      backgroundPaint,
    );

    // Draw border lines
    final borderPath = Path();

    // Top Left
    borderPath.moveTo(cutOutRect.left - borderOffset, cutOutRect.top);
    borderPath.lineTo(cutOutRect.left - borderOffset + mBorderLength, cutOutRect.top);
    borderPath.moveTo(cutOutRect.left, cutOutRect.top - borderOffset);
    borderPath.lineTo(cutOutRect.left, cutOutRect.top - borderOffset + mBorderLength);

    // Top Right
    borderPath.moveTo(cutOutRect.right + borderOffset, cutOutRect.top);
    borderPath.lineTo(cutOutRect.right + borderOffset - mBorderLength, cutOutRect.top);
    borderPath.moveTo(cutOutRect.right, cutOutRect.top - borderOffset);
    borderPath.lineTo(cutOutRect.right, cutOutRect.top - borderOffset + mBorderLength);

    // Bottom Left
    borderPath.moveTo(cutOutRect.left - borderOffset, cutOutRect.bottom);
    borderPath.lineTo(cutOutRect.left - borderOffset + mBorderLength, cutOutRect.bottom);
    borderPath.moveTo(cutOutRect.left, cutOutRect.bottom + borderOffset);
    borderPath.lineTo(cutOutRect.left, cutOutRect.bottom + borderOffset - mBorderLength);

    // Bottom Right
    borderPath.moveTo(cutOutRect.right + borderOffset, cutOutRect.bottom);
    borderPath.lineTo(cutOutRect.right + borderOffset - mBorderLength, cutOutRect.bottom);
    borderPath.moveTo(cutOutRect.right, cutOutRect.bottom + borderOffset);
    borderPath.lineTo(cutOutRect.right, cutOutRect.bottom + borderOffset - mBorderLength);

    canvas.drawPath(borderPath, borderPaint);
  }

  @override
  ShapeBorder scale(double t) {
    return ScannerOverlayShape(
      borderColor: borderColor,
      borderWidth: borderWidth,
      overlayColor: overlayColor,
    );
  }
}
