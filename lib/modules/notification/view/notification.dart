import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottery_ck/modules/notification/controller/notification.controller.dart';
import 'package:lottery_ck/res/color.dart';
import 'package:lottery_ck/route/route_name.dart';
import 'package:lottery_ck/utils.dart';
import 'package:lottery_ck/utils/common_fn.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<NotificationController>(builder: (controller) {
      return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            // bottom: PreferredSize(preferredSize: Size(0, 0), child: Container()),
            automaticallyImplyLeading: false,
            titleSpacing: 0,
            toolbarHeight: 48,
            title: const TabBar(
              unselectedLabelColor: Colors.grey,
              dividerColor: Colors.transparent,
              labelColor: Colors.white,
              labelStyle: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              indicatorSize: TabBarIndicatorSize.tab,
              indicator: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24),
                  bottomRight: Radius.circular(24),
                ),
              ),
              tabs: [
                Tab(
                  child: Text(
                    'ຂ່າວ',
                  ),
                ),
                Tab(
                  child: Text('ຂໍ້ສະເໜີ'),
                ),
              ],
            ),
          ),
          body: TabBarView(
            physics: const NeverScrollableScrollPhysics(),
            children: [
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: RefreshIndicator(
                    onRefresh: () async {
                      controller.listNews();
                      // _notificationViewModel.clearNews();
                      // _notificationViewModel.getNews();
                    },
                    child: Obx(() {
                      return ListView.separated(
                        itemBuilder: (context, index) {
                          return Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 1,
                                  blurRadius: 2,
                                  offset: Offset(0, 3),
                                )
                              ],
                            ),
                            child: Material(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.white,
                              child: InkWell(
                                borderRadius: BorderRadius.circular(10),
                                onTap: () {
                                  controller.openNewsDetail(
                                      controller.newsList[index].$id);
                                },
                                child: Container(
                                  // margin: EdgeInsets.all(8),
                                  padding: EdgeInsets.symmetric(
                                      vertical: 12, horizontal: 8),
                                  // width: MediaQuery.of(context).size.width * 0.2,
                                  width: 120,
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 90,
                                        height: 90,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(90),
                                          gradient: LinearGradient(
                                            begin: Alignment.bottomCenter,
                                            end: Alignment.topCenter,
                                            colors: [
                                              AppColors.yellowGradient,
                                              AppColors.redGradient,
                                            ],
                                          ),
                                        ),
                                        child: Icon(
                                          Icons.newspaper_rounded,
                                          size: 36,
                                          color: Colors.white,
                                        ),
                                      ),
                                      Expanded(
                                        child: Container(
                                          padding: EdgeInsets.only(left: 16),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                // '${notifications[index]['header']}',
                                                controller.newsList[index].name,
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              SizedBox(height: 12),
                                              Text(
                                                // '${notifications[index]['content']}',
                                                controller.newsList[index]
                                                        .detail ??
                                                    "-",
                                                maxLines: 2,
                                              ),
                                              SizedBox(height: 12),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: [
                                                  Text(
                                                    // '12/05/2023',
                                                    controller.newsList[index]
                                                                .startDate !=
                                                            null
                                                        ? CommonFn.parseDMY(
                                                            controller
                                                                .newsList[index]
                                                                .startDate!)
                                                        : "-",
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Color.fromRGBO(
                                                          0, 117, 255, 1),
                                                    ),
                                                  ),
                                                ],
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                        separatorBuilder: (context, index) {
                          return SizedBox(height: 8);
                        },
                        itemCount: controller.newsList.length,
                      );
                    }),
                  ),
                ),
              ),
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: RefreshIndicator(
                    onRefresh: () async {
                      controller.listPromotions();
                      // _notificationViewModel.clearNews();
                      // _notificationViewModel.getNews();
                    },
                    child: Obx(() {
                      return ListView.separated(
                        itemBuilder: (context, index) {
                          return Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 1,
                                  blurRadius: 2,
                                  offset: Offset(0, 3),
                                )
                              ],
                            ),
                            child: Material(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.white,
                              child: InkWell(
                                borderRadius: BorderRadius.circular(10),
                                onTap: () {
                                  controller.openPromotionDetail(
                                      controller.promotionList[index]["\$id"]);
                                },
                                child: Container(
                                  // margin: EdgeInsets.all(8),
                                  padding: EdgeInsets.symmetric(
                                      vertical: 12, horizontal: 8),
                                  // width: MediaQuery.of(context).size.width * 0.2,
                                  width: 120,
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 90,
                                        height: 90,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(90),
                                          gradient: LinearGradient(
                                            begin: Alignment.bottomCenter,
                                            end: Alignment.topCenter,
                                            colors: [
                                              AppColors.yellowGradient,
                                              AppColors.redGradient,
                                            ],
                                          ),
                                        ),
                                        child: Icon(
                                          Icons.newspaper_rounded,
                                          size: 36,
                                          color: Colors.white,
                                        ),
                                      ),
                                      Expanded(
                                        child: Container(
                                          padding: EdgeInsets.only(left: 16),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                // '${notifications[index]['header']}',
                                                controller.promotionList[index]
                                                    ["name"],
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              SizedBox(height: 12),
                                              Text(
                                                // '${notifications[index]['content']}',
                                                controller.promotionList[index]
                                                        ["detail"] ??
                                                    "-",
                                                maxLines: 2,
                                              ),
                                              SizedBox(height: 12),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: [
                                                  Text(
                                                    // '12/05/2023',
                                                    controller.promotionList[
                                                                    index]
                                                                ["startDate"] !=
                                                            null
                                                        ? CommonFn.parseDMY(
                                                            controller.promotionList[
                                                                    index]
                                                                ["startDate"]!)
                                                        : "-",
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Color.fromRGBO(
                                                          0, 117, 255, 1),
                                                    ),
                                                  ),
                                                ],
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                        separatorBuilder: (context, index) {
                          return SizedBox(height: 8);
                        },
                        itemCount: controller.promotionList.length,
                      );
                    }),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
