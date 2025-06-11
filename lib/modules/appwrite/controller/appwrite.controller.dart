import 'dart:convert';

import 'package:appwrite/appwrite.dart';
import 'package:appwrite/enums.dart';
import 'package:appwrite/models.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:gal/gal.dart';
import 'package:get/get.dart';
import 'package:lottery_ck/components/dialog.dart';
import 'package:lottery_ck/components/gender_radio.dart';
import 'package:lottery_ck/main.dart';
import 'package:lottery_ck/model/bank.dart';
import 'package:lottery_ck/model/buy_lottery_configs.dart';
import 'package:lottery_ck/model/coupon.dart';
import 'package:lottery_ck/model/jwt.dart';
import 'package:lottery_ck/model/lottery.dart';
import 'package:lottery_ck/model/lottery_date.dart';
import 'package:lottery_ck/model/news.dart';
import 'package:lottery_ck/model/notification.dart';
import 'package:lottery_ck/model/point_can_use.dart';
import 'package:lottery_ck/model/point_topup.dart';
import 'package:lottery_ck/model/respnose_verifypasscode.dart';
import 'package:lottery_ck/model/response/bytedance_get_snapshot.dart';
import 'package:lottery_ck/model/response/bytedance_get_video_info.dart';
import 'package:lottery_ck/model/response/bytedance_list_video.dart';
import 'package:lottery_ck/model/response/bytedance_response.dart';
import 'package:lottery_ck/model/response/find_influencer.dart';
import 'package:lottery_ck/model/response/get_current_time.dart';
import 'package:lottery_ck/model/response/get_my_friends.dart';
import 'package:lottery_ck/model/response/get_otp.dart';
import 'package:lottery_ck/model/response/get_user_by_ref_code.dart';
import 'package:lottery_ck/model/response/get_wheel_active.dart';
import 'package:lottery_ck/model/response/list_my_friends_user.dart';
import 'package:lottery_ck/model/response/response_api.dart';
import 'package:lottery_ck/model/response/signup.dart';
import 'package:lottery_ck/model/special_reward.dart';
import 'package:lottery_ck/model/user.dart';
import 'package:lottery_ck/model/user_point.dart';
import 'package:lottery_ck/modules/appwrite/controller/savefile.dart';
import 'package:lottery_ck/modules/firebase/controller/firebase_messaging.controller.dart';
import 'package:lottery_ck/modules/layout/controller/layout.controller.dart';
import 'package:lottery_ck/res/app_locale.dart';
import 'package:lottery_ck/res/constant.dart';
import 'package:lottery_ck/storage.dart';
import 'package:lottery_ck/utils.dart';
import "package:collection/collection.dart";
import 'package:lottery_ck/utils/common_fn.dart';
import 'dart:typed_data';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';
import 'dart:io' as io;
import 'package:path/path.dart' as path;

class AppWriteController extends GetxController {
  static const String _databaseName = 'lottory';
  static const String USER = 'user';
  static const String TRANSACTION = '_transaction';
  static const String INVOICE = '_invoice';
  static const String ACCUMULATE = '_accumulate';
  static const String LOTTERY_DATE = 'lottery_date';
  static const String BANK = 'bank';
  static const String NEWS = 'news';
  static const String PROMOTION = 'promotions';
  static const String POINTS = 'points';
  static const String FEEDBACK = 'feedbacks';
  static const String ARTWORKS = 'artworks';
  static const String USER_POINT = 'user_points';
  static const String CONTENT_MANAGEMENT = 'content_management';
  static const String QUOTAS = 'quotas';
  static const String QYC_USER = 'kyc_users';
  static const String SETTINGS = 'settings';
  static const String BACKGROUND_THEME = '6768df870033004ee896';
  static const String APP_WALLPAPERS = 'appWallpapers';
  static const String COUPON = '67762ef9003b9b51c763';
  static const String GROUP_USER = 'group_users';
  static const String WHEEL_PROMOTION = 'wheel_promotions';
  static const String WHEEL_USER = 'wheel_users';

  static const String FN_SIGNIN = '6759aebe003c92a6fa81';
  static const String FN_LOTTERY_DATE = '67949bd30000dc05f940';
  static const String FN_GET_TIME = '6841389000233c734ab1';

  static const String TOPIC_ALL_USER = '66d2abc9003c1c06ac97';

  static const _roleUserId = "669a2cfd00141edc45ef";
  final String _providerId = '66d28d4000300a1e7dc1';
  static AppWriteController get to => Get.find();
  late Account account;
  late Databases databases;
  late Storage storage;
  late Functions functions;
  late Messaging messaging;
  Client client = Client();

  Future<User> get user async => await account.get();

  Future<void> getAuthJWTToken() async {
    try {
      logger.w("apiUrl: ${AppConst.apiUrl}");
      final dio = Dio();
      final jwt = JWT({
        "token": AppConst.publicToken,
      });
      // final secretKey = await StorageController.to.getSecretKey();
      const secretKey = AppConst.secret;
      final token =
          jwt.sign(SecretKey(secretKey), algorithm: JWTAlgorithm.HS384);
      final response = await dio.post(
        "${AppConst.apiUrl}/auth",
        data: {
          "appVersion": AppConst.appVersion,
        },
        options: Options(headers: {
          "Authorization": "Bearer $token",
        }),
      );
      if (response.data["jwt"] == null) {
        throw "jwt not found";
      }
      // logger.d(response.data["jwt"]);
      await StorageController.to.setAppToken(response.data);
    } on DioException catch (e) {
      logger.e("$e");
      if (e.response != null) {
        logger.e(e.response?.statusCode);
        logger.e(e.response?.statusMessage);
        logger.e(e.response?.data);
        logger.e(e.response?.headers);
        logger.e(e.response?.requestOptions);
      }
    }
  }

  Future<Session?> login(String email, String password) async {
    try {
      final session = await account.createEmailPasswordSession(
        email: email,
        password: password,
      );
      await clearOtherSession(session.$id);
      await createTarget();
      final storageController = StorageController.to;
      storageController.setSessionId(session.$id);
      return session;
    } on Exception catch (e) {
      logger.e(e.toString());
      Get.snackbar(
        "Something went wrong appwrite:74",
        "Please try again later or plaese contact admin",
      );
      return null;
    }
    // setState(() {
    //   loggedInUser = user;
    // });
  }

