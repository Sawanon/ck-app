import 'dart:async';
import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottery_ck/components/dialog.dart';
import 'package:lottery_ck/components/dialog_change_birthtime.dart';
import 'package:lottery_ck/model/lottery_date.dart';
import 'package:lottery_ck/model/response/get_my_friends.dart';
import 'package:lottery_ck/modules/appwrite/controller/appwrite.controller.dart';
import 'package:lottery_ck/modules/buy_lottery/controller/buy_lottery.controller.dart';
import 'package:lottery_ck/modules/layout/controller/layout.controller.dart';
import 'package:lottery_ck/modules/notification/controller/notification.controller.dart';
import 'package:lottery_ck/modules/notification/view/news.dart';
import 'package:lottery_ck/modules/point/view/buy_point.dart';
import 'package:lottery_ck/modules/setting/controller/setting.controller.dart';
import 'package:lottery_ck/modules/webview/view/webview.dart';
import 'package:lottery_ck/res/color.dart';
import 'package:lottery_ck/res/constant.dart';
import 'package:lottery_ck/route/route_name.dart';
import 'package:lottery_ck/storage.dart';
import 'package:lottery_ck/utils.dart';
import 'package:lottery_ck/utils/common_fn.dart';
import 'package:webview_flutter/webview_flutter.dart';

class HomeController extends GetxController {
  static HomeController get to => Get.find();

  Timer? _timer;
  DateTime? lotteryDate;

  String? lotteryDateStr;
  Rx<Duration> remainingDateTime = Duration.zero.obs;
  Alignment lotteryAlinment = Alignment.bottomCenter;
  RxList<Map> artworksList = <Map>[].obs;
  RxBool isLoadingLotteryDate = true.obs;
  RxList<Map> artWorksContent = <Map>[].obs;
  RxList<Map> wallpaperContent = <Map>[].obs;
  RxList<Map> bannerContent = <Map>[].obs;
  RxList<Map> videoContent = <Map>[].obs;
  LotteryDate? lotteryDateData;
  RxString wallpaperUrl = ''.obs;
  GetMyFriends? myFriends;
  // List<ListMyFriendsUser> listMyFriends = [];

  void lotteryFullScreen() {
    lotteryAlinment = Alignment.center;
    update();
  }

  void lotteryResetScreen() {
    lotteryAlinment = Alignment.bottomCenter;
    update();
  }

