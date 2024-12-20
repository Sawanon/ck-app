import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:lottery_ck/model/news.dart';
import 'package:lottery_ck/modules/notification/controller/news.controller.dart';
import 'package:lottery_ck/modules/signup/view/signup.dart';
import 'package:lottery_ck/res/color.dart';
import 'package:lottery_ck/utils.dart';

class NewsDetailPage extends StatelessWidget {
  final bool? isModal;
  const NewsDetailPage({
    super.key,
    this.isModal,
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<NewsController>(
      builder: (controller) {
        if (isModal == true) {
          NewsDetailComponent(
            news: controller.news,
          );
        }
        return Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            child: NewsDetailComponent(
              news: controller.news,
            ),
          ),
        );
      },
    );
  }
}

class NewsDetailComponent extends StatelessWidget {
  final News? news;
  const NewsDetailComponent({
    super.key,
    required this.news,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        HeaderCK(
          onTap: () {
            // navigator?.pop();
            Get.back();
          },
        ),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Container(
                height: 200,
                child: news == null
                    ? SizedBox(
                        height: 100,
                        width: double.infinity,
                      )
                    : CachedNetworkImage(
                        imageUrl: news!.image!,
                        fit: BoxFit.fitHeight,
                        progressIndicatorBuilder: (
                          context,
                          url,
                          downloadProgress,
                        ) =>
                            Center(
                          child: CircularProgressIndicator(
                            value: downloadProgress.progress,
                          ),
                        ),
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.error),
                      ),
              ),
              const SizedBox(height: 16),
              Text(
                news?.name ?? "-",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                news?.detail ?? "-",
                style: TextStyle(
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