  Future<void> createTarget() async {
    try {
      final tokenFirebase = await FirebaseMessagingController.to.getToken();
      logger.w("tokenFirebase: $tokenFirebase");
      final target = await account.createPushTarget(
        targetId: ID.unique(),
        identifier: tokenFirebase!,
        providerId: _providerId,
      );
      logger.d(target.providerType);
      await StorageController.to.setTargetPush(target.$id);
    } catch (e) {
      logger.e(e);
    }
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
        "Something went wrong plaese try again later appwrite:137",
        'or plaese contact admin',
      );
      return false;
    }
  }

  Future<void> logout() async {
    try {
      await account.deleteSession(sessionId: 'current');
      await StorageController.to.clear();
      LayoutController.to.clearState();
      await StorageController.to.removeTargetPush();
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

  Future<List<Bank>?> listBank() async {
    try {
      final bankDocumentList = await databases.listDocuments(
          databaseId: _databaseName,
          collectionId: BANK,
          queries: [
            Query.select(["name", "logo", "\$id", "full_name"]),
            Query.equal('status', true),
          ]);
      final bankList = bankDocumentList.documents.map(
        (document) {
          return Bank.fromJson(document.data);
        },
      ).toList();
      return bankList;
    } catch (e) {
      logger.e(e.toString());
      Get.snackbar('Something went wrong appwrite:174',
          'Bank: please try again later or contact admin');
      return null;
    }
  }

  Future<Bank?> getBankById(String? bankId) async {
    try {
      if (bankId == null) return null;
      final bankDocument = await databases.getDocument(
        databaseId: _databaseName,
        collectionId: BANK,
        documentId: bankId,
      );
      return Bank.fromJson(bankDocument.data);
    } catch (e) {
      logger.e("$e");
      return null;
    }
  }

  Future<Document?> createInvoice(
    int amount,
    String bankId,
    String lotteryDate,
  ) async {
    try {
      final user = await account.get();
      return await databases.createDocument(
        databaseId: _databaseName,
        collectionId: "$lotteryDate$INVOICE",
        documentId: ID.unique(),
        data: {
          "bankId": bankId,
          "totalAmount": amount,
          "userId": user.$id,
        },
      );
    } catch (e) {
      logger.e(e.toString());
      Get.snackbar(
        'Something went wrong appwrite:215',
        'Invoice: please try again later or contact admin',
      );
      return null;
    }
  }

  Future<Document?> updateInvoice(String documentId, String lotteryDateStr,
      List<String> listTransactionId) async {
    try {
      return await databases.updateDocument(
        databaseId: _databaseName,
        collectionId: "$lotteryDateStr$INVOICE",
        documentId: documentId,
        data: {
          "transactionId": listTransactionId,
        },
      );
    } catch (e) {
      logger.e("$e");
      return null;
    }
  }

  Future<Document?> createTransaction(
    Lottery lottery,
    String lotteryDate,
    String bankId,
    Map<String, String?> digitMap,
  ) async {
    try {
      final user = await account.get();
      return await databases.createDocument(
        databaseId: _databaseName,
        collectionId: "$lotteryDate$TRANSACTION",
        documentId: ID.unique(),
        data: {
          "lottery": lottery.lottery,
          "lotteryType": lottery.type,
          "amount": lottery.amount,
          "bankId": bankId,
          "userId": user.$id,
          ...digitMap,
        },
      );
    } catch (e) {
      logger.e("$e");
      return null;
    }
  }

  Future<Document> getLotteryDateById(String lotteryDateId) async {
    return await databases.getDocument(
      databaseId: _databaseName,
      collectionId: LOTTERY_DATE,
      documentId: lotteryDateId,
    );
  }

  Future<Document?> getLotteryDate(DateTime datetime, DateTime now) async {
    try {
      final response = await databases.listDocuments(
        databaseId: _databaseName,
        collectionId: LOTTERY_DATE,
        queries: [
          Query.greaterThanEqual('datetime', datetime.toIso8601String()),
          Query.greaterThan('end_time', now.toIso8601String()),
          Query.orderAsc('datetime'),
          Query.equal('active', true),
          // Query.equal('is_emergency', false),
          Query.limit(1),
        ],
      );
      if (response.documents.isEmpty) {
        throw "Lottery date is empty";
      }
      return response.documents[0];
    } catch (e) {
      logger.e(e.toString());
      return null;
    }
  }

  Future<Document?> addAccumulate(
    String lotteryStr,
    Lottery lottery,
    String transactionId,
  ) async {
    try {
      final accumulateDocumentList = await databases.listDocuments(
        databaseId: _databaseName,
        collectionId: "$lotteryStr$ACCUMULATE",
        queries: [
          Query.equal("lottery", lottery.lottery),
        ],
      );
      if (accumulateDocumentList.documents.isEmpty) {
        return await databases.createDocument(
          databaseId: _databaseName,
          collectionId: "$lotteryStr$ACCUMULATE",
          documentId: ID.unique(),
          data: {
            "lottery": lottery.lottery,
            "amount": lottery.amount,
            "lotteryType": lottery.type,
            "lastFiveTransactions": [transactionId],
            // "updateBy": "?"
          },
        );
      }
      final accumulateDocument = accumulateDocumentList.documents.first;
      final lastFiveTransactions =
          (accumulateDocument.data["lastFiveTransactions"] as List);
      lastFiveTransactions.add(transactionId);
      return await databases.updateDocument(
        databaseId: _databaseName,
        collectionId: "$lotteryStr$ACCUMULATE",
        documentId: accumulateDocumentList.documents.first.$id,
        data: {
          "amount": lottery.amount + accumulateDocument.data['amount'],
          "lastFiveTransactions":
              lastFiveTransactions, //TODO: Should be reverse ?
        },
      );
    } catch (e) {
      logger.e("$e");
      return null;
    }
  }

  Future<void> clearOtherSession(String currentSessionId) async {
    try {
      final sessions = await account.listSessions();
      // List<String> sessionIds = [];
      for (var sesssion in sessions.sessions) {
        if (currentSessionId == sesssion.$id) {
          logger.f("skip!");
          continue;
        }
        logger.d("delete session");
        await account.deleteSession(sessionId: sesssion.$id);
      }
      // account.deleteSession(sessionId: )
    } catch (e) {
      logger.e("$e");
    }
  }

  Future<List<LotteryDate>?> listLotteryBuyDate() async {
    try {
      final listLotteryDate = await databases.listDocuments(
        databaseId: _databaseName,
        collectionId: LOTTERY_DATE,
        queries: [
          Query.equal('active', true),
          Query.equal('is_emergency', false),
          Query.lessThanEqual(
              'start_time', DateTime.now().toUtc().toIso8601String()),
          Query.orderDesc("datetime"),
          Query.limit(10),
        ],
      );
      logger.w("total: ${listLotteryDate.documents.length}");
      List<LotteryDate> lotteryDateList = [];
      for (var lotteryDateDocument in listLotteryDate.documents) {
        final lotteryDate = LotteryDate.fromJson(lotteryDateDocument.data);
        lotteryDateList.add(lotteryDate);
      }
      logger.w("final total: ${lotteryDateList.length}");
      return lotteryDateList;
    } catch (e) {
      logger.e("$e");
      return null;
    }
  }

  Future<List<LotteryDate>?> listLotteryDate() async {
    try {
      final listLotteryDate = await databases.listDocuments(
        databaseId: _databaseName,
        collectionId: LOTTERY_DATE,
        queries: [
          Query.equal('active', true),
          Query.equal('is_emergency', false),
          Query.lessThanEqual(
              'start_time', DateTime.now().toUtc().toIso8601String()),
          Query.orderDesc("datetime"),
          Query.limit(10),
        ],
      );
      List<LotteryDate> lotteryDateList = [];
      bool isGreatOne = false;
      // int count = 0;
      for (var lotteryDateDocument in listLotteryDate.documents) {
        // count++;
        // if (count == 10) break;
        final lotteryDate = LotteryDate.fromJson(lotteryDateDocument.data);
        lotteryDateList.add(lotteryDate);
        // logger.d(lotteryDate.endTime.toString());
        if (lotteryDate.endTime.isAfter(DateTime.now())) {
          isGreatOne = true;
        }
        if (isGreatOne) {
          logger.d("break !");
          break;
        }
      }
      // listLotteryDate.documents.map((lotteryDate) {

      //   return lotterDate;
      // }).toList();
      return lotteryDateList;
    } catch (e) {
      logger.e("$e");
      return null;
    }
  }

  Future<DocumentList?> getHistoryBuy(String lotteryStr) async {
    try {
      final user = await account.get();
      final historyBuy = await databases.listDocuments(
        databaseId: _databaseName,
        collectionId: "$lotteryStr$INVOICE",
        queries: [
          Query.equal(
            "userId",
            user.$id,
          ),
          Query.equal("status", "paid"),
          Query.isNotNull("status"),
          Query.orderDesc('\$createdAt'),
        ],
      );
      logger.d(historyBuy.total);
      return historyBuy;
    } catch (e) {
      logger.e("$e");
      return null;
    }
  }

  Future<Document?> getTransactionById(
      String transactionId, String lotteryDateStr) async {
    try {
      return databases.getDocument(
        databaseId: _databaseName,
        collectionId: "$lotteryDateStr$TRANSACTION",
        documentId: transactionId,
        // queries: [
        //   Query.equal('status', 'paid'),
        // ],
      );
    } catch (e) {
      logger.e("$e");
      return null;
    }
  }

  Future<UserApp?> getUserApp() async {
    try {
      final user = await account.get();
      final userFromDatabase = await databases.getDocument(
        databaseId: _databaseName,
        collectionId: USER,
        documentId: user.$id,
      );
      final userMap = userFromDatabase.data;
      logger.w("userMap");
      logger.w(userMap);
      return UserApp.fromJson(userMap);
      // return UserApp(
      //   firstName: userMap['firstname'],
      //   lastName: userMap['lastname'],
      //   phoneNumber: userMap['phone'],
      // );
    } catch (e) {
      logger.e("$e");
      return null;
    }
  }

  Future<Document?> getInvoice(String invoiceId, String lotteryStr) async {
    try {
      logger.d("$lotteryStr$INVOICE");
      return await databases.getDocument(
        databaseId: _databaseName,
        collectionId: "$lotteryStr$INVOICE",
        documentId: invoiceId,
      );
    } catch (e) {
      logger.e("$e");
      return null;
    }
  }

  Future<String?> getPasscode() async {
    try {
      final user = await account.get();
      final userDocument = await databases.getDocument(
        databaseId: _databaseName,
        collectionId: USER,
        documentId: user.$id,
      );
      return userDocument.data["passcode"];
    } catch (e) {
      logger.e("$e");
      return null;
    }
  }

  Future<List<News>?> listNews(List<String> groupIds) async {
    try {
      final now = DateTime.now().toUtc();
      final newsDocumentList = await databases.listDocuments(
        databaseId: _databaseName,
        collectionId: NEWS,
        queries: [
          Query.equal("is_active", true),
          Query.equal("is_approve", "3"),
          Query.contains('group_user', groupIds),
          Query.greaterThanEqual("end_date", now.toIso8601String()),
          Query.orderDesc('start_date'),
          Query.limit(25),
        ],
      );
      final newsList = newsDocumentList.documents.map(
        (document) {
          return News.fromJson(document.data);
        },
      ).toList();
      return newsList;
    } catch (e) {
      logger.e("$e");
      return null;
    }
  }

  Future<List<Map>?> listPromotionsPoints() async {
    try {
      final now = DateTime.now().toUtc();
      final promotionsPointsDocumentList = await databases.listDocuments(
        databaseId: _databaseName,
        collectionId: POINTS,
        queries: [
          Query.equal("is_active", true),
          Query.equal("is_approve", "3"),
          Query.greaterThanEqual("end_date", now.toIso8601String()),
          Query.orderDesc('start_date'),
          Query.limit(25),
        ],
      );
      final promotionList = promotionsPointsDocumentList.documents.map(
        (document) {
          return document.data;
        },
      ).toList();
      return promotionList;
    } catch (e) {
      logger.e("$e");
      return null;
    }
  }

  Future<List<Map>?> listPromotions(List<String> groupIds) async {
    try {
      final now = DateTime.now().toUtc();
      final promotionsDocumentList = await databases.listDocuments(
        databaseId: _databaseName,
        collectionId: PROMOTION,
        queries: [
          Query.equal("is_active", true),
          Query.equal("is_approve", "3"),
          Query.contains('group_user', groupIds),
          Query.greaterThanEqual("end_date", now.toIso8601String()),
          Query.orderDesc('start_date'),
          Query.limit(25),
        ],
      );
      List<Map> promotionList = promotionsDocumentList.documents.map(
        (document) {
          return document.data;
        },
      ).toList();
      return promotionList;
    } catch (e) {
      logger.e("$e");
      return null;
    }
  }

  Future<News?> getNews(String newsId) async {
    try {
      final newsDocument = await databases.getDocument(
        databaseId: _databaseName,
        collectionId: NEWS,
        documentId: newsId,
      );
      return News.fromJson(newsDocument.data);
    } catch (e) {
      logger.e("$e");
      return null;
    }
  }

  Future<Map?> getPromotion(String promotionId) async {
    try {
      final newsDocument = await databases.getDocument(
        databaseId: _databaseName,
        collectionId: PROMOTION,
        documentId: promotionId,
      );
      return newsDocument.data;
    } catch (e) {
      logger.e("$e");
      return null;
    }
  }

  Future<Map?> getPromotionPoint(String promotionPointId) async {
    try {
      final promotionPointDocument = await databases.getDocument(
        databaseId: _databaseName,
        collectionId: POINTS,
        documentId: promotionPointId,
      );
      return promotionPointDocument.data;
    } catch (e) {
      logger.e("$e");
      return null;
    }
  }

  Future<List?> listLotteryCollection(String lotteryMonth) async {
    try {
      final response = await functions.createExecution(
        functionId: FN_LOTTERY_DATE,
        body: jsonEncode({
          "lotteryMonth": lotteryMonth,
        }),
        method: ExecutionMethod.pOST,
        path: "/",
      );
      logger.w(response.responseBody);
      final result = jsonDecode(response.responseBody);
      return result['collectionList'];
      // final token = await getCredential();
      // final dio = Dio();
      // final response = await dio.post(
      //   "${AppConst.cloudfareUrl}/listLotteryCollections",
      //   data: {
      //     "lotteryMonth": lotteryMonth,
      //   },
      //   options: Options(
      //     headers: {"Authorization": "Bearer $token"},
      //   ),
      // );
      // logger.w("response: ${response.data}");
      // return response.data["collectionList"];
    } catch (e) {
      logger.e("$e");
      return null;
    }
  }

  Future<Map?> getLotteryHistory(String lotteryHistoryId) async {
    try {
      final lotteryHistory = await databases.getDocument(
        databaseId: _databaseName,
        collectionId: "lottery_historys",
        documentId: lotteryHistoryId,
      );
      logger.d(lotteryHistory.data);
      return lotteryHistory.data;
    } catch (e) {
      logger.e("$e");
      return null;
    }
  }

  Future<List?> listWinInvoices(String collectionId) async {
    try {
      final userId = await user.then((value) => value.$id);
      // const userId = "67edf7a800193b9b4180"; // p nat
      // const userId = "680b37540010c6d7e604"; // p nueg
      final invoiceList = await databases.listDocuments(
        databaseId: _databaseName,
        collectionId: collectionId,
        queries: [
          Query.or([
            Query.equal("is_win", true),
            Query.equal("is_special_win", true),
          ]),
          Query.equal("userId", userId),
          Query.orderDesc('\$createdAt'),
        ],
      );
      final lotteryDateStr = collectionId.split("_").first;
      for (var invoice in invoiceList.documents) {
        List transactionList = [];
        for (var transactionId in invoice.data["transactionId"]) {
          final transaction =
              await getTransactionById(transactionId, lotteryDateStr);
          if (transaction!.data["lottery_history_id"] != null) {
            logger.w(transaction.data["lottery_history_id"]);
            final lotteryHistory =
                await getLotteryHistory(transaction.data["lottery_history_id"]);
            logger.w("lotteryHistory: $lotteryHistory");
            transaction.data["lotteryHistory"] = lotteryHistory;
          }
          transactionList.add(transaction.data);
        }
        invoice.data["transactionList"] = transactionList;
      }
      return invoiceList.documents.map((invoice) {
        return invoice.data;
      }).toList();
    } catch (e) {
      logger.e("$e");
      return null;
    }
  }

  Future<String> getCredential() async {
    final userId = await user.then((value) => value.$id);
    final sessionId = await StorageController.to.getSessionId();
    // logger.d("userId: $userId");
    // logger.d("sessionId: $sessionId");
    if (sessionId == null) {
      logger.e("sessionId is null");
      await logout();
    }
    final credential = "$sessionId:$userId";
    final bearer = base64Encode(utf8.encode(credential));
    return bearer;
  }

  Future<void> detaulGroupUser(String userId) async {
    try {
      final allUser = await databases.listDocuments(
        databaseId: _databaseName,
        collectionId: GROUP_USER,
        queries: [
          Query.equal("name", "All User"),
          Query.limit(1),
        ],
      );
      final usersIdList = allUser.documents.first.data["userId"] as List;
      if (usersIdList.where((_userId) => _userId == userId).isNotEmpty) {
        logger.w("has in group");
        return;
      }
      logger.w("not has in group");
      final allUserGroup = await databases.getDocument(
        databaseId: _databaseName,
        collectionId: GROUP_USER,
        documentId: allUser.documents.first.$id,
      );
      final oldArray = allUserGroup.data["userId"];
      await databases.updateDocument(
        databaseId: _databaseName,
        collectionId: GROUP_USER,
        documentId: allUser.documents.first.$id,
        data: {
          "userId": [
            ...oldArray,
          ],
        },
      );
    } catch (e) {
      logger.e("$e");
    }
  }

  Future<List?> listLotteryHistory() async {
    try {
      final lotteryHistoryDocumentList = await databases.listDocuments(
        databaseId: _databaseName,
        collectionId: "lottery_historys",
        queries: [
          Query.select(["lottery_date_id", "lottery"]),
          Query.orderDesc('\$createdAt'),
          Query.equal('is_approve', '3'),
          Query.limit(25),
        ],
      );
      List lotteryHistoryList = [];
      final lotteryHistoryListData =
          lotteryHistoryDocumentList.documents.map((document) => document.data);
      logger.d("lotteryHistoryListData:934");
      logger.w(lotteryHistoryListData);
      var newMap =
          groupBy(lotteryHistoryListData, (Map obj) => obj['lottery_date_id']);
      for (var lotteryByDate in newMap.entries) {
        lotteryByDate.value.sort(
          (a, b) {
            final prev = int.parse(a['lottery'].first);
            final next = int.parse(b['lottery'].first);
            if (prev < next) {
              return 1;
            } else if (prev > next) {
              return -1;
            }
            return 0;
          },
        );
        final lotteryDateDocument = await getLotteryDateById(
            lotteryByDate.value.first["lottery_date_id"]);
        final lotteryDate = CommonFn.parseDMY(
            DateTime.parse(lotteryDateDocument.data["datetime"]).toLocal());
        String lottery = lotteryByDate.value.first["lottery"].first as String;
        if (lottery.length < 6) {
          final zero = List.generate(6 - lottery.length, (index) => 'x');
          lottery = "${zero.join("")}$lottery";
        } else {
          lotteryHistoryList.add({
            "lottery": lottery,
            "lotteryDate": lotteryDate,
            "lotteryDateId": lotteryByDate.value.first["lottery_date_id"],
          });
        }
      }
      return lotteryHistoryList;
    } catch (e) {
      logger.e("$e");
      return null;
    }
  }

  Future<bool> isActiveUser([String? phoneNumber]) async {
    try {
      if (phoneNumber != null) {
        final userDocumentList = await databases.listDocuments(
          databaseId: _databaseName,
          collectionId: USER,
          queries: [
            Query.equal("phone", phoneNumber),
            Query.select(["active"]),
            Query.limit(1),
          ],
        );
        final userDocument = userDocumentList.documents.first;
        return userDocument.data["active"];
      }
      final userId = await user.then((user) => user.$id);
      final userDocument = await databases.getDocument(
        databaseId: _databaseName,
        collectionId: USER,
        documentId: userId,
      );
      return userDocument.data["active"];
    } catch (e) {
      logger.e("$e");
      return false;
    }
  }

  Future<Document?> feedBackApp(double rate, String? comment) async {
    try {
      final userId = await user.then((value) => value.$id);
      return await databases.createDocument(
          databaseId: _databaseName,
          collectionId: FEEDBACK,
          documentId: ID.unique(),
          data: {
            "users": userId,
            "rate": rate,
            "comment": comment,
          });
    } catch (e) {
      logger.e("$e");
      return null;
    }
  }

  Future<List<BuyLotteryConfigs>?> listBuyLotteryConfigs() async {
    try {
      final buyLotteryConfigDocumentList = await databases.listDocuments(
        databaseId: _databaseName,
        collectionId: "buy_lottery_configs",
      );
      List<BuyLotteryConfigs> buyLotteryConfigList = [];
      for (var buyLotteryConfig in buyLotteryConfigDocumentList.documents) {
        buyLotteryConfigList
            .add(BuyLotteryConfigs.fromJson(buyLotteryConfig.data));
      }
      return buyLotteryConfigList;
    } catch (e) {
      logger.e("$e");
      return null;
    }
  }

  Future<Map?> listSettings() async {
    try {
      final settingList = await databases.listDocuments(
        databaseId: _databaseName,
        collectionId: "app_settings",
        queries: [
          Query.limit(1),
        ],
      );
      return settingList.documents.first.data;
    } catch (e) {
      logger.e("$e");
      return null;
    }
  }

  Future<ResponseVerifyPasscode?> verifyPasscode(
      String passcode, String userId) async {
    try {
      // final userIdInAppwriteSDK = await user.then((value) => value.$id);
      // final token = await getCredential();
      // logger.d("token: $token");
      logger.d("verify passcode !!!");
      final appToken = await getAppJWT();
      final dio = Dio();
      final url = "${AppConst.apiUrl}/user/passcode/verify";
      final payload = {
        "passcode": passcode,
        "userId": userId,
      };
      logger.d(url);
      logger.d(payload);
      final response = await dio.post(
        url,
        data: payload,
        options: Options(headers: {
          "Authorization": "Bearer $appToken",
        }),
      );
      logger.d(response.data);
      return ResponseVerifyPasscode.fromJson(response.data);
      // } catch (e) {
      //   logger.e("$e");
      //   return null;
      // }
    } on DioException catch (e) {
      // The request was made and the server responded with a status code
      // that falls out of the range of 2xx and is also not 304.
      if (e.response != null) {
        logger.e(e.response?.statusCode);
        logger.e(e.response?.statusMessage);
        logger.e(e.response?.data);
        logger.e(e.response?.headers);
        logger.e(e.response?.requestOptions);
        try {
          return ResponseVerifyPasscode.fromJson(e.response?.data);
        } catch (e) {
          logger.e("$e");
          return null;
        }
      } else {
        // Something happened in setting up or sending the request that triggered an Error
        logger.e(e.requestOptions);
        logger.e(e.message);
      }
      return null;
    } catch (e) {
      logger.e("$e");
      return null;
    }
  }

  Future<ResponseSignup?> signUp(
    String username,
    String firstName,
    String lastName,
    String email,
    String phone,
    String address,
    DateTime birthDate,
    TimeOfDay? birthTime,
    Gender gender,
  ) async {
    try {
      logger.d("signUp");
      final dio = Dio();
      final response = await dio.post("${AppConst.apiUrl}/user/sign-up", data: {
        "username": username,
        "firstName": firstName,
        "lastName": lastName,
        "email": email,
        "phone": phone,
        "address": address,
        "birthDate": birthDate.toIso8601String(),
        "birthTime":
            birthTime == null ? null : CommonFn.parseTimeOfDayToHMS(birthTime),
        "gender": gender.name,
      });
      logger.d("response: ${response.data}");
      if (response.data["status"] == false) {
        throw "create user failed";
      }
      return ResponseSignup(
          user: User.fromMap(response.data["user"]),
          secret: response.data["secret"]);
    } on DioException catch (e) {
      logger.e("$e");
      if (e.response != null) {
        logger.e(e.response?.statusCode);
        logger.e(e.response?.statusMessage);
        logger.e(e.response?.data);
      }
      return null;
    } catch (e) {
      logger.e("$e");
      return null;
    }
  }

  Future<String> getAppJWT() async {
    final appToken = await StorageController.to.getAppToken();
    // if (appToken == null) throw "app token is empty";
    if (appToken == null) {
      final appJWT = await refreshToken();
      return appJWT.jwt;
    }
    if (appToken.expire
        .isBefore(DateTime.now().add(const Duration(seconds: 30)))) {
      // refresh token
      logger.w("refresh token");
      final appJWT = await refreshToken();
      return appJWT.jwt;
    }
    return appToken.jwt;
  }

  Future<AppJWT> refreshToken() async {
    final dio = Dio();
    final jwt = JWT({
      "token": AppConst.publicToken,
    });
    // final secretKey = await StorageController.to.getSecretKey();
    const secretKey = AppConst.secret;
    final token = jwt.sign(SecretKey(secretKey), algorithm: JWTAlgorithm.HS384);
    final response = await dio.post(
      "${AppConst.apiUrl}/auth",
      data: {
        "appVersion": AppConst.appVersion,
      },
      options: Options(headers: {
        "Authorization": "Bearer $token",
      }),
    );
    if (response.data["jwt"] == null) {
      throw "jwt not found";
    }
    await StorageController.to.setAppToken(response.data);
    return AppJWT.fromJSON(response.data);
  }

  Future<Map<String, dynamic>?> getToken(String phoneNumber) async {
    try {
      final dio = Dio();
      final jwt = await getAppJWT();
      final response = await dio.post(
        // "${AppConst.cloudfareUrl}/sign-in",
        "${AppConst.apiUrl}/user/sign-in",
        data: {
          "phoneNumber": phoneNumber,
        },
        options: Options(headers: {
          "Authorization": "Bearer $jwt",
        }),
      );
      return response.data;

      // final response = await functions.createExecution(
      //   functionId: FN_SIGNIN,
      //   method: ExecutionMethod.pOST,
      //   path: '/',
      //   body: jsonEncode(
      //     {
      //       'phoneNumber': phoneNumber,
      //     },
      //   ),
      // );
      // logger.d(response.responseBody);
      // return jsonDecode(response.responseBody);
    } on DioException catch (e) {
      // The request was made and the server responded with a status code
      // that falls out of the range of 2xx and is also not 304.
      if (e.response != null) {
        logger.e(e.response?.statusCode);
        logger.e(e.response?.statusMessage);
        logger.e(e.response?.data);
        logger.e(e.response?.headers);
        logger.e(e.response?.requestOptions);
        try {
          final error = jsonDecode(e.response?.data['message']);
          logger.e(error);
        } catch (e) {
          return null;
        }
      } else {
        // Something happened in setting up or sending the request that triggered an Error
        logger.e(e.requestOptions);
        logger.e(e.message);
      }
      return null;
    }
  }

  Future<Session?> createSession(String userId, String secret) async {
    try {
      await createTarget();
      final session = await account.createSession(
        userId: userId,
        secret: secret,
      );
      await clearOtherSession(session.$id);
      final storageController = StorageController.to;
      storageController.setSessionId(session.$id);
      return session;
    } on Exception catch (e) {
      logger.e(e);
      Get.snackbar("createSession failed", e.toString());
      return null;
    }
  }

  Future<List?> listCurrentActivePromotions() async {
    try {
      final dio = Dio();
      final token = await getCredential();
      final response = await dio.get(
        "${AppConst.apiUrl}/promotion",
        options: Options(
          headers: {
            "Authorization": "Bearer $token",
          },
        ),
      );
      return response.data['promotionList'];
    } catch (e) {
      logger.e("$e");
      return null;
    }
  }

  Future<String?> updateUserAddress(String address) async {
    try {
      final dio = Dio();
      final token = await getCredential();
      final response = await dio.post(
        "${AppConst.apiUrl}/user/address",
        data: {
          "address": address,
        },
        options: Options(
          headers: {
            "Authorization": "Bearer $token",
          },
        ),
      );
      logger.d(response.data);
      return response.data["address"];
    } catch (e) {
      logger.e("$e");
      return null;
    }
  }

  Future<String?> updateUserPhone(String phone, String userId) async {
    try {
      final dio = Dio();
      final token = await getCredential();
      final response = await dio.post(
        "${AppConst.apiUrl}/user/phone",
        data: {
          "phone": phone,
        },
        options: Options(
          headers: {
            "Authorization": "Bearer $token",
          },
        ),
      );
      final responseChangeAuthPhone = await dio.post(
        "${AppConst.apiUrl}/user/change-phone",
        data: {
          "userId": "",
          "phone": phone,
        },
      );
      logger.w(responseChangeAuthPhone.data);
      // if (response.data["phone"] != null) {
      //   final me = await user;
      //   final response =
      //       await account.updatePhone(phone: phone, password: me.password!);
      //   final email = '$phone@ckmail.com';
      //   final responseUpdateEmail =
      //       await account.updateEmail(email: email, password: me.password!);
      //   logger.w(response.phone);
      //   logger.w(responseUpdateEmail.email);
      // }
      // logger.d(response.data);
      return responseChangeAuthPhone.data?.toString();
    } catch (e) {
      logger.e("$e");
      return null;
    }
  }

  Future<void> intialTokenToStorage() async {
    try {
      Get.put<StorageController>(StorageController());
      // await StorageController.to.setSecretKey(AppConst.secret);
      getAuthJWTToken();
    } catch (e) {
      logger.e("$e");
    }
  }

  void setUp() async {
    client
        .setEndpoint(AppConst.endPoint)
        .setProject(AppConst.appwriteProjectId)
        .setSelfSigned(status: true);
    account = Account(client);
    databases = Databases(client);
    storage = Storage(client);
    functions = Functions(client);
    messaging = Messaging(client);
    await intialTokenToStorage();
  }

  Future<List<Map>?> listArtworks(int limit) async {
    try {
      final artworksDocumentList = await databases.listDocuments(
        databaseId: _databaseName,
        collectionId: ARTWORKS,
        queries: [
          Query.limit(limit),
          Query.equal("active", true),
          // Query.orderDesc("createdAt"),
        ],
      );
      final artworksList = artworksDocumentList.documents
          .map((artwork) => artwork.data)
          .toList();
      return artworksList;
    } catch (e) {
      logger.e("$e");
      return null;
    }
  }

  Future<Map> changePasscode(String passcode, String userId) async {
    try {
      final dio = Dio();
      final jwt = await getAppJWT();
      final response = await dio.post(
        '${AppConst.apiUrl}/user/passcode/change-passcode',
        data: {
          "passcode": passcode,
          "userId": userId,
        },
        options: Options(headers: {
          'Authorization': 'Bearer $jwt',
        }),
      );
      logger.d(response.data);
      return {
        "status": true,
      };
    } on Exception catch (e) {
      logger.e(e.toString());
      Get.snackbar('Something went wrong pin:28', 'Plaese try again later');
      return {
        "status": false,
      };
    }
  }

  Future<List<UserPoint>?> listUserPoint(int offset) async {
    try {
      final userId = await user.then((user) => user.$id);
      final userPointDocumentList = await databases.listDocuments(
        databaseId: _databaseName,
        collectionId: USER_POINT,
        queries: [
          Query.equal("userId", userId),
          Query.orderDesc("\$createdAt"),
          Query.limit(10),
          Query.offset(offset),
        ],
      );
      logger.d(userPointDocumentList.total);
      final userPointList = userPointDocumentList.documents
          .map((e) => UserPoint.fromJson(e.data))
          .toList();
      return userPointList;
    } catch (e) {
      logger.e("$e");
      return null;
    }
  }

  Future<List?> listBanner() async {
    try {
      final bannerDocumentList = await databases.listDocuments(
        databaseId: _databaseName,
        collectionId: CONTENT_MANAGEMENT,
        queries: [
          Query.equal('is_approve', '1'),
          Query.equal('is_active', true),
          Query.equal('content_type', 'banner'),
          Query.or([
            Query.greaterThanEqual(
                'expire', DateTime.now().toUtc().toIso8601String()),
            Query.isNull('expire'),
          ]),
          Query.orderDesc('\$createdAt'),
          Query.limit(100),
        ],
      );
      return bannerDocumentList.documents
          .map((document) => document.data)
          .toList();
    } catch (e) {
      logger.e("$e");
      return null;
    }
  }

  Future<List<Map>?> listContent() async {
    try {
      final contentDocumentList = await databases.listDocuments(
        databaseId: _databaseName,
        collectionId: CONTENT_MANAGEMENT,
        queries: [
          Query.equal('is_approve', '1'),
          Query.equal('is_active', true),
          Query.or([
            Query.greaterThanEqual(
                'expire', DateTime.now().toUtc().toIso8601String()),
            Query.isNull('expire'),
          ]),
          Query.orderDesc('\$createdAt'),
          Query.limit(100),
        ],
      );
      // logger.d(contentDocumentList.documents);
      // for (var content in contentDocumentList.documents) {
      //   logger.d(content.data);
      // }
      logger.w(contentDocumentList.total);
      return contentDocumentList.documents.map((e) => e.data).toList();
    } catch (e) {
      logger.e("$e");
      return null;
    }
  }

  void downloadFile(String bucketId, String fileId) async {
    // Uint8List test = '';
    // Uint8List.fromList()
    // Uint8List.formatString('fullText', 'args');
    Uint8List bytes = await storage.getFileDownload(
      bucketId: bucketId,
      fileId: fileId,
    );
    await saveFile(bytes);

    // final file = File($id: );
    // file.writeAsBytesSync(bytes);
  }

  Future<Uint8List?> getProfileImage(String fileId) async {
    try {
      final fileStorage = await storage.getFilePreview(
        bucketId: "user_images",
        fileId: fileId,
        width: 720,
        // height: 100,
        quality: 80,
        rotation: 0,
      );
      final image = img.decodeImage(fileStorage);
      final orientedImage = img.bakeOrientation(image!);
      final fixedImageData = Uint8List.fromList(img.encodePng(orientedImage));
      return fixedImageData;
    } catch (e) {
      logger.e("$e");
      return null;
    }
  }

  Future<String?> changeProfileImage(String path) async {
    try {
      // final userId = await user.then((e) => e.$id);
      final user = await getUserApp();
      if (user == null) throw "User not found";
      if (user.profile != null && user.profile != "") {
        final fileId = user.profile!.split(":").last;
        await storage.deleteFile(
          bucketId: 'user_images',
          fileId: fileId,
        );
      }
      final fileData = await storage.createFile(
        bucketId: 'user_images',
        // fileId: ID.unique(),
        fileId: user.userId,
        file: InputFile.fromPath(path: path),
      );
      final profile = "user_images:${fileData.$id}";
      await databases.updateDocument(
        databaseId: _databaseName,
        collectionId: USER,
        documentId: user.userId,
        data: {"profile": profile},
      );
      return profile;
    } catch (e) {
      logger.e("$e");
      return null;
    }
  }

  Future<Document?> changeName(String firstName, String lastName) async {
    try {
      final userId = await user.then((e) => e.$id);
      return await databases.updateDocument(
        databaseId: _databaseName,
        collectionId: USER,
        documentId: userId,
        data: {
          "firstname": firstName,
          "lastname": lastName,
        },
      );
    } catch (e) {
      logger.e("$e");
      return null;
    }
  }

  Future<Document?> changeBirth(DateTime birthDate, String birthTime) async {
    try {
      final userId = await user.then((e) => e.$id);
      return await databases.updateDocument(
        databaseId: _databaseName,
        collectionId: USER,
        documentId: userId,
        data: {
          "birthDate": birthDate.toString(),
          "birthTime": birthTime,
        },
      );
    } catch (e) {
      logger.e("$e");
      return null;
    }
  }

  Future<DocumentList?> getQuota() async {
    try {
      final quotaDocumentList = databases.listDocuments(
        databaseId: _databaseName,
        collectionId: QUOTAS,
      );
      return quotaDocumentList;
    } catch (e) {
      logger.e("$e");
      return null;
    }
  }

  Future<Map?> getKYC(String userId) async {
    try {
      final qycData = await databases.listDocuments(
        databaseId: _databaseName,
        collectionId: QYC_USER,
        queries: [
          Query.equal("userId", userId),
        ],
      );
      final data = qycData.documents.first;
      return data.data;
    } catch (e) {
      logger.e("$e");
      return null;
    }
  }

  Future<ResponseApi<int?>> getPointRaio() async {
    try {
      final pointRatioDocumentList = await databases.listDocuments(
        databaseId: _databaseName,
        collectionId: SETTINGS,
        queries: [
          Query.equal('type', 'pointConvert'),
          Query.limit(1),
        ],
      );
      final result =
          jsonDecode(pointRatioDocumentList.documents.first.data['setting']);
      final pointRaio = int.parse(result['amount']);
      return ResponseApi(
        isSuccess: true,
        message: "Successfully to get point raio",
        data: pointRaio,
      );
    } catch (e) {
      logger.e("$e");
      return ResponseApi(
        isSuccess: false,
        message: "Failed to get point raio",
      );
    }
  }

  Future<List<Lottery>?> listTransactionByInvoiceId(
      String invoiceId, String lotteryStr) async {
    try {
      final transactionDocumentList = await databases.listDocuments(
        databaseId: _databaseName,
        collectionId: "$lotteryStr$TRANSACTION",
        queries: [
          Query.equal("invoiceId", invoiceId),
        ],
      );
      final transactionListMap =
          transactionDocumentList.documents.map((transaction) {
        return Lottery.fromJson(transaction.data);
      }).toList();
      return transactionListMap;
    } catch (e) {
      logger.e("$e");
      return null;
    }
  }

  Future<ResponseGetOTP?> getOTP(String phoneNumber) async {
    try {
      final dio = Dio();
      final response = await dio.post(
        "${AppConst.apiUrl}/user/otp",
        data: {
          'phoneNumber': phoneNumber,
        },
      );
      final result = response.data;
      logger.w("result: $result");
      if (result['isError'] == true) throw "Error OTP service";
      logger.d("result: $result");
      final otpRef = result['data']['otpRef'];
      final otp = result['data']['otp'];
      return ResponseGetOTP(otpRef: otpRef, otp: otp);
    } on DioException catch (e) {
      if (e.response != null) {
        logger.e(e.response?.statusCode);
        logger.e(e.response?.statusMessage);
        logger.e(e.response?.data);
        logger.e(e.response?.headers);
        logger.e(e.response?.requestOptions);
        Get.dialog(
          DialogApp(
            title: const Text("Network error"),
            details: Text(
                'code:${e.response?.statusCode ?? '-'} message:${e.response?.statusMessage ?? '-'}'),
            disableConfirm: true,
          ),
        );
      }
      return null;
    } catch (e) {
      Get.dialog(
        DialogApp(
          title: const Text("Something went wrong"),
          details: Text(
            '$e',
          ),
          disableConfirm: true,
        ),
      );
      return null;
    }
  }

  Future<bool> confirmOTP(String phoneNumber, String otp, String otpRef) async {
    try {
      final dio = Dio();
      final response = await dio.post(
        "${AppConst.apiUrl}/user/otp/verify",
        data: {
          "phoneNumber": phoneNumber,
          "otp": otp,
          "otpRef": otpRef,
        },
      );
      final data = response.data;
      logger.d(data);
      if (data['status'] != "success") {
        return false;
      }
      return true;
    } on DioException catch (e) {
      if (e.response != null) {
        logger.e(e.response?.statusCode);
        logger.e(e.response?.statusMessage);
        logger.e(e.response?.data);
        logger.e(e.response?.headers);
        logger.e(e.response?.requestOptions);
        Get.dialog(
          DialogApp(
            title: const Text("Network error"),
            details: Text(
                'code:${e.response?.statusCode ?? '-'} message:${e.response?.statusMessage ?? '-'}'),
            disableConfirm: true,
          ),
        );
      }
      return false;
    }
  }

  Future<ResponseApi<ResponseGetOTP?>> getOTPUser(String phoneNumber) async {
    try {
      final dio = Dio();
      final response = await dio.post(
        "${AppConst.apiUrl}/otp",
        data: {
          'phone': phoneNumber,
        },
      );
      final result = response.data;
      logger.d(result);

      if (result['isError'] == true) {
        if (result['code'] == 409) {
          return ResponseApi(
              isSuccess: false,
              message: AppLocale.rateLimit.getString(Get.context!));
        }
        return ResponseApi(
            isSuccess: false,
            message: result['message'] ?? "OTP request failed");
      }
      return ResponseApi(
        isSuccess: true,
        message: "Successfully request OTP",
        data: ResponseGetOTP(
          otpRef: result['data']['otpRef'],
          otp: result['data']['otp'],
        ),
      );
    } on DioException catch (e) {
      if (e.response != null) {
        logger.e(e.response?.statusCode);
        logger.e(e.response?.statusMessage);
        logger.e(e.response?.data);
        // Get.dialog(
        //   DialogApp(
        //     title: const Text("Network error"),
        //     details: Text(
        //         'code:${e.response?.statusCode ?? '-'} message:${e.response?.statusMessage ?? '-'}'),
        //     disableConfirm: true,
        //   ),
        // );
        return ResponseApi(
          isSuccess: false,
          message: e.response?.statusMessage ?? "OTP request failed",
        );
      }
      return ResponseApi(
        isSuccess: false,
        message: "OTP request failed",
      );
    }
  }

  Future<Map?> confirmOTPUser(String userId, String otp, String otpRef) async {
    try {
      final dio = Dio();
      final response = await dio.post(
        "${AppConst.apiUrl}/otp/verify",
        data: {
          "userId": userId,
          "otp": otp,
          "otpRef": otpRef,
        },
      );
      final result = response.data;
      logger.w(result);
      if (result['isError'] == true) {
        Get.dialog(
          DialogApp(
            title: Text("Code: ${result['code']}"),
            details: Text("${result['message']}"),
          ),
        );
        return null;
      }
      return response.data;
    } on DioException catch (e) {
      if (e.response != null) {
        logger.e(e.response?.statusCode);
        logger.e(e.response?.statusMessage);
        logger.e(e.response?.data);
        logger.e(e.response?.headers);
        logger.e(e.response?.requestOptions);
        Get.dialog(
          DialogApp(
            title: const Text("Network error"),
            details: Text(
                'code:${e.response?.statusCode ?? '-'} message:${e.response?.statusMessage ?? '-'}'),
            disableConfirm: true,
          ),
        );
      }
      return null;
    }
  }

  Future<void> tryFunction() async {
    try {
      final result = await functions.createExecution(
        functionId: '6752ab8a003970b1d5bf',
        method: ExecutionMethod.pOST,
        path: '/',
      );
      logger.d(result);
      logger.d(result.responseBody);
      final response = jsonDecode(result.responseBody);
      logger.d(response);
    } catch (e) {
      logger.e("$e");
    }
  }

  Future<Map?> getWallpaperBackground() async {
    try {
      final now = DateTime.now().toUtc().toIso8601String();
      final response = await databases.listDocuments(
        databaseId: _databaseName,
        collectionId: APP_WALLPAPERS,
        queries: [
          Query.equal('is_active', true),
          Query.equal('approve', '3'),
          Query.lessThanEqual('start_date', now),
          Query.greaterThanEqual("end_date", now),
          Query.limit(1),
        ],
      );
      if (response.documents.isNotEmpty) {
        return response.documents.first.data;
      }
      return null;
    } catch (e) {
      logger.e("$e");
      return null;
    }
  }

  Future<List<String>?> getBackgroundTheme() async {
    try {
      final now = DateTime.now().toUtc().toIso8601String();
      final response = await databases.listDocuments(
        databaseId: _databaseName,
        collectionId: BACKGROUND_THEME,
        queries: [
          Query.equal('approve', '3'),
          Query.lessThanEqual('start_date', now),
          Query.greaterThanEqual("end_date", now),
        ],
      );
      // for (var document in response.documents) {
      //   logger.d("data: ${document.data}");
      // }
      if (response.documents.isEmpty) return null;
      return response.documents
          .map((document) => document.data['url'] as String)
          .toList();
    } catch (e) {
      logger.e("$e");
      return null;
    }
  }

  Future<ResponseApi<ResponseGetUserByRefCode?>> getUserByRefCode(
      String refCode) async {
    try {
      final dio = Dio();
      final response = await dio.post(
        '${AppConst.apiInviteFriends}/getUser',
        data: {
          "ref_code": refCode,
        },
        options: Options(
          headers: {
            "accept-language": localization.currentLocale?.languageCode,
          },
        ),
      );
      final result = response.data;
      return ResponseApi(
        isSuccess: true,
        message: 'Successfully get user by ref code',
        data: ResponseGetUserByRefCode.fromJson(result['data']),
      );
    } on DioException catch (e) {
      logger.e("$e");
      if (e.response != null) {
        logger.e(e.response?.statusCode);
        logger.e(e.response?.statusMessage);
        logger.e(e.response?.data);
        logger.e(e.response?.headers);
        logger.e(e.response?.requestOptions);
        return ResponseApi(
            isSuccess: false,
            message:
                e.response?.statusMessage ?? "failed to get user by ref code");
      }
      return ResponseApi(
          isSuccess: false, message: "failed to get user by ref code");
    }
  }

  Future<ResponseApi<void>> connectFriend(
      String referrer, String referee) async {
    try {
      final dio = Dio();
      logger.w(localization.currentLocale?.languageCode);
      final response = await dio.post(
        "${AppConst.apiInviteFriends}/connectFriend",
        data: {
          "referrer": referrer,
          "referee": referee,
        },
        options: Options(
          headers: {
            "accept-language": localization.currentLocale?.languageCode,
          },
        ),
      );
      logger.w(response.data);
      return ResponseApi(
        isSuccess: true,
        message: "Successfully conect with friend",
      );
    } on DioException catch (e) {
      logger.e("$e");
      if (e.response != null) {
        logger.e(e.response?.statusCode);
        logger.e(e.response?.statusMessage);
        logger.e(e.response?.data);
        final String? message =
            e.response?.data['message'] ?? e.response?.statusMessage;
        return ResponseApi(
          isSuccess: false,
          message: message ?? "failed to with connect friend",
        );
      }
      return ResponseApi(
        isSuccess: false,
        message: "failed to with connect friend",
      );
    } catch (e) {
      logger.e("$e");
      // return null;
      return ResponseApi(
        isSuccess: false,
        message: "failed to with connect friend",
      );
    }
  }

  Future<ResponseApi<Map?>> acceptFriend(
      String referrer, String referee) async {
    try {
      final dio = Dio();
      final response = await dio.post(
        "${AppConst.apiInviteFriends}/accept",
        data: {
          "referrer": referrer,
          "referee": referee,
        },
        options: Options(
          headers: {
            "accept-language": localization.currentLocale?.languageCode,
          },
        ),
      );
      logger.w(response.data);
      return ResponseApi(
        isSuccess: true,
        message: "Accept friend successfully",
        data: response.data,
      );
    } on DioException catch (e) {
      logger.e("$e");
      if (e.response != null) {
        logger.e(e.response?.statusCode);
        logger.e(e.response?.statusMessage);
        logger.e(e.response?.data);
        return ResponseApi(
            isSuccess: false,
            message: e.response?.statusMessage ?? "failed to accept friend");
      }
      // return null;
      return ResponseApi(isSuccess: false, message: "failed to accept friend");
    }
  }

  Future<ResponseApi<GetMyFriends?>> getMyFriends(String refCode) async {
    try {
      final option = BaseOptions(
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
      );
      final dio = Dio(option);
      final response = await dio.get(
        "${AppConst.apiInviteFriends}/myFriends/$refCode",
        options: Options(
          headers: {
            "lang": localization.currentLocale?.languageCode,
          },
        ),
      );
      return ResponseApi(
        isSuccess: true,
        message: "Successfully",
        data: GetMyFriends.fromJson(
          response.data['data'],
        ),
      );
    } on DioException catch (e) {
      logger.e("$e");
      if (e.response != null) {
        logger.e(e.response?.statusCode);
        logger.e(e.response?.statusMessage);
        logger.e(e.response?.data);
        final message = e.response?.statusMessage ?? e.response?.data?['error'];
        return ResponseApi(
            isSuccess: false, message: message ?? "failed to get your friends");
      }
      // return null;
      return ResponseApi(
          isSuccess: false, message: "failed to get your friends");
    }
  }

  Future<ResponseApi<List<ListMyFriendsUser>?>> listMyFriendsUser(
      String refCode) async {
    try {
      final option = BaseOptions(
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
      );
      final dio = Dio(option);
      logger.w("refCode: $refCode");
      final response = await dio.get(
        "${AppConst.apiInviteFriends}/myFriends/listUser/$refCode",
        options: Options(
          headers: {
            "lang": localization.currentLocale?.languageCode,
          },
        ),
      );
      final resultList = response.data['data'] as List;
      return ResponseApi(
          isSuccess: true,
          message: "Successfully list friends user",
          data: resultList
              .map((result) => ListMyFriendsUser.fromJson(result))
              .toList());
    } on DioException catch (e) {
      logger.e("$e");
      if (e.response != null) {
        logger.e(e.response?.statusCode);
        logger.e(e.response?.statusMessage);
        logger.e(e.response?.data);
        return ResponseApi(
            isSuccess: false,
            message: e.response?.statusMessage ?? "failed to get your friends");
      }
      // return null;
      return ResponseApi(
          isSuccess: false, message: "failed to get your friends");
    }
  }

  Future<void> test() async {
    // 20250103_invoice
    final response = await databases.listDocuments(
      databaseId: _databaseName,
      collectionId: "20250103_invoice",
    );
    logger.w(response);
  }

  Future<ResponseApi<Map?>> collectCoupons(
    String promotionId,
    String userId,
  ) async {
    try {
      final dio = Dio();
      final token = await getCredential();
      final payload = {
        "promotionId": promotionId,
        "userId": userId,
      };
      logger.d(payload);
      final url = "${AppConst.apiUrl}/promotion/coupon";
      logger.d(url);
      final response = await dio.post(url,
          data: payload,
          options: Options(
            headers: {"Authorization": "Bearer $token"},
          ));
      logger.w(response.data);
      return ResponseApi(
        isSuccess: true,
        message: "Successfully collect coupons",
        data: response.data,
      );
    } on DioException catch (e) {
      logger.e("$e");
      if (e.response != null) {
        logger.e(e.response?.statusCode);
        logger.e(e.response?.statusMessage);
        logger.e(e.response?.data);
        return ResponseApi(
          isSuccess: false,
          message: e.response?.statusMessage ?? "failed to collect coupons",
        );
      }
      // return null;
      return ResponseApi(
        isSuccess: false,
        message: "failed to collect coupons",
      );
    }
  }

  Future<ResponseApi<List<Coupon>?>> listAllMyCoupons(String userId) async {
    try {
      final response = await databases.listDocuments(
        databaseId: _databaseName,
        collectionId: COUPON,
        queries: [
          Query.equal("userId", userId),
        ],
      );
      final coupons = response.documents
          .map((document) => Coupon.fromJson(document.data))
          .toList();
      return ResponseApi(
        isSuccess: true,
        message: "Successfully list all my coupons",
        data: coupons,
      );
    } on AppwriteException catch (e) {
      logger.e("$e");
      return ResponseApi(
        isSuccess: false,
        message: e.message ?? "failed to list all my coupongs",
      );
    }
  }

  Future<ResponseApi<List<Coupon>?>> listMyCoupons(String userId) async {
    try {
      final now = DateTime.now().toUtc().toIso8601String();
      final response = await databases.listDocuments(
        databaseId: _databaseName,
        collectionId: COUPON,
        queries: [
          Query.equal("userId", userId),
          Query.equal("is_use", false),
          Query.greaterThanEqual("expire_date", now),
        ],
      );
      final coupons = response.documents
          .map((document) => Coupon.fromJson(document.data))
          .toList();
      return ResponseApi(
        isSuccess: true,
        message: "Successfully list my coupons",
        data: coupons,
      );
    } on AppwriteException catch (e) {
      logger.e("$e");
      return ResponseApi(
        isSuccess: false,
        message: e.message ?? "failed to list my coupongs",
      );
    }
  }

  Future<ResponseApi<List<Map>?>> listPromotionDetail(
      List<String> promotionIdsList) async {
    try {
      final response = await databases.listDocuments(
        databaseId: _databaseName,
        collectionId: PROMOTION,
        queries: [
          Query.equal('\$id', promotionIdsList),
          Query.select(
            [
              '\$id',
              'name',
              'start_date',
              'end_date',
              'detail',
              'is_need_kyc',
              'max_user',
              'current_use',
            ],
          ),
        ],
      );
      return ResponseApi(
        isSuccess: true,
        message: "Successfully list promotion detail",
        data: response.documents.map((document) => document.data).toList(),
      );
    } on AppwriteException catch (e) {
      logger.e("$e");
      return ResponseApi(
        isSuccess: false,
        message: e.message ?? "failed to list promotion detail",
      );
    }
  }

  Future<ResponseApi<Map?>> applyCoupon({
    required String lotteryDate,
    required String invoiceId,
    required List<String> couponIdsList,
    String? bankId,
  }) async {
//     api เลือกคูปอง
// POST
// header Bearer token
// /api/payment/summary
// {
//           lotteryDate : string,
//           invoiceId : string,
//           couponId : string[]
//          }
    try {
      final dio = Dio();
      final token = await getCredential();
      final payload = {
        "lotteryDate": lotteryDate,
        "invoiceId": invoiceId,
        "couponId": couponIdsList,
      };
      if (bankId != null) {
        payload["bankId"] = bankId;
      }
      logger.d(payload);
      final response = await dio.post("${AppConst.apiUrl}/payment/summary",
          data: payload,
          options: Options(
            headers: {"Authorization": "Bearer $token"},
          ));
      logger.w(response.data);

      return ResponseApi(
        isSuccess: true,
        message: "Successfully apply coupon",
        data: response.data,
      );
    } on DioException catch (e) {
      logger.e("$e");
      if (e.response != null) {
        logger.e(e.response?.statusCode);
        logger.e(e.response?.statusMessage);
        logger.e(e.response?.data);
        return ResponseApi(
            isSuccess: false,
            message: e.response?.statusMessage ?? "failed to apply coupon");
      }
      return ResponseApi(isSuccess: false, message: "failed to apply coupon");
    }
  }

  Future<ResponseApi<NotificationDataModel?>> listNotification(
    String userId, [
    int limit = 0,
    int page = 1,
  ]) async {
    try {
      final dio = Dio();
      final payload = {
        "userId": userId,
        "limit": limit,
        "page": page,
      };
      logger.w(payload);
      final response = await dio.post(
        "${AppConst.apiUrl}/notification/get-noti",
        data: payload,
      );
      logger.d(response.data);
      final result = response.data;

      // final notificationList = response.data
      return ResponseApi(
        isSuccess: true,
        message: "message",
        data: NotificationDataModel.fromJson(result),
      );
    } on DioException catch (e) {
      logger.e("$e");
      if (e.response != null) {
        logger.e(e.response?.statusCode);
        logger.e(e.response?.statusMessage);
        logger.e(e.response?.data);
        return ResponseApi(
          isSuccess: false,
          message: e.response?.statusMessage ?? "failed to apply coupon",
        );
      }
      return ResponseApi(isSuccess: false, message: "failed to apply coupon");
    } catch (e) {
      logger.e("$e");
      return ResponseApi(isSuccess: false, message: "$e");
    }
  }

  Future<ResponseApi<PointCanUse?>> getPointCanUseOnInvoice() async {
    try {
      final pointRatioDocumentList = await databases.listDocuments(
        databaseId: _databaseName,
        collectionId: SETTINGS,
        queries: [
          Query.equal('type', 'pointUse'),
          Query.limit(1),
        ],
      );
      final setting =
          jsonDecode(pointRatioDocumentList.documents.first.data['setting']);
      return ResponseApi(
        isSuccess: true,
        message: "Successfully to get point can use on invoice",
        data: PointCanUse.fromJson(setting),
      );
    } on AppwriteException catch (e) {
      return ResponseApi(
        isSuccess: false,
        message: e.message ?? "code: ${e.code}",
      );
    } catch (e) {
      logger.e("$e");
      return ResponseApi(
        isSuccess: false,
        message: "failed to get point can use on invoice",
      );
    }
  }

  Future<ResponseApi<BytedanceGetSnapshotResponse?>> getSnapshot(
      String videoId) async {
    try {
      final dio = Dio();
      final response = await dio.post(
        "${AppConst.apiUrl}/video/getSnapshot",
        data: {
          "videoId": videoId,
        },
      );
      logger.w(response.data);
      return ResponseApi(
        isSuccess: true,
        message: "Successfully to get snapshot",
        data: BytedanceGetSnapshotResponse.fromJson(response.data),
      );
    } on DioException catch (e) {
      logger.e("$e");
      if (e.response != null) {
        logger.e(e.response?.statusCode);
        logger.e(e.response?.statusMessage);
        logger.e(e.response?.data);
        return ResponseApi(
          isSuccess: false,
          message: e.response?.statusMessage ?? "failed to get snapshot",
        );
      }
      return ResponseApi(
        isSuccess: false,
        message: "failed to get snapshot",
      );
    } catch (e) {
      return ResponseApi(
        isSuccess: false,
        message: "$e",
      );
    }
  }

  Future<ResponseApi<BytedanceGetVideoInfo?>> getVideoInfo(
    String videoId,
    String definition,
  ) async {
    try {
      final response = await Dio().post(
        "${AppConst.apiUrl}/video/getVideoInfo",
        data: {
          "videoId": videoId,
          'definition': definition,
        },
      );
      return ResponseApi(
        isSuccess: true,
        message: "Successfully to get video info",
        data: BytedanceGetVideoInfo.fromJson(response.data),
      );
    } on DioException catch (e) {
      logger.e("$e");
      if (e.response != null) {
        logger.e(e.response?.statusCode);
        logger.e(e.response?.statusMessage);
        logger.e(e.response?.data);
        return ResponseApi(
          isSuccess: false,
          message: e.response?.statusMessage ?? "failed to get video info",
        );
      }
      return ResponseApi(
        isSuccess: false,
        message: "failed to get video info",
      );
    } catch (e) {
      logger.e("$e");
      return ResponseApi(
        isSuccess: false,
        message: "failed to get video info",
      );
    }
  }

  Future<ResponseApi<ByteDanceListVideo?>> listVideo(String? categoryId) async {
    try {
      final dio = Dio();
      Map payload = {};
      if (categoryId != null) {
        payload = {
          "categoryId": categoryId,
        };
      }
      final response = await dio.post(
        "${AppConst.apiUrl}/video/listVideo",
        data: payload,
      );
      return ResponseApi(
        isSuccess: true,
        message: "Successfully to list video",
        data: ByteDanceListVideo.fromJson(response.data),
      );
    } on DioException catch (e) {
      logger.e("$e");
      if (e.response != null) {
        logger.e(e.response?.statusCode);
        logger.e(e.response?.statusMessage);
        logger.e(e.response?.data);
        return ResponseApi(
          isSuccess: false,
          message: e.response?.statusMessage ?? "failed to list video",
        );
      }
      return ResponseApi(
        isSuccess: false,
        message: "failed to list video",
      );
    }
  }

  Future<ResponseApi<BytedanceResponse?>> listCategories() async {
    try {
      final dio = Dio();
      final response = await dio.get(
        "${AppConst.apiUrl}/video/listCategories",
      );
      final responseClass = BytedanceResponse.fromJson(response.data);
      return ResponseApi(
        isSuccess: true,
        message: "Successfully to list categories",
        data: responseClass,
      );
    } on DioException catch (e) {
      logger.e("$e");
      if (e.response != null) {
        logger.e(e.response?.statusCode);
        logger.e(e.response?.statusMessage);
        logger.e(e.response?.data);
        return ResponseApi(
          isSuccess: false,
          message: e.response?.statusMessage ?? "failed to list categories",
        );
      }
      return ResponseApi(
        isSuccess: false,
        message: "failed to list categories",
      );
    } catch (e) {
      return ResponseApi(
        isSuccess: false,
        message: "$e",
      );
    }
  }

  Future<ResponseApi<Map?>> selectBank(
      String invoiceId, String lotteryDate, String bankId) async {
    try {
      final dio = Dio();
      final token = await getCredential();
      final response = await dio.post("${AppConst.apiUrl}/payment/select-bank",
          data: {
            "invoiceId": invoiceId,
            "lotteryDate": lotteryDate,
            "bankId": bankId,
          },
          options: Options(headers: {"Authorization": "Bearer $token"}));
      return ResponseApi(
        isSuccess: true,
        message: "Success to select bank",
        data: response.data,
      );
    } on DioException catch (e) {
      logger.e("$e");
      if (e.response != null) {
        logger.e(e.response?.statusCode);
        logger.e(e.response?.statusMessage);
        logger.e(e.response?.data);
        return ResponseApi(
          isSuccess: false,
          message: e.response?.statusMessage ?? "failed to select bank",
        );
      }
      return ResponseApi(
        isSuccess: false,
        message: "failed to select bank",
      );
    } catch (e) {
      logger.e("$e");
      return ResponseApi(isSuccess: false, message: "failed to select bank");
    }
  }

  Future<ResponseApi<Map?>> applyPoint(
    String invoiceId,
    String lotteryDateStr,
    int point,
  ) async {
    try {
      final dio = Dio();
      final url = "${AppConst.apiUrl}/payment/select-point";
      final payload = {
        "invoiceId": invoiceId,
        "lotteryDate": lotteryDateStr,
        "point": point,
      };
      logger.w("payload applyPoint");
      logger.d(payload);
      final response = await dio.post(
        url,
        data: payload,
      );
      logger.w("response applyPoint");
      logger.d(response.data);
      return ResponseApi(
        isSuccess: true,
        message: "Successfully apply point",
        data: response.data,
      );
    } on DioException catch (e) {
      logger.e("$e");
      if (e.response != null) {
        logger.e(e.response?.statusCode);
        logger.e(e.response?.statusMessage);
        logger.e(e.response?.data);
        return ResponseApi(
          isSuccess: false,
          message: e.response?.statusMessage ?? "failed to apply point",
        );
      }
      return ResponseApi(
        isSuccess: false,
        message: "failed to apply point",
      );
    } catch (e) {
      return ResponseApi(
        isSuccess: false,
        message: "failed to apply point",
      );
    }
  }

  Future<ResponseApi<Map?>> readNotification(
    List<String> notificationIds,
    String userId,
  ) async {
    try {
      // POST /api/notification/read-noti
      // Body : {
      //     "userId"  : "",
      //     "notiId" : [""]
      // }
      final dio = Dio();
      final url = "${AppConst.apiUrl}/notification/read-noti";
      logger.d("url: $url");
      final payload = {
        "userId": userId,
        "notiId": notificationIds,
      };
      logger.d("payload: $payload");
      final response = await dio.post(
        url,
        data: payload,
      );
      return ResponseApi(
        isSuccess: true,
        message: "Successfully read notification",
        data: response.data,
      );
    } on DioException catch (e) {
      logger.e("$e");
      if (e.response != null) {
        logger.e(e.response?.statusCode);
        logger.e(e.response?.statusMessage);
        logger.e(e.response?.data);
        return ResponseApi(
          isSuccess: false,
          message: e.response?.statusMessage ?? "failed to read notification",
        );
      }
      return ResponseApi(
        isSuccess: false,
        message: "failed to read notification",
      );
    } catch (e) {
      return ResponseApi(
        isSuccess: false,
        message: "failed to read notification",
      );
    }
  }

  Future<void> saveFiles(Uint8List bytes, String fileName) async {
    try {
      // ค้นหา directory สำหรับจัดเก็บไฟล์
      final external = await getExternalStorageDirectory();
      // return;
      final filePath = "${external?.path}";

      // สร้าง path สำหรับไฟล์
      final filePathFull = '$filePath/$fileName';

      // สร้างไฟล์และเขียนข้อมูล
      final file = io.File(filePathFull);
      await file.writeAsBytes(bytes);
      // file.writeAsBytesSync(bytes);
      logger.d('ไฟล์ถูกบันทึกที่: $filePathFull');
    } catch (e) {
      logger.d('เกิดข้อผิดพลาดขณะบันทึกไฟล์: $e');
    }
  }

  Future<void> downLoadFile(String bucketId, String fileId) async {
    try {
      // Client client = Client()
      //     .setEndpoint(
      //         'https://baas-dev.moevedigital.com/v1') // Your API Endpoint
      //     .setProject('667afb24000fbd66b4df') // Your project ID
      //     // .setSession(''); // The user session to authenticate with
      //     .setSelfSigned(status: true);

      // Storage storage = Storage(client);
      Uint8List result = await storage.getFileDownload(
        bucketId: bucketId,
        fileId: fileId,
      );
      logger.d("downloaded !");
      // Gal.
      await Gal.putImageBytes(
        result,
        album: 'CK-LOTTO',
      );

      await FlutterLocalNotificationsPlugin().show(
        1,
        AppLocale.downloadCompletedSuccessfully.getString(Get.context!),
        '${AppLocale.theFileIsSavedIn.getString(Get.context!)} CK-LOTTO',
        NotificationDetails(
          android: AndroidNotificationDetails(
            'download_channel',
            AppLocale.downloadFile.getString(Get.context!),
            channelDescription: 'แสดงสถานะการดาวน์โหลดไฟล์',
          ),
        ),
      );
      // await saveFiles(result, '02.png');
      logger.d("saved !");
    } catch (e) {
      logger.e("$e");
    }
  }

  Future<List<Map>?> listMyGroup(String userId) async {
    try {
      final response = await databases.listDocuments(
        databaseId: _databaseName,
        collectionId: GROUP_USER,
        queries: [
          Query.contains('userId', userId),
          Query.equal('is_active', true),
          Query.select(['name', 'value', '\$id']),
        ],
      );
      final result = response.documents.map((docment) => docment.data).toList();
      return result;
    } catch (e) {
      logger.e("$e");
      return null;
    }
  }

  Future<ResponseApi<int?>> getPoint(String userId) async {
    try {
      final response = await databases.getDocument(
        databaseId: _databaseName,
        collectionId: USER,
        documentId: userId,
        queries: [
          Query.select(["point"]),
        ],
      );
      return ResponseApi(
        isSuccess: true,
        message: "Successfully to get point",
        data: response.data['point'],
      );
    } catch (e) {
      logger.e("$e");
      return ResponseApi(
        isSuccess: false,
        message: "Failed to get point",
      );
    }
  }

  Future<void> subscribeTopic(String userId) async {
    try {
      final targetId = await StorageController.to.getTargetPush();
      if (targetId == null) {
        return;
      }
      final response = await messaging.createSubscriber(
        topicId: TOPIC_ALL_USER,
        subscriberId: userId,
        targetId: targetId,
      );
      logger.w("subscribeTopic: $response");
      // getTargetPush
    } catch (e) {
      logger.e("$e");
    }
  }

  Future<ResponseApi<Map>> applyPromotion(
      String? promotionId, String invoiceId, String lotteryDate,
      [String? bankId]) async {
    try {
      final dio = Dio();
      final payload = {
        "invoiceId": invoiceId,
        "lotteryDate": lotteryDate,
      };
      if (promotionId != null) {
        payload["promotionId"] = promotionId;
      }
      if (bankId != null) {
        payload['bankId'] = bankId;
      }
      logger.w(payload);
      final response = await dio.post(
        "${AppConst.apiUrl}/payment/buy-promotion",
        data: payload,
      );
      return ResponseApi(
        isSuccess: true,
        message: "Successfully apply promotion",
        data: response.data,
      );
    } on DioException catch (e) {
      logger.e("$e");
      if (e.response != null) {
        logger.e(e.response?.statusCode);
        logger.e(e.response?.statusMessage);
        logger.e(e.response?.data);
        return ResponseApi(
          isSuccess: false,
          message: e.response?.statusMessage ?? "failed to apply promotion",
        );
      }
      return ResponseApi(
        isSuccess: false,
        message: "failed to apply promotion",
      );
    } catch (e) {
      logger.e("$e");
      return ResponseApi(
        isSuccess: false,
        message: "failed to apply promotion",
      );
    }
  }

  Future<ResponseApi<Map>> topup(
    int point,
    String bankId,
    String userId,
  ) async {
    try {
      final dio = Dio();
      final payload = {
        "point": point,
        "bankId": bankId,
        "userId": userId,
      };
      logger.w(payload);
      final jwt = await getAppJWT();
      final response = await dio.post(
        "${AppConst.apiUrl}/topup/payment",
        data: payload,
        options: Options(headers: {
          "Authorization": "Bearer $jwt",
        }),
      );
      return ResponseApi(
        isSuccess: true,
        message: "Successfully apply promotion",
        data: response.data,
      );
    } on DioException catch (e) {
      logger.e("$e");
      if (e.response != null) {
        logger.e(e.response?.statusCode);
        logger.e(e.response?.statusMessage);
        logger.e(e.response?.data);
        return ResponseApi(
          isSuccess: false,
          message: e.response?.statusMessage ?? "failed to apply promotion",
        );
      }
      return ResponseApi(
        isSuccess: false,
        message: "failed to apply promotion",
      );
    } catch (e) {
      logger.e("$e");
      return ResponseApi(
        isSuccess: false,
        message: "failed to apply promotion",
      );
    }
  }

  Future<ResponseApi<PointTopup?>> getPointTopup(String id) async {
    try {
      final response = await databases.getDocument(
        databaseId: _databaseName,
        collectionId: 'point_topup',
        documentId: id,
      );
      return ResponseApi(
        isSuccess: true,
        message: "get point topup transaction success",
        data: PointTopup.fromJson(response.data),
      );
    } on AppwriteException catch (e) {
      logger.e(e);
      return ResponseApi(
        isSuccess: false,
        message: e.message ?? e.type ?? e.code?.toString() ?? 'appwrite error',
      );
    } catch (e) {
      logger.e(e);
      return ResponseApi(
        isSuccess: false,
        message: e.toString(),
      );
    }
  }

  Future<ResponseApi<void>> cancelBill(String invoiceId, String date) async {
    try {
      final option = BaseOptions(
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
      );
      final dio = Dio(option);
      final payload = {
        "invoiceId": invoiceId,
        "date": date,
      };

      final jwt = await getAppJWT();
      final response = await dio.post(
        "${AppConst.apiUrl}/lotlink/cancelBill",
        data: payload,
        options: Options(headers: {
          "Authorization": "Bearer $jwt",
        }),
      );
      logger.d(response.data);
      return ResponseApi(
        isSuccess: true,
        message: "Success to cancel bill",
      );
    } on DioException catch (e) {
      logger.e(e.response?.statusCode);
      logger.e(e.response?.statusMessage);
      logger.e(e.response?.data);
      return ResponseApi(
        isSuccess: false,
        message: e.response?.statusMessage ?? "failed to cancel bill",
      );
    } catch (e) {
      logger.e(e);
      return ResponseApi(
        isSuccess: false,
        message: "$e",
      );
    }
  }

  Future<ResponseApi<List<SpecialReward>?>> listSpecialReward(
      String lotteryDateId) async {
    try {
      final response = await databases.listDocuments(
        databaseId: _databaseName,
        collectionId: 'special_rewards',
        queries: [
          Query.equal(
            'lotteryDateId',
            lotteryDateId,
          ),
          Query.equal('is_active', true),
          Query.equal('is_approve', '1'),
        ],
      );
      return ResponseApi(
        isSuccess: true,
        message: "get special reward success",
        data: response.documents.map((document) {
          return SpecialReward.fromJson(document.data);
        }).toList(),
      );
    } on AppwriteException catch (e) {
      logger.e(e);
      return ResponseApi(
        isSuccess: false,
        message: e.message ?? e.type ?? e.code?.toString() ?? 'appwrite error',
      );
    } catch (e) {
      logger.e(e);
      return ResponseApi(
        isSuccess: false,
        message: e.toString(),
      );
    }
  }

  Future<ResponseApi<FindInfluencer>> findInfluencer(String influenCode) async {
    try {
      final response = await databases.listDocuments(
        databaseId: _databaseName,
        collectionId: USER,
        queries: [
          // TODO: query expire date
          Query.equal("influencer", influenCode),
          // TODO: select first_name, last_name, profile for show dialog influencer infomation confirm
          Query.select(["firstname", "lastname", "profile", "ref_code"]),
        ],
      );
      if (response.documents.isEmpty) {
        return ResponseApi(
          isSuccess: false,
          message: AppLocale.notFoundInfluencer.getString(Get.context!),
        );
      }
      if (response.documents.length > 1) {
        return ResponseApi(
          isSuccess: false,
          message: "This code is used by multiple influencers",
        );
      }
      final influenCerRefCode = response.documents.first.data;
      return ResponseApi(
        isSuccess: true,
        message: "success to get influencer",
        data: FindInfluencer.fromJson(influenCerRefCode),
      );
    } on AppwriteException catch (e) {
      logger.e(e);
      return ResponseApi(
        isSuccess: false,
        message: e.message ?? "${e.code ?? ""}",
      );
    } catch (e) {
      logger.e("$e");
      return ResponseApi(
        isSuccess: false,
        message: "failed to get influencer",
      );
    }
  }

  Future<ResponseApi<GetCurrentTime>> getCurrentTime() async {
    try {
      final response = await functions.createExecution(
        functionId: FN_GET_TIME,
        method: ExecutionMethod.gET,
        path: "/",
      );
      logger.w(response.responseBody);
      return ResponseApi(
        isSuccess: true,
        message: "Success to get current time",
        data: GetCurrentTime.fromJson(jsonDecode(response.responseBody)),
      );
    } catch (e) {
      return ResponseApi(
        isSuccess: false,
        message: "failed to get current time",
      );
    }
  }

  Future<ResponseApi<Map>> getMyReward(String userId, String wheelId) async {
    try {
      final response = await databases.listDocuments(
        databaseId: _databaseName,
        collectionId: WHEEL_USER,
        queries: [
          Query.equal('userId', userId),
          Query.equal('wheelId', wheelId),
        ],
      );
      if (response.documents.isEmpty) {
        return ResponseApi(
          isSuccess: true,
          message: "no reward in this wheel",
        );
      }
      final reward = response.documents.first;
      return ResponseApi(
        isSuccess: false,
        message: "Success to get my reward",
        data: reward.data,
      );
    } on AppwriteException catch (e) {
      logger.e(e);
      return ResponseApi(
        isSuccess: false,
        message: e.message ?? "${e.code ?? "appwrite: error"}",
      );
    } catch (e) {
      logger.e(e);
      return ResponseApi(isSuccess: false, message: "failed to get my reward");
    }
  }

  Future<ResponseApi<Map>> requestReward(String userId, String wheelId) async {
    try {
      final option = BaseOptions(
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
      );
      final dio = Dio(option);
      final payload = {
        "wheelId": wheelId,
        "userId": userId,
      };
      final jwt = await getAppJWT();
      final response = await dio.post(
        "${AppConst.apiUrl}/wheel/lucky-wheel",
        data: payload,
        options: Options(headers: {
          "Authorization": "Bearer $jwt",
        }),
      );
      logger.d(response.data);
      return ResponseApi(
        isSuccess: true,
        message: "Success to request reward",
        data: response.data,
      );
    } catch (e) {
      return ResponseApi(
        isSuccess: false,
        message: "failed to request reward",
      );
    }
  }

  Future<ResponseApi<GetWheelActive>> getWheelActive() async {
    try {
      final responseCurrentTime = await AppWriteController.to.getCurrentTime();
      final currentTime = responseCurrentTime.data;
      if (responseCurrentTime.isSuccess == false || currentTime == null) {
        return ResponseApi(isSuccess: false, message: "Can't get current time");
      }
      final now = currentTime.dateTime.toIso8601String();
      logger.w("now: $now");
      final response = await databases.listDocuments(
        databaseId: _databaseName,
        collectionId: WHEEL_PROMOTION,
        queries: [
          Query.lessThanEqual('start_date', now),
          Query.greaterThanEqual("end_date", now),
          Query.equal('is_active', true),
          Query.equal('is_approve', '3'),
          Query.orderAsc('\$createdAt'),
        ],
      );
      if (response.documents.isEmpty) {
        return ResponseApi(
          isSuccess: false,
          message: "wheel is empty",
        );
      }
      final wheel = response.documents.first;
      return ResponseApi(
        isSuccess: true,
        message: "Success to get fortune wheel",
        data: GetWheelActive.fromJson(wheel.data),
      );
    } on AppwriteException catch (e) {
      logger.e(e);
      return ResponseApi(
        isSuccess: false,
        message: e.message ?? "${e.code ?? "appwrite: error"}",
      );
    } catch (e) {
      logger.e(e);
      return ResponseApi(
          isSuccess: false, message: "failed to get fortune wheel");
    }
  }

  Future<ResponseApi<void>> listWheelReward(
      String invoiceId, String date) async {
    try {
      final option = BaseOptions(
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
      );
      final dio = Dio(option);
      final payload = {
        "invoiceId": invoiceId,
        "date": date,
      };

      final jwt = await getAppJWT();
      final response = await dio.post(
        "${AppConst.apiUrl}/lotlink/cancelBill",
        data: payload,
        options: Options(headers: {
          "Authorization": "Bearer $jwt",
        }),
      );
      logger.d(response.data);
      return ResponseApi(
        isSuccess: true,
        message: "Success to cancel bill",
      );
    } on DioException catch (e) {
      logger.e(e.response?.statusCode);
      logger.e(e.response?.statusMessage);
      logger.e(e.response?.data);
      return ResponseApi(
        isSuccess: false,
        message: e.response?.statusMessage ?? "failed to cancel bill",
      );
    } catch (e) {
      logger.e(e);
      return ResponseApi(
        isSuccess: false,
        message: "$e",
      );
    }
  }

  @override
  void onInit() {
    setUp();
    super.onInit();
  }
}
