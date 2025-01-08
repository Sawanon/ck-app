import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:get/get.dart';
import 'package:lottery_ck/components/long_button.dart';
import 'package:lottery_ck/main.dart';
import 'package:lottery_ck/modules/signup/view/signup.dart';
import 'package:lottery_ck/modules/t_c/controller/t_c.controller.dart';
import 'package:lottery_ck/res/app_locale.dart';
import 'package:lottery_ck/res/color.dart';

class TCPage extends StatelessWidget {
  const TCPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<TCController>(
      builder: (controller) {
        return Scaffold(
          body: Stack(
            fit: StackFit.expand,
            children: [
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.white,
                      AppColors.primary.withOpacity(0.2),
                    ],
                    begin: Alignment(0.0, -0.6),
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),
              SafeArea(
                child: Column(
                  children: [
                    HeaderCK(
                      onTap: () => Get.back(),
                    ),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        margin: const EdgeInsets.all(16),
                        alignment: Alignment.topCenter,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Builder(builder: (context) {
                          final language =
                              localization.currentLocale?.languageCode ?? "lo";
                          return ListView(
                            shrinkWrap: true,
                            children: controller.tc[language]!.map((data) {
                              return Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Row(
                                    children: [
                                      SizedBox(
                                        width: 16,
                                        child: Text("${data['point']}."),
                                      ),
                                      Text("${data['title']}"),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      SizedBox(
                                        width: 16,
                                      ),
                                      Expanded(
                                        child: Text(
                                          "${data['text']}",
                                          softWrap: true,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              );
                            }).toList(),
                          );
                        }),
                      ),
                    ),
                    Container(
                      alignment: Alignment.bottomCenter,
                      padding: const EdgeInsets.all(16.0),
                      child: LongButton(
                        isLoading: controller.isLoading,
                        onPressed: () {
                          controller.onAccept();
                        },
                        child: Text(
                          AppLocale.accept.getString(context),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
