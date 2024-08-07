import 'package:flutter/material.dart';
import 'package:lottery_ck/res/color.dart';
import 'package:lottery_ck/utils.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: RefreshIndicator(
          onRefresh: () async {
            logger.d("refresh");
            // _notificationViewModel.clearNews();
            // _notificationViewModel.getNews();
          },
          child: ListView.separated(
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
                      print('object $index');
                      logger.d('object $index');
                      // Get.toNamed(
                      //   RouteName.news_detail,
                      //   arguments: [
                      //     _notificationViewModel.newsList[index],
                      //   ],
                      // );
                    },
                    child: Container(
                      // margin: EdgeInsets.all(8),
                      padding: EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                      // width: MediaQuery.of(context).size.width * 0.2,
                      width: 120,
                      child: Row(
                        children: [
                          Container(
                            width: 90,
                            height: 90,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(90),
                              gradient: LinearGradient(
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter,
                                colors: [
                                  AppColors.yellowGradient,
                                  AppColors.redGradient,
                                ],
                              ),
                            ),
                            child: Center(
                              // child: notifications[index]['icon'] as Widget,
                              child: Icon(Icons.home),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              padding: EdgeInsets.only(left: 16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    // '${notifications[index]['header']}',
                                    'Title',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 12),
                                  Text(
                                    // '${notifications[index]['content']}',
                                    'Detail',
                                    maxLines: 2,
                                  ),
                                  SizedBox(height: 12),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Text(
                                        // '12/05/2023',
                                        "15-07-2024",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Color.fromRGBO(0, 117, 255, 1),
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
            itemCount: 3,
          ),
        ),
      ),
    );
  }
}
