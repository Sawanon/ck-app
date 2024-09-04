import 'dart:convert';

import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:lottery_ck/model/bank.dart';
import 'package:lottery_ck/model/lottery.dart';
import 'package:lottery_ck/model/lottery_date.dart';
import 'package:lottery_ck/model/news.dart';
import 'package:lottery_ck/model/user.dart';
import 'package:lottery_ck/modules/firebase/controller/firebase_messaging.controller.dart';
import 'package:lottery_ck/res/constant.dart';
import 'package:lottery_ck/storage.dart';
import 'package:lottery_ck/utils.dart';
import "package:collection/collection.dart";
import 'package:lottery_ck/utils/common_fn.dart';

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

  static const _roleUserId = "669a2cfd00141edc45ef";
  final String _providerId = '66d28d4000300a1e7dc1';
  static AppWriteController get to => Get.find();
  late Account account;
  late Databases databases;
  Client client = Client();
  @override
  void onInit() {
    client
        .setEndpoint('https://baas.moevedigital.com/v1')
        .setProject('667afb24000fbd66b4df')
        .setSelfSigned(status: true);
    account = Account(client);
    databases = Databases(client);

    super.onInit();
  }

  Future<User> get user async => await account.get();

  Future<void> loginWithPhoneNumber(String phoneNumber) async {
    logger.d(phoneNumber);
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

  Future<Bank?> getBankById(String bankId) async {
    try {
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
          "amount": lottery.price,
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
    return databases.getDocument(
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
          Query.equal('is_emergency', false),
          Query.limit(1),
        ],
      );
      if (response.documents.isEmpty) {
        throw "Lottery date is empty";
      }
      return response.documents[0];
    } catch (e) {
      Get.rawSnackbar(message: "$e");
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
            "amount": lottery.price,
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
          "amount": lottery.price + accumulateDocument.data['amount'],
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
          Query.orderDesc("datetime"),
        ],
      );
      return listLotteryDate.documents.map((lotteryDate) {
        logger.d(lotteryDate.data);
        return LotteryDate.fromJson(lotteryDate.data);
      }).toList();
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
      Get.rawSnackbar(message: "$e");
      return null;
    }
  }

  Future<Document?> getInvoice(String invoiceId, String lotteryStr) async {
    try {
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
          Query.equal("is_approve", "1"),
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

  Future<List<Map>?> listPromotions() async {
    try {
      final promotionsDocumentList = await databases.listDocuments(
        databaseId: _databaseName,
        collectionId: PROMOTION,
        queries: [
          Query.equal("is_active", true),
          Query.equal("is_approve", "1"),
          Query.orderDesc('start_date'),
          Query.limit(25),
        ],
      );
      final promotionList = promotionsDocumentList.documents.map(
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

  Future<List?> listLotteryCollection(String lotteryMonth) async {
    try {
      final token = await sessionToken();
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

  Future<String> sessionToken() async {
    final userId = await user.then((value) => value.$id);
    final sessionId = await StorageController.to.getSessionId();
    final credential = "$sessionId:$userId";
    final bearer = base64Encode(utf8.encode(credential));
    return bearer;
  }

  Future<void> detaulGroupUser(String userId) async {
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
      documentId: "66b0369b001651b9cbff",
      data: {
        "userId": [
          ...oldArray,
        ],
      },
    );
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
      List lotteryHistoryList = [];
      final lotteryHistoryListData =
          lotteryHistoryDocumentList.documents.map((document) => document.data);
      var newMap =
          groupBy(lotteryHistoryListData, (Map obj) => obj['lottery_date_id']);
      for (var lotteryByDate in newMap.entries) {
        final lotteryDateDocument = await getLotteryDateById(
            lotteryByDate.value.first["lottery_date_id"]);
        final lotteryDate = CommonFn.parseDMY(
            DateTime.parse(lotteryDateDocument.data["datetime"]).toLocal());
        lotteryHistoryList.add({
          "lottery": lotteryByDate.value.first["lottery"].first,
          "lotteryDate": lotteryDate,
        });
      }
      return lotteryHistoryList;
    } catch (e) {
      logger.e("$e");
      Get.rawSnackbar(message: "$e");
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
}
