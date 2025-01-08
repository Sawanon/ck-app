import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart' as dio_class;
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottery_ck/components/dialog.dart';
import 'package:lottery_ck/components/gender_radio.dart';
import 'package:lottery_ck/components/prefix_radio.dart';
import 'package:lottery_ck/modules/kyc/view/success_kyc_dialog.dart';
import 'package:lottery_ck/modules/layout/controller/layout.controller.dart';
import 'package:lottery_ck/modules/setting/controller/setting.controller.dart';
import 'package:lottery_ck/res/app_locale.dart';
import 'package:lottery_ck/res/constant.dart';
import 'package:lottery_ck/utils.dart';
import 'package:image/image.dart' as img;
import 'package:path/path.dart';

class KYCController extends GetxController {
  File? documentImage;
  File? selfieWithDocumentImage;
  String? documentImageUrl;
  String? selfieWithDocumentImageUrl;
  String idCard = "";
  TextEditingController idCardController = TextEditingController();
  String firstName = "";
  TextEditingController firstNameController = TextEditingController();
  String lastName = "";
  TextEditingController lastNameController = TextEditingController();
  String gender = "";
  String prefix = "";
  String birthDate = "";
  String address = "";
  TextEditingController addressController = TextEditingController();
  String city = "";
  TextEditingController cityController = TextEditingController();
  String district = "";
  TextEditingController districtController = TextEditingController();
  bool isLoading = false;
  Map? remark;
  String? idKYC;

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

  void loading(bool isLoading) {
    this.isLoading = isLoading;
    update();
  }

  bool validFormKYC() {
    if (firstName == "" ||
        lastName == "" ||
        gender == "" ||
        birthDate == "" ||
        address == "" ||
        city == "" ||
        district == "" ||
        idCard == "") {
      Get.rawSnackbar(
          message:
              AppLocale.pleaseFillInAllInformation.getString(Get.context!));
      return false;
    }
    if (documentImage == null || selfieWithDocumentImage == null) {
      Get.rawSnackbar(
          message: AppLocale.pleaseProvideAPhotocopyAndProofOfIdentity
              .getString(Get.context!));
      return false;
    }
    return true;
  }

  bool validFormResendKYC() {
    try {
      if (remark?['firstName']['status'] == false && firstName == "") {
        throw AppLocale.pleaseCorrectYourName.getString(Get.context!);
      }
      if (remark?['lastName']['status'] == false && lastName == "") {
        throw AppLocale.pleaseCorrectYourLastName.getString(Get.context!);
        ;
      }
      if (remark?['gender']['status'] == false && gender == "") {
        throw AppLocale.pleaseCorrectYourGender.getString(Get.context!);
        ;
      }
      if (remark?['birthDate']['status'] == false && birthDate == "") {
        throw AppLocale.pleaseCorrectYourBirthDate.getString(Get.context!);
        ;
      }
      if (remark?['address']['status'] == false && address == "") {
        throw AppLocale.pleaseCorrectYourAddress.getString(Get.context!);
        ;
      }
      if (remark?['city']['status'] == false && city == "") {
        throw AppLocale.pleaseCorrectYourCity.getString(Get.context!);
        ;
      }
      if (remark?['district']['status'] == false && district == "") {
        throw AppLocale.pleaseCorrectYourDistrict.getString(Get.context!);
        ;
      }
      if (remark?['idCard']['status'] == false && idCard == "") {
        throw AppLocale.pleaseCorrectYourIDCardNumber.getString(Get.context!);
        ;
      }
      if (remark?['documentImage']['status'] == false &&
          documentImage == null) {
        throw AppLocale.pleaseChangeYourDocumentImage.getString(Get.context!);
      }
      if (remark?['verifySelfie']['status'] == false &&
          selfieWithDocumentImage == null) {
        throw AppLocale.pleaseChangeYourVerificationPicture
            .getString(Get.context!);
        ;
      }
      // if (remark?['idCard']['status'] == false && idCard == "") {
      //   throw "Please edit your id card";
      // }
      return true;
    } catch (e) {
      Get.rawSnackbar(message: "$e");
      return false;
    }
  }

  void changePrefix(Prefix prefix) {
    if (prefix == Prefix.mr) {
      gender = Gender.male.name;
      this.prefix = Prefix.mr.name;
    } else if (prefix == Prefix.mrs) {
      gender = Gender.female.name;
      this.prefix = Prefix.mrs.name;
    }
  }

