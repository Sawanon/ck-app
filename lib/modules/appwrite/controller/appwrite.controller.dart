import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:get/get.dart';
import 'package:lottery_ck/modules/firebase/controller/firebase_messaging.controller.dart';
import 'package:lottery_ck/utils.dart';

class AppWriteController extends GetxController {
  final String _providerId = '6694bc1400115d5369eb';
  static AppWriteController get to => Get.find();
  late Account account;
  late User? user;
  Client client = Client();
  @override
  void onInit() {
    client
        .setEndpoint("https://baas.moevedigital.com/v1")
        .setProject("667afb24000fbd66b4df")
        .setSelfSigned(status: false);
    account = Account(client);

    super.onInit();
  }

  Future<void> loginWithPhoneNumber(String phoneNumber) async {
    logger.d(phoneNumber);
  }

  Future<void> login(String email, String password) async {
    await account.createEmailPasswordSession(email: email, password: password);
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
      createTarget();
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

  Future<bool> register(String email, String password, String name) async {
    logger.d("run register appwrite");
    final user = await account.create(
      userId: ID.unique(),
      email: email,
      password: password,
      name: name,
    );
    return user.status;
    // account.createPushTarget(targetId: targetId, identifier: identifier)
    // await login(email, password);
  }

  Future<void> logout() async {
    await account.deleteSession(sessionId: 'current');
    logger.d("logout");
    user = null;
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
