import 'package:get/get.dart';
import 'package:lottery_ck/model/response/bytedance_list_video.dart';
import 'package:lottery_ck/model/response/bytedance_response.dart';
import 'package:lottery_ck/modules/appwrite/controller/appwrite.controller.dart';
import 'package:lottery_ck/utils.dart';

class VideoController extends GetxController {
  static VideoController get to => Get.find();
  // List<SubClassificationTree> categories = [];
  RxList<SubClassificationTree> categories = <SubClassificationTree>[].obs;
  // List<MediaInfo> videoList = [];
  RxList<MediaInfo> videoList = <MediaInfo>[].obs;
  RxInt selectedCategory = 0.obs;

  Future<void> listCategories() async {
    final response = await AppWriteController.to.listCategories();
    logger.w(response.data?.toJson());
    final categories =
        response.data?.result.classificationTrees.first.subClassificationTrees;
    if (categories == null) {
      return;
    }
    this.categories.value = categories;
    if (categories.length == 1) {
      selectedCategory.value = categories.first.classificationId;
    }
  }

  Future<void> listVideo([String? categoryId]) async {
    logger.w("categoryId: $categoryId");
    final response = await AppWriteController.to.listVideo(categoryId);
    // logger.w(response.data?.result.mediaInfoList);
    final videoList = response.data?.result.mediaInfoList;
    if (videoList == null) {
      logger.w("videoList is null");
      return;
    }
    for (var video in videoList) {
      logger.w(video.toJson());
    }
    logger.w("videoList.length: ${videoList.length}");
    this.videoList.value = videoList;
  }

  void setup() async {
    await listCategories();
  }

  void setupInPage() async {
    await listCategories();
    await listVideo();
  }

  void onClickCategory(int value) async {
    selectedCategory.value = value;
    if (value == 0) {
      await listVideo("all");
    } else {
      await listVideo("$value");
    }
  }

  @override
  void onInit() {
    setup();
    super.onInit();
  }
}
