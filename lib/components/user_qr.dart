import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottery_ck/res/color.dart';
import 'package:lottery_ck/res/icon.dart';
import 'package:lottery_ck/utils.dart';
import 'package:lottery_ck/utils/theme.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share_plus/share_plus.dart';

class UserQR extends StatefulWidget {
  const UserQR({super.key});

  @override
  State<UserQR> createState() => _UserQRState();
}

class _UserQRState extends State<UserQR> {
  GlobalKey globalKey = GlobalKey(debugLabel: 'keyQRcode');

  Future<void> _saveQRCode() async {
    try {
      // สร้าง Boundary
      RenderRepaintBoundary boundary =
          globalKey.currentContext!.findRenderObject() as RenderRepaintBoundary;

      // แปลงเป็นภาพ
      var image = await boundary.toImage(pixelRatio: 3.0);
      ByteData? byteData = await image.toByteData(format: ImageByteFormat.png);
      Uint8List pngBytes = byteData!.buffer.asUint8List();

      final xFile =
          XFile.fromData(pngBytes, mimeType: 'image/png', name: 'qr_code.png');

      await Share.shareXFiles([xFile]);
    } catch (e) {
      // จัดการข้อผิดพลาด
      logger.e('Error share QR Code: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      width: double.infinity,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
          )),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "QR code ของฉัน",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              GestureDetector(
                onTap: () => Get.back(),
                child: SizedBox(
                  width: 32,
                  height: 32,
                  child: SvgPicture.asset(AppIcon.x),
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 48),
            child: RepaintBoundary(
              key: globalKey,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.white,
                  boxShadow: const [
                    AppTheme.softShadow,
                  ],
                ),
                width: 240,
                height: 240,
                child: QrImageView(
                  data: 'This QR code has an embedded image as well',
                  version: QrVersions.auto,
                  embeddedImage: Image.asset(
                    "assets/icon/icon.png",
                    gaplessPlayback: true,
                  ).image,
                  embeddedImageStyle: QrEmbeddedImageStyle(
                    size: Size(
                      48,
                      48,
                    ),
                  ),
                  errorCorrectionLevel: QrErrorCorrectLevel.H,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Text("แสดงรหัส QR นี้ให้เพื่อนเพื่อให้พวกเขาเพิ่มคุณ"),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: GestureDetector(
              onTap: () {
                // QrImageView(data: data).
                _saveQRCode();
              },
              child: Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                decoration: BoxDecoration(
                  gradient: AppColors.primayBtn,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SvgPicture.asset(
                      AppIcon.share,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      "แชร์รหัส QR",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
