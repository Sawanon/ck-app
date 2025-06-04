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
import 'package:lottery_ck/controller/user_controller.dart';
import 'package:lottery_ck/modules/kyc/view/success_kyc_dialog.dart';
import 'package:lottery_ck/modules/layout/controller/layout.controller.dart';
import 'package:lottery_ck/modules/setting/controller/setting.controller.dart';
import 'package:lottery_ck/res/app_locale.dart';
import 'package:lottery_ck/res/constant.dart';
import 'package:lottery_ck/utils.dart';
import 'package:image/image.dart' as img;
import 'package:path/path.dart';

class KYCController extends GetxController {
  final maxIdCard = 15;
  Map<String, List<String>> districtList = {
    "th": [
      "คำม่วน",
      "จำปาศักดิ์",
      "เชียงขวาง",
      "ไชยบุรี",
      "ไชยสมบูรณ์",
      "เซกอง",
      "บอลิคำไซ",
      "บ่อแก้ว",
      "พงสาลี",
      "เวียงจันทน์",
      "สาละวัน",
      "สุวรรณเขต",
      "หลวงน้ำทา",
      "หลวงพระบาง",
      "หัวพัน",
      "อัตตะปือ",
      "อุดมไซ",
      "นครหลวงเวียงจันทน์",
    ],
    "lo": [
      "ຄໍາມ່ວນ",
      "ຈໍາປາສັກ",
      "ຊຽງຂວາງ",
      "ໄຊຍະບູລີ",
      "ໄຊສົມບູນ",
      "ເຊກອງ",
      "ບໍລິຄໍາໄຊ",
      "ບໍ່ແກ້ວ",
      "ຜົ້ງສາລີ",
      "ວຽງຈັນ",
      "ສາລະວັນ",
      "ສະຫວັນນະເຂດ",
      "ຫລວງນໍ້າທາ",
      "ຫລວງພະບາງ",
      "ຫົວພັນ",
      "ອັດຕະປື",
      "ອຸດົມໄຊ",
      "ນະຄອນຫຼວງວຽງຈັນ",
    ],
    "en": [
      "Khammouane",
      "Champasak",
      "Xiangkhouang",
      "Sainyabuli",
      "Xaisomboun",
      "Sekong",
      "Bolikhamsai",
      "Bokeo",
      "Phongsaly",
      "Vientiane",
      "Salavan",
      "Savannakhet",
      "Luang Namtha",
      "Luang Prabang",
      "Houaphanh",
      "Attapeu",
      "Oudomxay",
      "Vientiane Prefecture",
    ],
  };
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
    logger.w("isLoading: $isLoading");
    this.isLoading = isLoading;
    update();
  }

  bool disableConfirm() {
    // logger.w(remark);
    if (remark != null) {
      if (remark?['firstName']['status'] == false && firstName == "") {
        logger.e("firstName");
        return true;
      }
      if (remark?['lastName']['status'] == false && lastName == "") {
        logger.e("lastName");
        return true;
      }
      if (remark?['gender']['status'] == false && gender == "") {
        logger.e("gender");
        return true;
      }
      if (remark?['birthDate']['status'] == false && birthDate == "") {
        logger.e("birthDate");
        return true;
      }
      if (remark?['address']['status'] == false && address == "") {
        logger.e("address");
        return true;
      }
      if (remark?['city']['status'] == false && city == "") {
        logger.e("city");
        return true;
      }
      if (remark?['district']['status'] == false && district == "") {
        logger.e("district");
        return true;
      }
      if (remark?['idCard']['status'] == false &&
          (idCard == "" || idCard.length < maxIdCard)) {
        logger.e("idCard");
        return true;
      }
      if (remark?['documentImage']['status'] == false &&
          documentImage == null) {
        logger.e("documentImage");
        return true;
      }
      if (remark?['verifySelfie']['status'] == false &&
          selfieWithDocumentImage == null) {
        logger.e("verifySelfie");
        return true;
      }
      return false;
    }
    if (firstName == "" ||
        lastName == "" ||
        gender == "" ||
        birthDate == "" ||
        address == "" ||
        city == "" ||
        district == "" ||
        idCard == "") {
      return true;
    }
    if (idCard.length < maxIdCard) {
      return true;
    }
    if (documentImage == null || selfieWithDocumentImage == null) {
      return true;
    }
    return false;
  }

  bool validFormKYC() {
    logger.d("firstName: $firstName");
    logger.d("lastName: $lastName");
    logger.d("gender: $gender");
    logger.d("birthDate: $birthDate");
    logger.d("address: $address");
    logger.d("city: $city");
    logger.d("district: $district");
    logger.d("idCard: $idCard");
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
    if (idCard.length < maxIdCard) {
      Get.rawSnackbar(
        message: AppLocale.theNationalIdentificationNumberMustContainDigits
            .getString(Get.context!),
      );
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
      }
      if (remark?['gender']['status'] == false && gender == "") {
        throw AppLocale.pleaseCorrectYourGender.getString(Get.context!);
      }
      if (remark?['birthDate']['status'] == false && birthDate == "") {
        throw AppLocale.pleaseCorrectYourBirthDate.getString(Get.context!);
      }
      if (remark?['address']['status'] == false && address == "") {
        throw AppLocale.pleaseCorrectYourAddress.getString(Get.context!);
      }
      if (remark?['city']['status'] == false && city == "") {
        throw AppLocale.pleaseCorrectYourCity.getString(Get.context!);
      }
      if (remark?['district']['status'] == false && district == "") {
        throw AppLocale.pleaseCorrectYourDistrict.getString(Get.context!);
      }
      if (remark?['idCard']['status'] == false &&
          (idCard == "" || idCard.length < maxIdCard)) {
        throw AppLocale.pleaseCorrectYourIDCardNumber.getString(Get.context!);
      }
      if (remark?['documentImage']['status'] == false &&
          documentImage == null) {
        throw AppLocale.pleaseChangeYourDocumentImage.getString(Get.context!);
      }
      if (remark?['verifySelfie']['status'] == false &&
          selfieWithDocumentImage == null) {
        throw AppLocale.pleaseChangeYourVerificationPicture
            .getString(Get.context!);
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
    update();
  }

  Future<void> resendKYC() async {
    try {
      loading(true);
      if (!validFormResendKYC()) {
        return;
      }
      final userApp = UserController.to.user.value;
      Map<String, dynamic> data = {
        'id': idKYC,
        'userId': userApp!.userId,
      };
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
      // await Future.delayed(const Duration(seconds: 1), () {
      //   logger.d("successfully");
      // });
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
        await resendKYC();
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
      final userApp = UserController.to.user.value;
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
        final String? message = e.response!.data['message'];
        Get.dialog(DialogApp(
          title: Text('Server error ${e.response?.statusCode}'),
          disableConfirm: true,
          details: Text("${message ?? e.response!.statusMessage}"),
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
    final user = UserController.to.user.value;
    if (user == null) {
      return;
    }
    final kycData = SettingController.to.kycData;
    if (user.isKYC == false && kycData == null) {
      firstNameController.text = user.firstName;
      firstName = user.firstName;
      lastNameController.text = user.lastName;
      lastName = user.lastName;
      changePrefix(user.gender == "male" ? Prefix.mr : Prefix.mrs);
      // handleChangeGender(user.gender == "male" ? Prefix.mr : Prefix.mrs);
      changeBirthDate(user.birthDate);
      addressController.text = user.address ?? "";
      address = user.address ?? "";
      return;
    }
    logger.d(kycData);
    if (kycData == null) return;
    final Map remark = jsonDecode(kycData['remark']);
    logger.w(remark);
    if (remark['data']['firstName']['status'] != false) {
      firstNameController.text = kycData['firstName'];
    }
    if (remark['data']['lastName']['status'] != false) {
      lastNameController.text = kycData['lastName'];
    }
    if (remark['data']['gender']['status'] != false) {
      changePrefix(kycData['gender'] == "male" ? Prefix.mr : Prefix.mrs);
      // handleChangeGender(kycData['gender'] == "male" ? Prefix.mr : Prefix.mrs);
    }
    if (remark['data']['birthDate']['status'] != false) {
      changeBirthDate(DateTime.parse(kycData['birthDate']));
    }
    if (remark['data']['address']['status'] != false) {
      addressController.text = kycData['address'];
    }
    if (remark['data']['city']['status'] != false) {
      cityController.text = kycData['city'];
    }
    if (remark['data']['district']['status'] != false) {
      // districtController.text = kycData['district'];
      onChangeDistrict(kycData['district']);
    }
    if (remark['data']['idCard']['status'] != false) {
      idCardController.text = kycData['idCard'];
    }
    if (remark['data']['documentImage']['status'] != false) {
      documentImageUrl = kycData['documentImage'];
    }
    if (remark['data']['verifySelfie']['status'] != false) {
      selfieWithDocumentImageUrl = kycData['verifySelfie'];
    }
    idKYC = kycData["\$id"];
    handleReject(kycData);
    update();
  }

  void handleReject(Map kycData) {
    Map remark = jsonDecode(kycData['remark']);
    logger.w(remark);
    this.remark = remark['data'];
  }

  // void handleChangeGender(Prefix prefix) {
  //   logger.d("prefix: $prefix");
  //   this.prefix = prefix.name;
  //   gender = prefix == Prefix.mr ? Gender.male.name : Gender.female.name;
  //   update();
  // }

  void onChangeDistrict(String? value) {
    if (value == null) return;
    district = value;
    update();
  }

  void onChangeFirstName(String value) {
    firstName = value;
    update();
  }

  void onChangeLastName(String value) {
    lastName = value;
    update();
  }

  void onChangeAddress(String value) {
    address = value;
    update();
  }

  void onChangeCity(String value) {
    city = value;
    update();
  }

  void onChangeIdCard(String value) {
    idCard = value;
    update();
  }

  @override
  void onInit() {
    setup();
    super.onInit();
  }
}
