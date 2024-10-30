import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart' as dio_class;
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottery_ck/modules/layout/controller/layout.controller.dart';
import 'package:lottery_ck/res/constant.dart';
import 'package:lottery_ck/utils.dart';
import 'package:image/image.dart' as img;
import 'package:path/path.dart';

class KYCController extends GetxController {
  File? documentImage;
  File? selfieWithDocumentImage;
  String idCard = "";
  String firstName = "";
  String lastName = "";
  String gender = "";
  String birthDate = "";
  String address = "";
  String city = "";
  String district = "";

  void takeIdCard() async {
    final pickedImage = await ImagePicker().pickImage(
      source: ImageSource.camera,
      preferredCameraDevice: CameraDevice.rear,
      requestFullMetadata: true,
    );
    if (pickedImage == null) return;
    documentImage = File(pickedImage.path);
    update();
    getLostData();
  }

  void takeSelfieWithIdCard() async {
    final pickedImage = await ImagePicker().pickImage(
      source: ImageSource.camera,
      preferredCameraDevice: CameraDevice.rear,
      requestFullMetadata: true,
    );
    if (pickedImage == null) return;
    selfieWithDocumentImage = File(pickedImage.path);
    update();
    getLostData();
  }

  void changeBirthDate(DateTime dateTime) {
    birthDate =
        "${dateTime.year}${dateTime.month.toString().padLeft(2, "0")}${dateTime.day.toString().padLeft(2, "0")}";
    update();
  }

  String renderBirthDate(String birthDate) {
    return "${birthDate.substring(6, 8)}/${birthDate.substring(4, 6)}/${birthDate.substring(0, 4)}";
  }

  Future<void> getLostData() async {
    final ImagePicker picker = ImagePicker();
    final LostDataResponse response = await picker.retrieveLostData();
    if (response.isEmpty) {
      return;
    }
    final List<XFile>? files = response.files;
    if (files != null) {
      logger.d(files);
      for (var file in files) {
        logger.e(file.path);
      }
      // _handleLostFiles(files);
    } else {
      // _handleError(response.exception);
    }
  }

  void sendKYC() async {
    try {
      if (documentImage == null || selfieWithDocumentImage == null) {
        Get.rawSnackbar(message: "Please enter info");
        return;
      }
      final userApp = LayoutController.to.userApp;
      final data = {
        "userId": userApp!.userId,
        "idCard": idCard,
        "firstName": firstName,
        "lastName": lastName,
        "gender": gender,
        "address": address,
        "city": city,
        "district": district,
        "birthDate": birthDate,
      };
      var payload = dio_class.FormData.fromMap({
        'documentImage': await dio_class.MultipartFile.fromFile(
          documentImage!.path,
          filename: basename(documentImage!.path),
        ),
        'verifySelfie': await dio_class.MultipartFile.fromFile(
          selfieWithDocumentImage!.path,
          filename: basename(selfieWithDocumentImage!.path),
        ),
        'data': jsonEncode(data),
      });

      logger.d(data);
      var dio = dio_class.Dio();
      var response = await dio.post(
        '${AppConst.apiUrl}/user/kyc',
        // 'http://192.168.1.153:3010/api/user/kyc',
        data: payload,
      );
      logger.d(response);
    } on dio_class.DioException catch (e) {
      if (e.response != null) {
        logger.e(e.response!.statusCode);
        logger.e(e.response!.statusMessage);
        logger.e(e.response!.data);
      }
    } catch (e) {
      logger.e("$e");
    }

    // if (response.statusCode == 200) {
    //   print(json.encode(response.data));
    // } else {
    //   print(response.statusMessage);
    // }
  }
}
