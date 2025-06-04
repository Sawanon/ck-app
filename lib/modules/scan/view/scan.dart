import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottery_ck/components/dialog.dart';
import 'package:lottery_ck/components/friend_confirm.dart';
import 'package:lottery_ck/components/header.dart';
import 'package:lottery_ck/components/user_qr.dart';
import 'package:lottery_ck/controller/user_controller.dart';
import 'package:lottery_ck/modules/appwrite/controller/appwrite.controller.dart';
import 'package:lottery_ck/modules/setting/controller/setting.controller.dart';
import 'package:lottery_ck/res/app_locale.dart';
import 'package:lottery_ck/res/color.dart';
import 'package:lottery_ck/utils.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
// import 'package:mobile_scanner_example/scanned_barcode_label.dart';
// import 'package:mobile_scanner_example/scanner_button_widgets.dart';
// import 'package:mobile_scanner_example/scanner_error_widget.dart';
import 'package:lottery_ck/components/scanner_error_widget.dart';

class ScanQR extends StatefulWidget {
  const ScanQR({super.key});

  @override
  State<ScanQR> createState() => _ScanQRState();
}

class _ScanQRState extends State<ScanQR> with WidgetsBindingObserver {
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

  Future<void> _analyzeImageFromFile() async {
    try {
      final XFile? file =
          await ImagePicker().pickImage(source: ImageSource.gallery);

      if (!mounted) {
        return;
      }

      if (file == null) {
        // setState(() {
        //   _barcodeCapture = null;
        // });
        return;
      }

      final BarcodeCapture? barcodeCapture =
          await controller.analyzeImage(file.path);
      if (mounted) {
        logger.w(barcodeCapture?.barcodes.first.displayValue);
        if (barcodeCapture != null) {
          _onDetect(barcodeCapture);
        }
        // setState(() {
        //   _barcodeCapture = barcodeCapture;
        // });
      }
    } catch (e) {
      logger.e("$e");
    }
  }

  void _onDetect(BarcodeCapture barcodes) async {
    if (mounted) {
      final refCode = barcodes.barcodes.first.displayValue;
      if (refCode != null) {
        try {
          setIsLoading(true);
          controller.stop();
          final userApp = UserController.to.user.value;
          if (userApp == null) {
            Get.dialog(
              DialogApp(
                title: Text(AppLocale.userNotFound.getString(context)),
                // details: Text("Please login"),
              ),
            );
            return;
          }
          if (userApp.refCode == null) {
            Get.dialog(
              DialogApp(
                title:
                    Text(AppLocale.yourReferralCodeIsEmpty.getString(context)),
                details:
                    Text(AppLocale.pleaseContactUserService.getString(context)),
              ),
            );
          }
          final response =
              await AppWriteController.to.getUserByRefCode(refCode);
          if (response.isSuccess == false) {
            if (mounted) {
              Get.dialog(
                DialogApp(
                  title: Text(AppLocale.somethingWentWrong.getString(context)),
                  details: Text(response.message),
                  disableConfirm: true,
                  onCancel: () {
                    controller.start();
                  },
                ),
              );
            } else {
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
            }
            return;
          }
          logger.d(response.data);
          logger.d(response.data?.toJson());
          final user = response.data!;
          final profile = user.profile;

          Uint8List? profileByte;
          if (profile != null) {
            final fileId = profile.split(":").last;
            profileByte = await AppWriteController.to.getProfileImage(fileId);
          }
          final responseConnectFriend = await AppWriteController.to
              .connectFriend(refCode, userApp.refCode!);
          if (responseConnectFriend.isSuccess == false) {
            // Can't connect the same ref code
            String message = responseConnectFriend.message;
            if (message == "Can't connect the same ref code") {
              if (mounted) {
                message =
                    AppLocale.youCannotUseYourOwnQRCode.getString(context);
              }
            }
            Get.dialog(DialogApp(
              title: Text(message),
              disableConfirm: true,
              onCancel: () {
                controller.start();
              },
            ));
            return;
          }
          Get.dialog(
            FriendConfirm(
                firstName: user.firstName,
                lastName: user.lastName,
                phone: user.phone,
                profileByte: profileByte,
                onConfirm: () async {
                  final response = await AppWriteController.to
                      .acceptFriend(refCode, userApp.refCode!);
                  if (response.isSuccess) {
                    if (mounted) {
                      Get.dialog(
                        DialogApp(
                          title: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(AppLocale.youAreNowFriends
                                  .getString(context)),
                              const SizedBox(width: 12),
                              const Icon(
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
                    }
                  } else {
                    if (mounted) {
                      Get.dialog(
                        DialogApp(
                          title: Text(
                              AppLocale.somethingWentWrong.getString(context)),
                          details: Text(response.message),
                          disableConfirm: true,
                        ),
                      );
                    }
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
        } finally {
          setIsLoading(false);
        }
      }
    }
  }

  void setup() async {
    await Future.delayed(const Duration(seconds: 1), () {
      controller.switchCamera();
    });
  }

  @override
  void initState() {
    super.initState();
    // setup();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // If the controller is not ready, do not try to start or stop it.
    // Permission dialogs can trigger lifecycle changes before the controller is ready.
    logger.w(state);
    if (!controller.value.hasCameraPermission) {
      return;
    }

    switch (state) {
      case AppLifecycleState.detached:
      case AppLifecycleState.hidden:
      case AppLifecycleState.paused:
        return;
      case AppLifecycleState.resumed:
        // Restart the scanner when the app is resumed.
        // Don't forget to resume listening to the barcode events.
        // _subscription = controller.barcodes.listen(_handleBarcode);
        logger.d("resumed");
        unawaited(controller.start());
      case AppLifecycleState.inactive:
        // Stop the scanner when the app is paused.
        // Also stop the barcode events subscription.
        // unawaited(_subscription?.cancel());
        // _subscription = null;
        unawaited(controller.stop());
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
      backgroundColor: Colors.white,
      body: Stack(
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
          const Align(
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
              decoration: const BoxDecoration(
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
                        AppLocale.myQRcode.getString(context),
                        style: const TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            right: 24,
            bottom: 24,
            child: GestureDetector(
              onTap: _analyzeImageFromFile,
              child: Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.image,
                  size: 40,
                ),
              ),
            ),
          ),
          SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Header(
                  title: AppLocale.scan.getString(context),
                ),
              ],
            ),
          ),
          if (isLoading == true)
            Container(
              color: Colors.black.withOpacity(0.85),
              child: const Center(
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
    );
  }

  @override
  Future<void> dispose() async {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
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
