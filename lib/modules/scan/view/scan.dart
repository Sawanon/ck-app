import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:lottery_ck/components/dialog.dart';
import 'package:lottery_ck/components/friend_confirm.dart';
import 'package:lottery_ck/components/header.dart';
import 'package:lottery_ck/components/long_button.dart';
import 'package:lottery_ck/components/user_qr.dart';
import 'package:lottery_ck/modules/appwrite/controller/appwrite.controller.dart';
import 'package:lottery_ck/modules/setting/controller/setting.controller.dart';
import 'package:lottery_ck/res/app_locale.dart';
import 'package:lottery_ck/res/color.dart';
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
  bool isLoading = false;
  final double scanWindowWidth = 200;
  final double scanWindowHeight = 200;
  final marginTopMyQR = 16;

  void setIsLoading(bool value) {
    setState(() {
      isLoading = value;
    });
  }

  void _onDetect(BarcodeCapture barcodes) async {
    if (mounted) {
      final refCode = barcodes.barcodes.first.displayValue;
      if (refCode != null) {
        try {
          setIsLoading(true);
          controller.stop();
          final userApp = SettingController.to.user;
          final response =
              await AppWriteController.to.getUserByRefCode(refCode);
          if (response.isSuccess == false) {
            Get.dialog(
              DialogApp(
                title: const Text("Error"),
                details: Text(response.message),
                disableConfirm: true,
                onCancel: () {
                  controller.start();
                },
              ),
            );
            return;
          }
          logger.d(response.data);
          logger.d(response.data?.toJson());
          final user = response.data!;
          if (userApp == null) {
            Get.dialog(
              DialogApp(
                title: Text("User not found"),
                details: Text("Please login"),
              ),
            );
            return;
          }
          if (userApp.refCode == null) {
            Get.dialog(
              DialogApp(
                title: Text("Your ref code is empty"),
                details: Text("Please contact user service"),
              ),
            );
          }
          Get.dialog(
            FriendConfirm(
                firstName: user.firstName,
                lastName: user.lastName,
                phone: user.phone,
                onConfirm: () async {
                  final response = await AppWriteController.to
                      .acceptFriend(refCode, userApp.refCode!);
                  if (response.isSuccess) {
                    Get.dialog(
                      DialogApp(
                        title: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text("Successfully"),
                            Icon(
                              Icons.check,
                              color: Colors.green,
                            ),
                          ],
                        ),
                        disableConfirm: true,
                        onCancel: () {
                          Get.back();
                          Get.back();
                        },
                      ),
                    );
                  } else {
                    Get.dialog(
                      DialogApp(
                        title: Text("Somethig went wrong"),
                        details: Text(response.message),
                        disableConfirm: true,
                      ),
                    );
                  }
                },
                onCancel: () {
                  Get.back();
                  controller.start();
                },
                onBack: () {
                  controller.start();
                }),
          );
          await AppWriteController.to.connectFriend(refCode, userApp.refCode!);
        } finally {
          setIsLoading(false);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final scanWindow = Rect.fromCenter(
      center: MediaQuery.sizeOf(context).center(Offset.zero),
      width: scanWindowWidth,
      height: scanWindowHeight,
    );
    final bottomWindowY = (MediaQuery.of(context).size.height / 2) +
        (scanWindowHeight / 2) +
        marginTopMyQR;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Expanded(
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
                onDetect: _onDetect,
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
            Positioned(
              top: bottomWindowY,
              left: 0,
              right: 0,
              child: Container(
                decoration: BoxDecoration(
                    // color: Colors.white,
                    ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    GestureDetector(
                      onTap: () {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          builder: (context) {
                            return const UserQR();
                          },
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 8,
                          horizontal: 16,
                        ),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(24),
                            color: Colors.black,
                            border: Border.all(
                              width: 1,
                              color: Colors.white.withOpacity(0.4),
                            )),
                        child: Text(
                          'QR code ของฉัน',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SafeArea(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Header(
                    title: 'Scan QR',
                  ),
                ],
              ),
            ),
            if (isLoading == true)
              Container(
                color: Colors.black.withOpacity(0.85),
                child: Center(
                  child: SizedBox(
                    width: 80,
                    height: 80,
                    child: CircularProgressIndicator(
                      color: AppColors.primary,
                      strokeWidth: 2,
                    ),
                  ),
                ),
              ),
          ],
        ),
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
