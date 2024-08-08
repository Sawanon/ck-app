import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:lottery_ck/utils.dart';

class FirebaseMessagingController extends GetxController {
  static FirebaseMessagingController get to => Get.find();
  late String? token;
  void initialFirebase() async {
    try {
      // You may set the permission requests to "provisional" which allows the user to choose what type
      // of notifications they would like to receive once the user receives a notification.
      token = await FirebaseMessaging.instance.getToken();
      logger.d(token);
      final notificationSettings =
          await FirebaseMessaging.instance.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );
      logger.d(notificationSettings);

      // For apple platforms, ensure the APNS token is available before making any FCM plugin API calls
      final apnsToken = await FirebaseMessaging.instance.getAPNSToken();
      logger.d(apnsToken);
      if (apnsToken != null) {
        // APNS token is available, make FCM plugin API requests...
      }

      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        logger.d("message: ${message.notification?.title}");
        logger.d("message: ${message.notification?.body}");
        print('Got a message whilst in the foreground!');
        print('Message data: ${message.data}');

        if (message.notification != null) {
          print(
              'Message also contained a notification: ${message.notification}');
        }
      });
    } on Exception catch (e) {
      logger.e(e.toString());
      Get.snackbar(
        "initialFirebase",
        e.toString(),
        duration: Duration(seconds: 5),
      );
    }
  }

  @override
  void onInit() {
    initialFirebase();
    super.onInit();
  }
}
