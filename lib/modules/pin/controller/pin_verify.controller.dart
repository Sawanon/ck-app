import 'dart:typed_data';

import 'package:argon2/argon2.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:lottery_ck/modules/appwrite/controller/appwrite.controller.dart';
import 'package:lottery_ck/res/constant.dart';
import 'package:lottery_ck/utils.dart';

class PinVerifyController extends GetxController {
  String? passcode;
  RxBool pendingVerify = false.obs;

  final arguments = Get.arguments;

  void getPasscode() async {
    final passcode = await AppWriteController.to.getPasscode();
    this.passcode = passcode;
    update();
  }

  void whenSuccess() {
    if (arguments["whenSuccess"] is Function) {
      arguments["whenSuccess"]();
    }
  }

  Future<bool> verifyPasscode(String passcode) async {
    try {
      // var password = passcode;
      // var salt = 'namo'.toBytesLatin1();

      // var parameters = Argon2Parameters(
      //   Argon2Parameters.ARGON2_id,
      //   salt,
      //   version: Argon2Parameters.ARGON2_VERSION_13,
      //   iterations: 2,
      //   memoryPowerOf2: 16,
      //   converter: CharToByteConverterUTF8(),
      // );

      // print('Parameters: $parameters');

      // var argon2 = Argon2BytesGenerator();

      // argon2.init(parameters);

      // var passwordBytes = parameters.converter.convert(password);

      // print('Generating key from password...');

      // var result = Uint8List(32);
      // // argon2.generateBytes(passwordBytes, result, 0, result.length);
      // argon2.generateBytes(passwordBytes, result);
      // // argon2.generateBytesFromString(password, result);
      // var resultHex = result.toHexString();

      // print('Result: $resultHex');
      pendingVerify.value = true;
      final response = await AppWriteController.to.verifyPasscode(passcode);
      logger.d("response?[pass] : ${response?["pass"]}");
      if (response?["pass"] == true) {
        whenSuccess();
      }
      return response?["pass"] == true;
    } catch (e) {
      logger.d("$e");
      return false;
    } finally {
      pendingVerify.value = false;
    }
  }

  @override
  void onInit() {
    getPasscode();
    super.onInit();
  }
}
