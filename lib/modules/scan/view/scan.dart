import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lottery_ck/res/icon.dart';
import 'package:lottery_ck/utils.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
// import 'package:mobile_scanner_example/scanned_barcode_label.dart';
// import 'package:mobile_scanner_example/scanner_button_widgets.dart';
// import 'package:mobile_scanner_example/scanner_error_widget.dart';
import 'package:lottery_ck/components/scanner_error_widget.dart';

class ScanQR extends StatefulWidget {
  const ScanQR({super.key});

  @override
  _ScanQRState createState() => _ScanQRState();
}

class _ScanQRState extends State<ScanQR> {
  final MobileScannerController controller = MobileScannerController(
    formats: const [BarcodeFormat.qrCode],
  );

  @override
  Widget build(BuildContext context) {
    final scanWindow = Rect.fromCenter(
      center: MediaQuery.sizeOf(context).center(Offset.zero),
      width: 200,
      height: 200,
    );

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text(''),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          // Container(
          //   padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
          //   child: Row(
          //     children: [
          //       SizedBox(
          //         width: 32,
          //         height: 32,
          //         child: SvgPicture.asset(
          //           AppIcon.x,
          //           colorFilter: ColorFilter.mode(
          //             Colors.white,
          //             BlendMode.srcIn,
          //           ),
          //         ),
          //       )
          //     ],
          //   ),
          // ),
          Expanded(
            child: Stack(
              fit: StackFit.expand,
              children: [
                Center(
                  child: MobileScanner(
                    fit: BoxFit.cover,
                    controller: controller,
                    scanWindow: scanWindow,
                    errorBuilder: (context, error, child) {
                      return ScannerErrorWidget(error: error);
                    },
                    onDetect: (barcodes) {
                      logger.d(barcodes.barcodes);
                      barcodes.barcodes.forEach(
                        (element) {
                          logger.d("QR: ${element.displayValue}");
                        },
                      );
                    },
                    // overlayBuilder: (context, constraints) {
                    //   return Padding(
                    //     padding: const EdgeInsets.all(16.0),
                    //     child: Align(
                    //       alignment: Alignment.bottomCenter,
                    //       // child: ScannedBarcodeLabel(barcodes: controller.barcodes),
                    //       child: Text(),
                    //     ),
                    //   );
                    // },
                  ),
                ),
                ValueListenableBuilder(
                  valueListenable: controller,
                  builder: (context, value, child) {
                    if (!value.isInitialized ||
                        !value.isRunning ||
                        value.error != null) {
                      return const SizedBox();
                    }

                    return CustomPaint(
                      painter: ScannerOverlay(scanWindow: scanWindow),
                    );
                  },
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        // ToggleFlashlightButton(controller: controller),
                        // SwitchCameraButton(controller: controller),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Future<void> dispose() async {
    super.dispose();
    await controller.dispose();
  }
}

class ScannerOverlay extends CustomPainter {
  const ScannerOverlay({
    required this.scanWindow,
    this.borderRadius = 12.0,
  });

  final Rect scanWindow;
  final double borderRadius;

  @override
  void paint(Canvas canvas, Size size) {
    // we need to pass the size to the custom paint widget
    final backgroundPath = Path()
      ..addRect(Rect.fromLTWH(0, 0, size.width, size.height));

    final cutoutPath = Path()
      ..addRRect(
        RRect.fromRectAndCorners(
          scanWindow,
          topLeft: Radius.circular(borderRadius),
          topRight: Radius.circular(borderRadius),
          bottomLeft: Radius.circular(borderRadius),
          bottomRight: Radius.circular(borderRadius),
        ),
      );

    final backgroundPaint = Paint()
      ..color = Colors.black.withOpacity(0.5)
      ..style = PaintingStyle.fill
      ..blendMode = BlendMode.dstOver;

    final backgroundWithCutout = Path.combine(
      PathOperation.difference,
      backgroundPath,
      cutoutPath,
    );

    final borderPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.0;

    final borderRect = RRect.fromRectAndCorners(
      scanWindow,
      topLeft: Radius.circular(borderRadius),
      topRight: Radius.circular(borderRadius),
      bottomLeft: Radius.circular(borderRadius),
      bottomRight: Radius.circular(borderRadius),
    );

    // First, draw the background,
    // with a cutout area that is a bit larger than the scan window.
    // Finally, draw the scan window itself.
    canvas.drawPath(backgroundWithCutout, backgroundPaint);
    canvas.drawRRect(borderRect, borderPaint);
  }

  @override
  bool shouldRepaint(ScannerOverlay oldDelegate) {
    return scanWindow != oldDelegate.scanWindow ||
        borderRadius != oldDelegate.borderRadius;
  }
}
