import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottery_ck/modules/signup/view/signup.dart';
import 'package:lottery_ck/res/color.dart';

class PointPage extends StatelessWidget {
  const PointPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            HeaderCK(
              onTap: () {
                navigator?.pop();
              },
            ),
            Container(
              // color: Colors.amber,
              padding: const EdgeInsets.only(top: 16),
              // margin: EdgeInsets.only(top: 16),
              child: Column(
                children: [
                  // Point head
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(child: Container()),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 8),
                        color: Colors.white,
                        child: ShaderMask(
                          blendMode: BlendMode.srcIn,
                          shaderCallback: (bounds) {
                            // Gradient gradient;
                            Gradient gradient = LinearGradient(colors: [
                              AppColors.redGradient,
                              AppColors.yellowGradient,
                            ]);
                            return gradient.createShader(
                              Rect.fromLTWH(0, 0, bounds.width, bounds.height),
                            );
                            // return gradient.createShader(Rect.fromLTWH(0, 0, bounds.width, bounds.height));
                          },
                          child: Text(
                            '1200',
                            style: TextStyle(
                              fontSize: 48,
                              fontWeight: FontWeight.w600,
                              height: 0,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          child: Text(
                            'Point',
                            style: TextStyle(
                              color: AppColors.secondary,
                              height: 2,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  // end Point head
                  const SizedBox(height: 12),
                  // start user info
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: EdgeInsets.all(2),
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(60),
                          gradient: LinearGradient(
                            colors: [
                              AppColors.redGradient,
                              AppColors.yellowGradient,
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(60),
                          ),
                          child: Builder(
                            builder: (context) {
                              // if (avatar == '') {
                              return Icon(
                                Icons.person,
                                color: AppColors.primary,
                                size: 48,
                              );
                              // } else {
                              //   return ClipRRect(
                              //     borderRadius: BorderRadius.circular(144),
                              //     child: CachedNetworkImage(
                              //       imageUrl: avatar,
                              //       progressIndicatorBuilder:
                              //           (context, url, progress) => Center(
                              //         child: CircularProgressIndicator(
                              //           value: progress.progress,
                              //         ),
                              //       ),
                              //       errorWidget: (context, url, error) =>
                              //           Icon(
                              //         Icons.error,
                              //         size: 80,
                              //       ),
                              //     ),
                              //   );
                              // }
                            },
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'name',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            'phoneNumber',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          Text(
                            'email',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  // end user info
                  const SizedBox(height: 24),
                  // start header field
                  Row(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width * 0.25,
                        alignment: Alignment.center,
                        child: Text('ວັນທີ'),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.25,
                        alignment: Alignment.center,
                        child: Text('ທີ່ມາຂອງຄະແນນ'),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.25,
                        alignment: Alignment.center,
                        child: Text('ຈໍານວນ'),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.25,
                        alignment: Alignment.center,
                        child: Text('ຄະແນນ'),
                      ),
                    ],
                  )
                  // end header field
                ],
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              // color: Colors.amber,
              // height: MediaQuery.of(context).size.height * 0.8,
              child: ListView.separated(
                itemBuilder: (context, index) {
                  return Row(
                    children: [
                      Container(
                        color: AppColors.primary.withOpacity(0.2),
                        padding: EdgeInsets.symmetric(vertical: 16),
                        width: MediaQuery.of(context).size.width * 0.25,
                        alignment: Alignment.center,
                        child: Text('12-05-2023'),
                      ),
                      Container(
                        color: AppColors.primary.withOpacity(0.2),
                        padding: EdgeInsets.symmetric(vertical: 16),
                        width: MediaQuery.of(context).size.width * 0.25,
                        alignment: Alignment.center,
                        child: Text('แนะนำเพื่อน'),
                      ),
                      Container(
                        color: AppColors.primary.withOpacity(0.2),
                        padding: EdgeInsets.symmetric(vertical: 16),
                        width: MediaQuery.of(context).size.width * 0.25,
                        alignment: Alignment.center,
                        child: Text('20000'),
                      ),
                      Container(
                        color: AppColors.primary.withOpacity(0.2),
                        padding: EdgeInsets.symmetric(vertical: 16),
                        width: MediaQuery.of(context).size.width * 0.25,
                        alignment: Alignment.center,
                        child: Text('30'),
                      ),
                    ],
                  );
                },
                separatorBuilder: (context, index) => SizedBox(height: 2),
                itemCount: 4,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
