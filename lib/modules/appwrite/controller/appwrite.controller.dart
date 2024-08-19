import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:get/get.dart';
import 'package:lottery_ck/model/bank.dart';
import 'package:lottery_ck/model/lottery.dart';
import 'package:lottery_ck/model/user.dart';
import 'package:lottery_ck/modules/firebase/controller/firebase_messaging.controller.dart';
import 'package:lottery_ck/modules/history/controller/history_buy.controller.dart';
import 'package:lottery_ck/utils.dart';

class AppWriteController extends GetxController {
  static const String _databaseName = 'lottory';
  static const String USER = 'user';
  static const String TRANSACTION = '_transaction';
  static const String INVOICE = '_invoice';
  static const String ACCUMULATE = '_accumulate';
  static const String LOTTERY_DATE = 'lottery_date';
  static const String BANK = 'bank';

  static const _roleUserId = "669a2cfd00141edc45ef";
  final String _providerId = '6694bc1400115d5369eb';
  static AppWriteController get to => Get.find();
  late Account account;
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

  Future<User> get user async => await account.get();

  Future<void> loginWithPhoneNumber(String phoneNumber) async {
    logger.d(phoneNumber);
  }

  Future<bool> login(String email, String password) async {
    try {
      await account.createEmailPasswordSession(
          email: email, password: password);
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
            Query.select(["name", "logo", "\$id"]),
            Query.equal('status', true),
          ]);
      return bankList;
    } catch (e) {
      logger.e(e.toString());
      Get.snackbar('Something went wrong',
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
        'Something went wrong',
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
        title: 'Something went wrong',
        message: "Transaction: please try again later or contact admin",
      );
      return null;
    }
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
        ],
      );
      logger.d(listLotteryDate.total);
      return listLotteryDate.documents.map((lotteryDate) {
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
      return UserApp(
        firstName: userMap['firstname'],
        lastName: userMap['lastname'],
        phoneNumber: userMap['phone'],
      );
    } catch (e) {
      logger.e("$e");
      Get.rawSnackbar(message: "$e");
      return null;
    }
  }
}
