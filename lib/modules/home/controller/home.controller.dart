import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottery_ck/components/dialog_change_birthtime.dart';
import 'package:lottery_ck/modules/appwrite/controller/appwrite.controller.dart';
import 'package:lottery_ck/modules/buy_lottery/controller/buy_lottery.controller.dart';
import 'package:lottery_ck/modules/buy_lottery/view/buy_lottery.page.dart';
import 'package:lottery_ck/modules/history/controller/history_win.controller.dart';
import 'package:lottery_ck/modules/layout/controller/layout.controller.dart';
import 'package:lottery_ck/modules/notification/controller/notification.controller.dart';
import 'package:lottery_ck/modules/webview/view/webview.dart';
import 'package:lottery_ck/res/color.dart';
import 'package:lottery_ck/res/constant.dart';
import 'package:lottery_ck/route/route_name.dart';
import 'package:lottery_ck/storage.dart';
import 'package:lottery_ck/utils.dart';
import 'package:lottery_ck/utils/common_fn.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:video_player/video_player.dart';

class FakeLottery {
  Map data;

  FakeLottery({required this.data});
}

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

  void lotteryFullScreen() {
    lotteryAlinment = Alignment.center;
    update();
  }

  void lotteryResetScreen() {
    lotteryAlinment = Alignment.bottomCenter;
    update();
  }

  void startCountdown(DateTime targetDateTime, DateTime currentDateTime) {
    logger.d(targetDateTime);
    logger.d(currentDateTime);
    final remain = targetDateTime.difference(currentDateTime);
    if (_timer != null) {
      _timer?.cancel();
    }
    if (remain.inSeconds < 0) {
      return;
    }
    remainingDateTime.value = remain;
    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) async {
        if (remainingDateTime.value.inSeconds > 0) {
          remainingDateTime.value -= const Duration(seconds: 1);
          // logger.d("run ! ${remainingDateTime.value.inSeconds}");
          return;
        }
        logger.e("stop !");
        timer.cancel();
        await getLotteryDate();
      },
    );
  }

  Future<void> getLotteryDate() async {
    try {
      isLoadingLotteryDate.value = true;
      final now = await getCurrentDatetime();
      // final nowLocal = now!.toLocal();
      if (now == null) {
        Get.rawSnackbar(message: "Can't get date time from server");
        return;
      }
      // final todayMidnight =
      //     DateTime(nowLocal.year, nowLocal.month, nowLocal.day);
      final appwriteController = AppWriteController.to;
      final lotteryDateDocument = await appwriteController.getLotteryDate(now);
      logger.d(lotteryDateDocument?.data);
      final isEmergency = lotteryDateDocument?.data['is_emergency'];
      if (isEmergency) {
        this.lotteryDate = null;
        update();
        return;
      }
      // FIXME: is_emergency
      // final fakeLotteryDate = FakeLottery(data: {
      //   'end_time': '2024-10-22T03:42:00.373Z',
      //   'datetime': '2024-10-22T02:17:00.373Z',
      // });
      // final lotteryEndTimeISO = fakeLotteryDate.data['end_time'];
      // final lotteryDateISO = fakeLotteryDate.data['datetime'];
      final lotteryEndTimeISO = lotteryDateDocument?.data['end_time'];
      final lotteryDateISO = lotteryDateDocument?.data['datetime'];

      final lotteryEndTime = DateTime.parse(lotteryEndTimeISO);
      final lotteryDate = DateTime.parse(lotteryDateISO);
      final lotteryEndTimeLocal = lotteryEndTime.toLocal();
      logger.d(lotteryEndTimeLocal);
      this.lotteryDate = lotteryDate.toLocal();
      logger.f("$lotteryDate");
      lotteryDateStr = CommonFn.parseDMY(lotteryDate.toLocal());
      // final nowLocal = now.toLocal();
      startCountdown(lotteryEndTime, now);
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
      const url = "${AppConst.cloudfareUrl}/currentTime";
      logger.d(url);
      final response = await dio.get(url);
      final dateServer = response.headers['dateISO'];
      if (dateServer?.isEmpty == true) {
        throw "date is not found";
      }
      final nowStr = dateServer![0];
      // TODO: fake date time for test - sawanon
      final now = DateTime.parse(nowStr);
      // final now = DateTime.now().add(const Duration(days: -7));
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

  void setup() async {
    await getLotteryDate();
    // await listArtworks();
    await listContent();
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

  void gotoHoroScope([bool? isUnknowBirthTime]) async {
    // final userApp = LayoutController.to.userApp;
    final userApp = await AppWriteController.to.getUserApp();
    logger.d(userApp);
    if (userApp == null) {
      LayoutController.to.showDialogLogin();
      return;
    }
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

  Future<void> listContent() async {
    try {
      artWorksContent.clear();
      wallpaperContent.clear();
      bannerContent.clear();
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
          case 'banner':
            // logger.d(content);
            final contentData = getContentUrlAndLink(content);
            // logger.d(contentData);
            bannerContent.add(contentData);
            break;
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
    switch (content['type']) {
      case 'news':
        final news = content['news'];
        cloneContent['name'] = news['name'];
        cloneContent['imageUrl'] = news['image'];
        cloneContent['getLink'] = '/news/${news['\$id']}';
        break;
      case 'promotions':
        final promotions = content['promotions'];
        cloneContent['name'] = promotions['name'];
        cloneContent['imageUrl'] = promotions['image'];
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
        LayoutController.to.changeTab(TabApp.notifications);
        final newsId = link.split("/").last;
        logger.d(newsId);
        NotificationController.to.openNewsDetail(newsId);
      } else if (link.startsWith("/promotion")) {
        logger.d("goto news page");
        LayoutController.to.changeTab(TabApp.notifications);
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
    Get.toNamed(RouteName.wallpaper);
  }

  void downloadWallpaper(String url) async {
    logger.d('messageDownload');
    logger.d(url);
    await launchUrl(
      Uri.parse(url),
      mode: LaunchMode.externalApplication,
    );
    // logger.d(bucketId);
    // logger.d(fileId);
    // AppWriteController.to.downloadFile(bucketId, fileId);
  }

  void goToNewsPage() {
    LayoutController.to.changeTab(TabApp.notifications);
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
