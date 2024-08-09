import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:get/get.dart';
import 'package:lottery_ck/modules/firebase/controller/firebase_messaging.controller.dart';
import 'package:lottery_ck/utils.dart';

class AppWriteController extends GetxController {
  static const String _databaseName = 'lottory';
  static const String USER = 'user';
  static const _roleUserId = "669a2cfd00141edc45ef";
  final String _providerId = '6694bc1400115d5369eb';
  static AppWriteController get to => Get.find();
  late Account account;
  late User? user;
  late Databases databases;
  Client client = Client();
  @override
  void onInit() {
    client
        .setEndpoint("https://baas.moevedigital.com/v1")
        .setProject("667afb24000fbd66b4df")
        .setSelfSigned(status: false);
    account = Account(client);
    databases = Databases(client);

    super.onInit();
  }

  Future<void> loginWithPhoneNumber(String phoneNumber) async {
    logger.d(phoneNumber);
  }

  Future<bool> login(String email, String password) async {
    try {
      await account.createEmailPasswordSession(
          email: email, password: password);
      final user = await account.get();
      logger.d(user.name);
      this.user = user;
      // final firebaseMessage = FirebaseMessagingController.to;
      // logger.d(firebaseMessage.token);
      logger.d(user.targets.length);
      for (var element in user.targets) {
        logger.d(element.name);
        logger.d(element.providerType);
      }
      final pushTarget = user.targets
          .where((element) => element.providerType == 'push')
          .toList();
      logger.d(pushTarget);
      logger.d(pushTarget.length);
      if (pushTarget.isEmpty) {
        await createTarget();
      }
      return true;
    } on Exception catch (e) {
      logger.e(e.toString());
      Get.snackbar(
        "Something went wrong",
        "Please try again later or plaese contact admin",
      );
      return false;
    }
    // setState(() {
    //   loggedInUser = user;
    // });
  }

  Future<void> createTarget() async {
    final target = await account.createPushTarget(
      targetId: 'pushna',
      identifier: 'push',
      providerId: _providerId,
    );
    logger.d(target);
  }

  Future<User?> register(String email, String password, String firstName,
      String lastName, String phoneNumber) async {
    try {
      logger.d("run register appwrite");
      final user = await account.create(
        userId: ID.unique(),
        email: email,
        password: password,
        name: '$firstName $lastName',
      );

      return user;
    } on Exception catch (e) {
      Get.snackbar("register failed", "$e");
      logger.e(e.toString());
      return null;
    }
    // final phoneNumber =
    // account.createPushTarget(targetId: targetId, identifier: identifier)
    // await login(email, password);
  }

  Future<bool> createUserDocument(String email, String userId, String firstName,
      String lastName, String phoneNumber) async {
    try {
      final userDocument = await databases.createDocument(
        databaseId: _databaseName,
        collectionId: USER,
        documentId: userId,
        data: {
          "username": email,
          "userId": userId,
          "firstname": firstName,
          "lastname": lastName,
          "email": email,
          "phone": phoneNumber,
          "type": 'user',
          "address": "-",
          "user_roles": _roleUserId,
        },
      );
      logger.d(userDocument.data);

      return true;
    } on Exception catch (e) {
      logger.e(e.toString());
      Get.snackbar(
        "Something went wrong plaese try again later",
        'or plaese contact admin',
      );
      return false;
    }
  }

  Future<void> logout() async {
    try {
      await account.deleteSession(sessionId: 'current');
      logger.d("logout");
      user = null;
    } catch (e) {
      logger.e(e.toString());
    }
  }

  Future<bool> isUserLoggedIn() async {
    try {
      await account.get();
      return true;
    } catch (e) {
      return false;
    }
  }
}
