import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lottery_ck/res/app_locale.dart';
import 'package:lottery_ck/res/icon.dart';
import 'package:lottery_ck/utils/theme.dart';
import 'package:google_fonts/google_fonts.dart';

class MenuCardComponent extends StatelessWidget {
  final String title;
  final String backgroundImageUrl;
  final void Function()? onTap;
  final bool imageFullCard;
  const MenuCardComponent({
    super.key,
    required this.title,
    required this.backgroundImageUrl,
    this.onTap,
    this.imageFullCard = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        clipBehavior: Clip.hardEdge,
        height: 128,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [
            AppTheme.softShadow,
          ],
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            if (imageFullCard)
              Container(
                clipBehavior: Clip.hardEdge,
                decoration: BoxDecoration(),
                child: CachedNetworkImage(
                  imageUrl: backgroundImageUrl,
                  fit: BoxFit.cover,
                ),
              )
            else
              Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        title,
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      clipBehavior: Clip.hardEdge,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(1000),
                          bottomLeft: Radius.circular(1000),
                        ),
                      ),
                      child: CachedNetworkImage(
                        imageUrl: backgroundImageUrl,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ],
              ),
            Positioned(
              top: 8,
              right: 8,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: const [AppTheme.softShadow]),
                child: Row(
                  children: [
                    Text(AppLocale.seeMore.getString(context)),
                    SizedBox(
                      width: 18,
                      height: 18,
                      child: SvgPicture.asset(
                        AppIcon.arrowRight,
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
