import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:get/get.dart';
import 'package:lottery_ck/components/long_button.dart';
import 'package:lottery_ck/model/response/find_influencer.dart';
import 'package:lottery_ck/modules/appwrite/controller/appwrite.controller.dart';
import 'package:lottery_ck/res/app_locale.dart';
import 'package:lottery_ck/res/color.dart';
import 'package:lottery_ck/utils/theme.dart';
import 'package:google_fonts/google_fonts.dart';

class InfluencerCard extends StatefulWidget {
  final FindInfluencer influencerData;
  final Future<void> Function() onConfirm;
  const InfluencerCard({
    super.key,
    required this.influencerData,
    required this.onConfirm,
  });

  @override
  State<InfluencerCard> createState() => _InfluencerCardState();
}

class _InfluencerCardState extends State<InfluencerCard> {
  Uint8List? profile;
  bool isLoading = false;

  void setup() async {
    final profile = widget.influencerData.profile;
    if (profile == null) {
      return;
    }
    final fileId = profile.split(":").last;
    final image = await AppWriteController.to.getProfileImage(fileId);
    if (image == null) return;
    setState(() {
      this.profile = image;
    });
  }

  void setIsLoading(bool value) {
    setState(() {
      isLoading = value;
    });
  }

  void handleConfirm() async {
    try {
      setIsLoading(true);
      await widget.onConfirm();
    } finally {
      setIsLoading(false);
    }
  }

  @override
  void initState() {
    setup();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        color: Colors.transparent,
        child: Container(
          margin: const EdgeInsets.all(16),
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 100,
                height: 100,
                clipBehavior: Clip.hardEdge,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [AppTheme.softShadow],
                ),
                child: profile != null
                    ? Image.memory(
                        profile!,
                        fit: BoxFit.cover,
                      )
                    : Icon(
                        Icons.person_2,
                        size: 40,
                      ),
              ),
              const SizedBox(height: 16),
              Text(
                "${widget.influencerData.firstName} ${widget.influencerData.lastName}",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: LongButton(
                      backgroundColor: Colors.white,
                      borderSide: BorderSide(
                        width: 1,
                        color: AppColors.primary,
                      ),
                      onPressed: () {
                        Get.back();
                      },
                      child: Text(
                        AppLocale.cancel.getString(context),
                        style: TextStyle(
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: LongButton(
                      onPressed: handleConfirm,
                      child: Text(
                        AppLocale.confirm.getString(context),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