  void resendKYC() async {
    try {
      if (!validFormResendKYC()) {
        return;
      }
      final userApp = LayoutController.to.userApp;
      Map<String, dynamic> data = {
        'id': idKYC,
        'userId': userApp!.userId,
      };
      loading(true);
      if (firstName != "") data['firstName'] = firstName;
      if (lastName != "") data['lastName'] = lastName;
      if (gender != "") data['gender'] = gender;
      if (prefix != "") data['prefix'] = prefix;
      if (address != "") data['address'] = address;
      if (city != "") data['city'] = city;
      if (district != "") data['district'] = district;
      if (birthDate != "") data['birthDate'] = birthDate;
      if (idCard != "") data['idCard'] = idCard;
      Map mediePayload = {};
      if (documentImage != null) {
        mediePayload['documentImage'] = await dio_class.MultipartFile.fromFile(
          documentImage!.path,
          filename: basename(documentImage!.path),
        );
      }
      if (selfieWithDocumentImage != null) {
        mediePayload['verifySelfie'] = await dio_class.MultipartFile.fromFile(
          selfieWithDocumentImage!.path,
          filename: basename(selfieWithDocumentImage!.path),
        );
      }
      logger.d(data);
      var payload = dio_class.FormData.fromMap({
        ...mediePayload,
        'data': jsonEncode(data),
      });
      var dio = dio_class.Dio();
      var response = await dio.post(
        '${AppConst.apiUrl}/user/kyc',
        // 'http://192.168.1.153:3010/api/user/kyc',
        data: payload,
      );
      logger.d(response);
      if (response.statusCode == 200) {
        SettingController.to.getUser();
        Get.back();
        await Future.delayed(const Duration(milliseconds: 250), () {
          Get.dialog(const SuccessKycDialog());
        });
      }
    } on dio_class.DioException catch (e) {
      if (e.response != null) {
        logger.e(e.response!.statusCode);
        logger.e(e.response!.statusMessage);
        logger.e(e.response!.data);
        Get.dialog(DialogApp(
          title: Text('Server error ${e.response?.statusCode}'),
          disableConfirm: true,
          details: Text(
              "${e.response?.data['message'] ?? e.response!.statusMessage}"),
        ));
      }
    } catch (e) {
      logger.e("$e");
    } finally {
      loading(false);
    }
  }

  void sendKYC() async {
    try {
      if (remark != null) {
        resendKYC();
        return;
      }
      // loading(true);
      // await Future.delayed(const Duration(seconds: 2), () {
      //   loading(false);
      // });
      // Get.back();
      // await Future.delayed(const Duration(milliseconds: 250), () {
      //   Get.dialog(const SuccessKycDialog());
      // });
      // return;
      if (!validFormKYC()) {
        return;
      }
      loading(true);
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
        "prefix": prefix,
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

      var dio = dio_class.Dio();
      var response = await dio.post(
        '${AppConst.apiUrl}/user/kyc',
        // 'http://192.168.1.153:3010/api/user/kyc',
        data: payload,
      );
      logger.d(response);
      if (response.statusCode == 200) {
        SettingController.to.getUser();
        Get.back();
        await Future.delayed(const Duration(milliseconds: 250), () {
          Get.dialog(const SuccessKycDialog());
        });
      }
    } on dio_class.DioException catch (e) {
      if (e.response != null) {
        logger.e(e.response!.statusCode);
        logger.e(e.response!.statusMessage);
        logger.e(e.response!.data);
        Get.dialog(DialogApp(
          title: Text('Server error ${e.response?.statusCode}'),
          disableConfirm: true,
          details: Text("${e.response!.statusMessage}"),
        ));
      }
    } catch (e) {
      logger.e("$e");
    } finally {
      loading(false);
    }

    // if (response.statusCode == 200) {
    //   print(json.encode(response.data));
    // } else {
    //   print(response.statusMessage);
    // }
  }

  void setup() {
    final kycData = SettingController.to.kycData;
    logger.d(kycData);
    if (kycData == null) return;
    firstNameController.text = kycData['firstName'];
    lastNameController.text = kycData['lastName'];
    gender = kycData['gender'];
    changeBirthDate(DateTime.parse(kycData['date']));
    addressController.text = kycData['address'];
    cityController.text = kycData['city'];
    districtController.text = kycData['district'];
    idCardController.text = kycData['idCard'];
    documentImageUrl = kycData['documentImage'];
    selfieWithDocumentImageUrl = kycData['verifySelfie'];
    idKYC = kycData["\$id"];
    handleReject(kycData);
    update();
  }

  void handleReject(Map kycData) {
    Map remark = jsonDecode(kycData['remark']);
    logger.w(remark);
    this.remark = remark['data'];
  }

  void handleChangeGender(Prefix prefix) {
    logger.d("prefix: $prefix");
    this.prefix = prefix.name;
    gender = prefix == Prefix.mr ? Gender.male.name : Gender.female.name;
  }

  @override
  void onInit() {
    setup();
    super.onInit();
  }
}
