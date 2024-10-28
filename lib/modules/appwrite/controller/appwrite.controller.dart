import 'dart:convert';

import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:get/get.dart';
import 'package:lottery_ck/components/gender_radio.dart';
import 'package:lottery_ck/model/bank.dart';
import 'package:lottery_ck/model/buy_lottery_configs.dart';
import 'package:lottery_ck/model/jwt.dart';
import 'package:lottery_ck/model/lottery.dart';
import 'package:lottery_ck/model/lottery_date.dart';
import 'package:lottery_ck/model/news.dart';
import 'package:lottery_ck/model/respnose_verifypasscode.dart';
import 'package:lottery_ck/model/user.dart';
import 'package:lottery_ck/model/user_point.dart';
import 'package:lottery_ck/modules/appwrite/controller/savefile.dart';
import 'package:lottery_ck/modules/firebase/controller/firebase_messaging.controller.dart';
import 'package:lottery_ck/modules/layout/controller/layout.controller.dart';
import 'package:lottery_ck/res/constant.dart';
import 'package:lottery_ck/storage.dart';
import 'package:lottery_ck/utils.dart';
import "package:collection/collection.dart";
import 'package:lottery_ck/utils/common_fn.dart';
import 'dart:typed_data';
import 'package:image/image.dart' as img;

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

  static const _roleUserId = "669a2cfd00141edc45ef";
  final String _providerId = '66d28d4000300a1e7dc1';
  static AppWriteController get to => Get.find();
  late Account account;
  late Databases databases;
  late Storage storage;
  Client client = Client();

  Future<User> get user async => await account.get();

  Future<void> getAuthJWTToken() async {
    try {
      final dio = Dio();
      final jwt = JWT({
        "token": AppConst.publicToken,
      });
      final secretKey = await StorageController.to.getSecretKey();
      final token =
          jwt.sign(SecretKey('$secretKey'), algorithm: JWTAlgorithm.HS384);
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
      logger.d(response.data);
      await StorageController.to.setAppToken(response.data);
    } catch (e) {
      logger.e("$e");
      Get.snackbar(
        "Something went wrong appwrite:66 getAuthToken",
        "Please try again later or plaese contact admin",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<bool> login(String email, String password) async {
    try {
      final session = await account.createEmailPasswordSession(
        email: email,
        password: password,
      );
      await StorageController.to.setSessionId(session.$id);
      final user = await account.get();
      logger.d(user.name);
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
        logger.w("create target is empty");
        await createTarget();
      }
      return true;
    } on Exception catch (e) {
      logger.e(e.toString());
      Get.snackbar(
        "Something went wrong appwrite:74",
        "Please try again later or plaese contact admin",
      );
      return false;
    }
    // setState(() {
    //   loggedInUser = user;
    // });
  }

  Future<void> createTarget() async {
    final tokenFirebase = await FirebaseMessagingController.to.getToken();
    final target = await account.createPushTarget(
      targetId: ID.unique(),
      identifier: tokenFirebase!,
      providerId: _providerId,
    );
    logger.d(target.providerType);
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

  Future<DocumentList?> listBank() async {
    try {
      final bankList = await databases.listDocuments(
          databaseId: _databaseName,
          collectionId: BANK,
          queries: [
            Query.select(["name", "logo", "\$id", "full_name"]),
            Query.equal('status', true),
          ]);
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
      Get.rawSnackbar(message: "$e");
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
      Get.rawSnackbar(message: "$e");
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
      Get.rawSnackbar(
        title: 'Something went wrong appwrite:264',
        message: "Transaction: please try again later or contact admin",
      );
      return null;
    }
  }

  Future<Document> getLotteryDateById(String lotteryDateId) async {
    logger.d(lotteryDateId);
    return await databases.getDocument(
      databaseId: _databaseName,
      collectionId: LOTTERY_DATE,
      documentId: lotteryDateId,
    );
  }

  Future<Document?> getLotteryDate(DateTime datetime) async {
    try {
      final response = await databases.listDocuments(
        databaseId: _databaseName,
        collectionId: LOTTERY_DATE,
        queries: [
          Query.greaterThanEqual('datetime', datetime.toIso8601String()),
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
      Get.rawSnackbar(message: "$e");
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
      Get.rawSnackbar(message: "$e");
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
          Query.orderAsc("datetime"),
          Query.limit(10),
        ],
      );
      List<LotteryDate> lotteryDateList = [];
      bool isGreatOne = false;
      for (var lotteryDateDocument in listLotteryDate.documents) {
        final lotteryDate = LotteryDate.fromJson(lotteryDateDocument.data);
        lotteryDateList.add(lotteryDate);
        logger.d(lotteryDate.endTime.toString());
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
      return lotteryDateList.reversed.toList();
    } catch (e) {
      logger.e("$e");
      Get.rawSnackbar(message: "$e");
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
      Get.rawSnackbar(message: "$e");
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
      );
    } catch (e) {
      logger.e("$e");
      Get.rawSnackbar(message: "$e");
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
      return UserApp.fromJson(userMap);
      // return UserApp(
      //   firstName: userMap['firstname'],
      //   lastName: userMap['lastname'],
      //   phoneNumber: userMap['phone'],
      // );
    } catch (e) {
      logger.e("$e");
      // Get.rawSnackbar(message: "$e");
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
      Get.rawSnackbar(message: "$e");
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
      Get.rawSnackbar(message: "$e");
      return null;
    }
  }

  Future<List<News>?> listNews() async {
    try {
      final newsDocumentList = await databases.listDocuments(
        databaseId: _databaseName,
        collectionId: NEWS,
        queries: [
          Query.equal("is_active", true),
          Query.equal("is_approve", "3"),
          Query.greaterThanEqual("end_date", DateTime.now().toIso8601String()),
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
      Get.rawSnackbar(message: "$e");
      return null;
    }
  }

  Future<List<Map>?> listPromotionsPoints() async {
    try {
      final promotionsPointsDocumentList = await databases.listDocuments(
        databaseId: _databaseName,
        collectionId: POINTS,
        queries: [
          Query.equal("is_active", true),
          Query.equal("is_approve", "3"),
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

  Future<List<Map>?> listPromotions() async {
    try {
      final promotionsDocumentList = await databases.listDocuments(
        databaseId: _databaseName,
        collectionId: PROMOTION,
        queries: [
          Query.equal("is_active", true),
          Query.equal("is_approve", "3"),
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
      Get.rawSnackbar(message: "$e");
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
      Get.rawSnackbar(message: "$e");
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
      Get.rawSnackbar(message: "$e");
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
      final token = await getCredential();
      final dio = Dio();
      final response = await dio.post(
        "${AppConst.cloudfareUrl}/listLotteryCollections",
        data: {
          "lotteryMonth": lotteryMonth,
        },
        options: Options(
          headers: {"Authorization": "Bearer $token"},
        ),
      );
      return response.data["collectionList"];
    } catch (e) {
      logger.e("$e");
      Get.rawSnackbar(message: "$e");
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
      Get.rawSnackbar(message: "$e");
      return null;
    }
  }

  Future<List?> listWinInvoices(String collectionId) async {
    try {
      final userId = await user.then((value) => value.$id);
      final invoiceList = await databases.listDocuments(
        databaseId: _databaseName,
        collectionId: collectionId,
        queries: [
          Query.equal("is_win", true),
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
      Get.rawSnackbar(message: "$e");
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
        collectionId: "group_users",
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
        collectionId: "group_users",
        documentId: allUser.documents.first.$id,
      );
      final oldArray = allUserGroup.data["userId"];
      await databases.updateDocument(
        databaseId: _databaseName,
        collectionId: "group_users",
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
          Query.limit(25),
        ],
      );
      logger.d(lotteryHistoryDocumentList.total);
      List lotteryHistoryList = [];
      final lotteryHistoryListData =
          lotteryHistoryDocumentList.documents.map((document) => document.data);
      var newMap =
          groupBy(lotteryHistoryListData, (Map obj) => obj['lottery_date_id']);
      for (var lotteryByDate in newMap.entries) {
        final lotteryDateDocument = await getLotteryDateById(
            lotteryByDate.value.first["lottery_date_id"]);
        logger.f(lotteryDateDocument.data);
        final lotteryDate = CommonFn.parseDMY(
            DateTime.parse(lotteryDateDocument.data["datetime"]).toLocal());
        String lottery = lotteryByDate.value.first["lottery"].first as String;
        if (lottery.length < 6) {
          final zero = List.generate(6 - lottery.length, (index) => '0');
          lottery = "${zero.join("")}$lottery";
        }
        lotteryHistoryList.add({
          "lottery": lottery,
          "lotteryDate": lotteryDate,
        });
      }
      return lotteryHistoryList;
    } catch (e) {
      logger.e("$e");
      // Get.rawSnackbar(message: "$e");
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

  Future<User?> signUp(
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
        "gender": gender,
      });
      logger.d("response: ${response.data}");
      if (response.data["status"] == false) {
        throw "create user failed";
      }
      return User.fromMap(response.data["user"]);
    } catch (e) {
      logger.e("$e");
      return null;
    }
  }

  Future<String> getAppJWT() async {
    final appToken = await StorageController.to.getAppToken();
    if (appToken == null) throw "app token is empty";
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
    final secretKey = await StorageController.to.getSecretKey();
    final token =
        jwt.sign(SecretKey('$secretKey'), algorithm: JWTAlgorithm.HS384);
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
      final Map<String, dynamic>? token = response.data;
      // logger.d("token: ${token}");
      if (token?['status'] == false) {
        if (token?['code'] == "user_notfound") {
          return {
            "status": false,
            "code": "user_notfound",
            "message": "User not found",
          };
        }
      }
      logger.d("token: $token");
      return token;
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

  Future<Session?> createSession(Map<String, dynamic> token) async {
    try {
      final session = await account.createSession(
        userId: token["userId"],
        secret: token["secret"],
      );
      await clearOtherSession(session.$id);
      await createTarget();
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

  Future<String?> updateUserPhone(String phone) async {
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
      logger.d(response.data);
      return response.data["phone"];
    } catch (e) {
      logger.e("$e");
      return null;
    }
  }

  Future<void> intialTokenToStorage() async {
    try {
      Get.put<StorageController>(StorageController());
      await StorageController.to.setSecretKey(AppConst.secret);
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

  Future<List<UserPoint>?> listUserPoint() async {
    try {
      final userId = await user.then((user) => user.$id);
      final userPointDocumentList = await databases.listDocuments(
        databaseId: _databaseName,
        collectionId: USER_POINT,
        queries: [
          Query.equal("userId", userId),
          Query.orderDesc("\$createdAt"),
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

  Future<List<Map>?> listContent() async {
    try {
      // final
      final contentDocumentList = await databases.listDocuments(
        databaseId: _databaseName,
        collectionId: CONTENT_MANAGEMENT,
        queries: [
          Query.equal('is_approve', '1'),
          Query.equal('is_active', true),
          Query.or([
            Query.greaterThanEqual('expire', DateTime.now().toIso8601String()),
            Query.isNull('expire'),
          ]),
        ],
      );
      // logger.d(contentDocumentList.documents);
      // for (var content in contentDocumentList.documents) {
      //   logger.d(content.data);
      // }
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

  @override
  void onInit() {
    setUp();
    super.onInit();
  }
}