  void startCountdown(DateTime targetDateTime, DateTime currentDateTime) {
    final remain = targetDateTime.difference(currentDateTime);
    _timer?.cancel();
    if (remain.inSeconds < 0) {
      return;
    }
    remainingDateTime.value = remain;
    DateTime cloneCurrentDateTime = currentDateTime;
    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) async {
        if (remainingDateTime.value.inSeconds > 0) {
          remainingDateTime.value -= const Duration(seconds: 1);
          // logger.d("run ! ${remainingDateTime.value.inSeconds}");
          cloneCurrentDateTime =
              cloneCurrentDateTime.add(const Duration(seconds: 1));
          // logger.w(cloneCurrentDateTime);
          manageBuy(lotteryDateData, cloneCurrentDateTime);
          return;
        }
        manageBuy(lotteryDateData, cloneCurrentDateTime);
        logger.e("stop !");
        timer.cancel();
        await getLotteryDate();
      },
    );
  }

  void manageBuy(LotteryDate? lotteryDateData, DateTime now) async {
    final buyController = BuyLotteryController.to;
    if (lotteryDateData == null ||
        lotteryDateData.isCal ||
        lotteryDateData.isEmergency) {
      buyController.disableBuy();
      // logger.e("disable: 92");
      return;
    }
    // logger.d(lotteryDateData?.toJson());
    // final now = await getCurrentDatetime();
    // if (now == null) return;
    // final now = DateTime.parse("2024-10-28 20:10:00");
    final nowIsAfterStart = now.isAfter(lotteryDateData.startTime);
    final nowIsBeforeEnd = now.isBefore(lotteryDateData.endTime);
    // logger.d("nowIsAfterStart: $nowIsAfterStart");
    // logger.d("nowIsBeforeEnd: $nowIsBeforeEnd");
    if (nowIsAfterStart && nowIsBeforeEnd) {
      // logger.e("enable: 101");
      buyController.enableBuy();
    } else {
      // logger.e("disable: 103");
      buyController.disableBuy();
    }
  }

  Future<void> getLotteryDate() async {
    try {
      isLoadingLotteryDate.value = true;
      final now = await getCurrentDatetime();
      if (now == null) {
        Get.dialog(
          const DialogApp(
            title: Text(
              "Can't get current time from server",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
          ),
        );
        return;
      }
      // // FIXME: fake now remove on production
      // final now = DateTime.parse("2024-10-28 20:09:40");
      final nowLocal = now.toLocal();
      final nowMidnight =
          DateTime(nowLocal.year, nowLocal.month, nowLocal.day).toUtc();
      final appwriteController = AppWriteController.to;
      final lotteryDateDocument =
          await appwriteController.getLotteryDate(nowMidnight, now.toUtc());
      if (lotteryDateDocument == null) {
        lotteryDate = null;
        _timer?.cancel();
        update();
        return;
      }
      final lotteryDateData = LotteryDate.fromJson(lotteryDateDocument.data);
      // final lotteryDateData = LotteryDate(
      //   dateTime: DateTime.parse("2024-10-28 00:00:00"),
      //   startTime: DateTime.parse("2024-10-25 20:30:00"),
      //   endTime: DateTime.parse("2024-10-28 20:10:00"),
      //   active: true,
      //   isEmergency: false,
      //   isCal: false,
      //   isTransfer: false,
      // );
      this.lotteryDateData = lotteryDateData;
      if (lotteryDateData.isEmergency) {
        lotteryDate = null;
        update();
        return;
      }

      lotteryDate = lotteryDateData.dateTime.toLocal();
      lotteryDateStr = CommonFn.parseDMY(lotteryDateData.dateTime.toLocal());
      startCountdown(lotteryDateData.endTime, now);
      update();
    } catch (e) {
      logger.e(e.toString());
    } finally {
      isLoadingLotteryDate.value = false;
    }
  }

  Future<DateTime?> getCurrentDatetime() async {
    try {
      final dio = Dio();
      final url = "${AppConst.apiUrl}/currentTime";
      final response = await dio.get(url);
      // logger.d(response);
      final dateServer = response.headers['dateISO'];
      // logger.d("dateServer: $dateServer");
      if (dateServer?.isEmpty == true) {
        throw "date is not found";
      }
      final nowStr = dateServer![0];
      final now = DateTime.parse(nowStr);
      // TODO: fake date time for test - sawanon
      // final now = DateTime.now().add(const Duration(days: -5));
      return now;
    } catch (e) {
      logger.e(e.toString());
      Get.rawSnackbar(message: "⛔️ Can't get current time from server");
      return null;
    }
  }

  Future<void> listArtworks() async {
    final appwriteController = AppWriteController.to;
    final artworks = await appwriteController.listArtworks(6);
    logger.d(artworks);
    if (artworks == null) {
      return;
    }
    artworksList.value = artworks;
  }

  Future<void> getWallpaperBackground() async {
    final wallaper = await AppWriteController.to.getWallpaperBackground();
    logger.d("wallaper: $wallaper");
    if (wallaper == null) {
      return;
    }
    wallpaperUrl.value = wallaper['url'] as String;
  }

  void setup() async {
    await getLotteryDate();
    // await listArtworks();
    await listContent();
    await listBanner();
    // await setupMenu();
    await getWallpaperBackground();
    await SettingController.to.setup();
    await getMyFriends();
    // await listMyFriendsUser();
    await LayoutController.to.listBackgroundTheme();
    update();
  }

  void gotoBuyLottery() {
    LayoutController.to.changeTab(TabApp.lottery);
  }

  void gotoAnimal() {
    LayoutController.to.changeTab(TabApp.lottery);
    BuyLotteryController.to.gotoAnimalPage();
  }

  void gotoLotteryResult() {
    LayoutController.to.changeTab(TabApp.lottery);
    BuyLotteryController.to.chnageParentTab(1);
    // logger.d(BuyLotteryPage.keys.currentState);
    // BuyLotteryPage.keys.currentState?.changeTab(1);
    // BuyLotteryPage.key.currentState?.changeTab(1)
  }

  void gotoHoroScopeWithUnknowBirthTime() {
    gotoHoroScope(true);
    StorageController.to.setUnknowBirthTime(true);
  }

  void gotoRandomCard() async {
    // final userApp = LayoutController.to.userApp;
    final userApp = await AppWriteController.to.getUserApp();
    if (userApp == null) {
      LayoutController.to.showDialogLogin();
      return;
    }
    logger.d(userApp.userId);
    logger.d(userApp.point);
    final now = (DateTime.now().millisecondsSinceEpoch / 1000).toInt();
    final exp =
        (DateTime.now().add(Duration(minutes: 10)).millisecondsSinceEpoch /
                1000)
            .toInt();
    final payload2 = {
      "birthTime": userApp.birthTime,
      "birthday": CommonFn.parseYMD(userApp.birthDate),
      "iat": now,
      "exp": exp,
      "points": userApp.point.toString(),
      "userId": userApp.userId,
    };

    logger.d(payload2);
    final jwt = JWT(payload2);
    final payload = jwt.sign(
      SecretKey(AppConst.secretZZ),
      algorithm: JWTAlgorithm.HS384,
    );
    logger.d("https://staging.randomcards.pages.dev/?payload=$payload");
    Get.dialog(
      WebviewPage(),
      arguments: {
        'url': 'https://staging.randomcards.pages.dev/?payload=$payload',
        'onMessage': (JavaScriptMessage data) async {
          final dataMap = jsonDecode(data.message);
          logger.w(dataMap);
          final lottery = dataMap['number'];
          BuyLotteryController.to.buyAndGotoLotteryPage(
            lottery,
            () async {
              LayoutController.to.changeTab(TabApp.lottery);
              SettingController.to.getPoint();
              Get.back();
              Get.back();
              Get.back();
            },
          );
        },
        // 'url':
        //     'https://staging.daily-ce2.pages.dev/?payload=eyJhbGciOiJIUzM4NCIsInR5cCI6IkpXVCJ9.eyJiaXJ0aFRpbWUiOiIwMToyNCIsImJpcnRoZGF5IjoiMTk5Ni0wMy0yMiIsImlhdCI6MTcyODA0NjM5OCwiZXhwIjoxNzI4MzY2Nzc2LCJwb2ludHMiOiI5NSIsInVzZXJJZCI6IjY2ZmY1OWFiMDAyNjlmMGViYmM2In0.L5_O5vkQeWo7tlADAVRoCuk5cpdUN40v19oReu9AGa5YzFdpE68L-tg_wb7e15Ju',
      },
      useSafeArea: false,
    ).whenComplete(
      () async {
        SettingController.to.getPoint();
      },
    );
  }

  void gotoHoroScope([bool? isUnknowBirthTime]) async {
    // final userApp = LayoutController.to.userApp;
    final userApp = await AppWriteController.to.getUserApp();
    if (userApp == null) {
      LayoutController.to.showDialogLogin();
      return;
    }
    logger.d(userApp.userId);
    logger.d(userApp.point);
    if (isUnknowBirthTime != true) {
      if (userApp.birthTime == null || userApp.birthTime == "") {
        final isUnknowBirthTime =
            await StorageController.to.getUnknowBirthTime();
        logger.d(isUnknowBirthTime);
        if (isUnknowBirthTime == null) {
          Get.dialog(
            const DialogChangeBirthtimeComponent(),
          );
          return;
        }
      }
    }
    final now = (DateTime.now().millisecondsSinceEpoch / 1000).toInt();
    final exp =
        (DateTime.now().add(Duration(minutes: 10)).millisecondsSinceEpoch /
                1000)
            .toInt();
    final payload2 = {
      "birthTime": userApp.birthTime,
      "birthday": CommonFn.parseYMD(userApp.birthDate),
      "iat": now,
      "exp": exp,
      "points": userApp.point.toString(),
      "userId": userApp.userId,
    };

    logger.d(payload2);
    final jwt = JWT(payload2);
    final payload = jwt.sign(
      SecretKey(AppConst.secretZZ),
      algorithm: JWTAlgorithm.HS384,
    );
    logger.d("https://staging.daily-ce2.pages.dev/?payload=$payload");
    Get.dialog(
      WebviewPage(),
      arguments: {
        'url': 'https://staging.daily-ce2.pages.dev/?payload=$payload',
        // 'url':
        //     'https://staging.daily-ce2.pages.dev/?payload=eyJhbGciOiJIUzM4NCIsInR5cCI6IkpXVCJ9.eyJiaXJ0aFRpbWUiOiIwMToyNCIsImJpcnRoZGF5IjoiMTk5Ni0wMy0yMiIsImlhdCI6MTcyODA0NjM5OCwiZXhwIjoxNzI4MzY2Nzc2LCJwb2ludHMiOiI5NSIsInVzZXJJZCI6IjY2ZmY1OWFiMDAyNjlmMGViYmM2In0.L5_O5vkQeWo7tlADAVRoCuk5cpdUN40v19oReu9AGa5YzFdpE68L-tg_wb7e15Ju',
      },
      useSafeArea: false,
    );
  }

  Future<void> listBanner() async {
    final response = await AppWriteController.to.listBanner();
    if (response == null) {
      return;
    }
    logger.w("listBanner: $response");
    bannerContent.clear();
    List<Map<dynamic, dynamic>> _banner = [];
    for (var banner in response) {
      _banner.add(getContentUrlAndLink(banner));
    }
    bannerContent.addAll(_banner);
  }

  Future<void> listContent() async {
    try {
      artWorksContent.clear();
      wallpaperContent.clear();
      // bannerContent.clear();
      videoContent.clear();
      final contentList = await AppWriteController.to.listContent();
      if (contentList == null) return;
      List<Map> artworksList = [];
      for (var content in contentList) {
        // logger.d(content);
        switch (content['content_type']) {
          case 'artwork':
            final artworkContent = getContentUrlAndLink(content);
            artworksList.add(artworkContent);
            break;
          case 'wallpaper':
            wallpaperContent.add(content);
            break;
          // case 'banner':
          //   logger.w(content);
          //   final contentData = getContentUrlAndLink(content);
          //   // logger.d(contentData);
          //   bannerContent.add(contentData);
          //   break;
          case 'video':
            logger.d(content);
            final videoData = content['videos'];
            videoContent.add({
              "videoUrl":
                  "${AppConst.apiUrl}/upload/video/${videoData['fileName']}",
            });
          default:
        }
      }
      artWorksContent.value = artworksList;
    } catch (e) {
      logger.e("$e");
    }
    // logger.d(artWorksContent);
  }

  Map getContentUrlAndLink(Map content) {
    Map cloneContent = {};
    logger.w(content);
    switch (content['type']) {
      case 'news':
        final news = content['news'];
        cloneContent['name'] = news['name'];
        cloneContent['imageUrl'] = news['image'];
        cloneContent['getLink'] = '/news/${news['\$id']}';
        break;
      case 'promotions':
        final promotions = content['promotions'];
        if (promotions == null) {
          break;
        }
        cloneContent['name'] = promotions['name'];
        if (promotions['banner_image'] != null) {
          cloneContent['imageUrl'] = promotions['banner_image'];
        } else {
          cloneContent['imageUrl'] = promotions['image'];
        }
        cloneContent['getLink'] = '/promotion/${promotions['\$id']}';
        break;
      case 'points':
        final promotions = content['points'];
        cloneContent['name'] = promotions?['name'];
        cloneContent['imageUrl'] = promotions?['image'];
        cloneContent['getLink'] = '/point/${promotions['\$id']}';
        break;
      case "artworks":
        final artworks = content['artworks'];
        cloneContent['name'] = content['name'];
        cloneContent['imageUrl'] = artworks['url'];
        // cloneContent['getLink'] = 'dialog:/artwork/${artworks['\$id']}';
        break;
      case "wallpapers":
        final wallpapers = content['wallpapers'];
        cloneContent['name'] = content['name'];
        cloneContent['imageUrl'] = wallpapers['url'];
        // cloneContent['getLink'] = '/wallpaper/${wallpapers['\$id']}';
        break;
      default:
    }
    return cloneContent;
  }

  void onClickContent(String? link) async {
    // await Future.delayed(const Duration(seconds: 1), () {
    if (link != null) {
      logger.d(link);
      if (link.startsWith("/news")) {
        logger.d("goto news page");
        // LayoutController.to.changeTab(TabApp.notifications);
        final newsId = link.split("/").last;
        logger.d(newsId);
        Get.dialog(
          Center(
            child: Material(
              child: NewsDetailPage(
                isModal: true,
              ),
            ),
          ),
          arguments: {
            "newsId": newsId,
          },
        );
        // NotificationController.to.openNewsDetail(newsId);
      } else if (link.startsWith("/promotion")) {
        logger.d("goto news page");
        // LayoutController.to.changeTab(TabApp.notifications);
        final promotionId = link.split("/").last;
        logger.d(promotionId);
        NotificationController.to.openPromotionDetail(promotionId);
      } else if (link.startsWith("/point")) {
        logger.d("goto point page");
        LayoutController.to.changeTab(TabApp.notifications);
        final promotionPointId = link.split("/").last;
        NotificationController.to.openPromotionPointsDetail(promotionPointId);
      } else if (link.startsWith("/wallpaper")) {
        logger.d("goto wallpaper page");
        gotoWallPaperPage();
      } else if (link.startsWith("/artwork")) {
        //TODO: Declare remove
        logger.d("goto artwork page");
        // gotoWallPaperPage();
      } else if (link.startsWith("dialog")) {
        //TODO: Declare remove
        final path = link.split(":").last;
        logger.d(path);
      }
    }
    // });
  }

  void openImageFullscreen(String ulr) {
    Get.dialog(
      Center(
        child: Material(
          child: CachedNetworkImage(
            imageUrl: ulr,
            fit: BoxFit.fitWidth,
            progressIndicatorBuilder: (
              context,
              url,
              downloadProgress,
            ) =>
                Center(
              child: CircularProgressIndicator(
                value: downloadProgress.progress,
                color: AppColors.primary,
              ),
            ),
            errorWidget: (context, url, error) => const Icon(Icons.error),
          ),
        ),
      ),
    );
  }

  void gotoRandom() {
    Get.toNamed(RouteName.random);
  }

  void gotoWallPaperPage() {
    if (SettingController.to.user == null) {
      LayoutController.to.showDialogLogin();
      return;
    }
    Get.toNamed(RouteName.wallpaper);
  }

  Future<void> downloadWallpaper(String fileId, String bucketId) async {
    await AppWriteController.to.downLoadFile(bucketId, fileId);
    // logger.d('messageDownload');
    // logger.d(url);
    // await launchUrl(
    //   Uri.parse(url),
    //   mode: LaunchMode.externalApplication,
    // );
    // logger.d(bucketId);
    // logger.d(fileId);
    // AppWriteController.to.downloadFile(bucketId, fileId);
  }

  void goToNewsPage() {
    LayoutController.to.changeTab(TabApp.notifications);
  }

  void tryFunction() async {
    await AppWriteController.to.tryFunction();
  }

  void updateController() {
    update();
  }

  Future<void> getMyFriends() async {
    final user = SettingController.to.user;
    if (user == null) {
      return;
    }
    if (user.refCode == null) {
      logger.e("refCode is ${user.refCode}");
      return;
    }
    final response = await AppWriteController.to.getMyFriends(user.refCode!);
    if (response.isSuccess) {
      myFriends = response.data;
      update();
    } else {
      Get.dialog(
        DialogApp(
          title: Text("Something went wrong"),
          details: Text(response.message),
          disableConfirm: true,
        ),
      );
    }
  }

  // Future<void> listMyFriendsUser() async {
  //   final user = SettingController.to.user;
  //   if (user == null) {
  //     return;
  //   }
  //   if (user.refCode == null) {
  //     logger.e("refCode is ${user.refCode}");
  //     return;
  //   }
  //   final response =
  //       await AppWriteController.to.listMyFriendsUser(user.refCode!);
  //   if (response.isSuccess) {
  //     listMyFriends.clear();
  //     listMyFriends.addAll(response.data!);
  //     update();
  //   } else {
  //     Get.dialog(
  //       DialogApp(
  //         title: Text("Something went wrong"),
  //         details: Text(response.message),
  //         disableConfirm: true,
  //       ),
  //     );
  //   }
  // }

  void gotoNotification() async {
    LayoutController.to.changeTab(TabApp.settings);
    NotificationController.to.onChangeTab(2);
  }

  void gotoSetting() async {
    if (SettingController.to.user == null) {
      LayoutController.to.showDialogLogin();
      return;
    }
    Get.toNamed(RouteName.setting);
  }

  void gotoTopupPoint() async {
    if (SettingController.to.user == null) {
      LayoutController.to.showDialogLogin();
      return;
    }
    Get.to(
      () => const TopupPoint(),
      transition: Transition.rightToLeft,
    );
  }

  void gotoVideo() {
    if (SettingController.to.user == null) {
      LayoutController.to.showDialogLogin();
      return;
    }
    Get.toNamed(RouteName.videoMenu);
  }

  @override
  void onInit() {
    setup();
    super.onInit();
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }
}
