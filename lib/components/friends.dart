import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:lottery_ck/components/header.dart';
import 'package:lottery_ck/model/response/get_my_friends.dart';
import 'package:lottery_ck/model/response/list_my_friends_user.dart';
import 'package:lottery_ck/modules/friends/controller/friends.controller.dart';
import 'package:lottery_ck/res/app_locale.dart';
import 'package:lottery_ck/res/color.dart';
import 'package:lottery_ck/res/icon.dart';
import 'package:lottery_ck/utils/common_fn.dart';
import 'package:lottery_ck/utils/theme.dart';
import 'package:google_fonts/google_fonts.dart';

class FriendsPage extends StatelessWidget {
  final GetMyFriends myFriends;
  // final List<ListMyFriendsUser> listMyFriends;
  const FriendsPage({
    super.key,
    required this.myFriends,
    // required this.listMyFriends,
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<FriendsController>(
      builder: (controller) {
        final listMyFriends = controller.listMyFriendsFiltered;
        return Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            child: Column(
              children: [
                Header(
                  title: AppLocale.inviteFriends.getString(context),
                  padding: const EdgeInsets.only(
                    left: 16,
                    right: 16,
                    top: 8,
                    bottom: 0,
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(
                      top: 8,
                      left: 16,
                      right: 16,
                      bottom: 16,
                    ),
                    child: Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            controller.onClickFilter("invited");
                          },
                          child: Obx(() {
                            return Container(
                              padding: const EdgeInsets.only(
                                top: 8,
                                right: 16,
                                bottom: 8,
                                left: 8,
                              ),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: Colors.white,
                                  boxShadow: const [AppTheme.softShadow],
                                  border: Border.all(
                                    width: 1,
                                    color: controller.filter.value == "invited"
                                        ? AppColors.primary
                                        : Colors.transparent,
                                  )),
                              child: Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      // color: Colors.orange.shade200,
                                      shape: BoxShape.circle,
                                    ),
                                    child: SizedBox(
                                      width: 40,
                                      height: 40,
                                      child: SvgPicture.asset(
                                        AppIcon.user,
                                        colorFilter: ColorFilter.mode(
                                          Colors.orange,
                                          BlendMode.srcIn,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          AppLocale.youHaveInvitedYourFriends
                                              .getString(context),
                                          style: TextStyle(
                                            fontSize: 16,
                                          ),
                                        ),
                                        Text(
                                          AppLocale.clickToViewFriendsList
                                              .getString(context),
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: AppColors.disableText,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Text(
                                    "${myFriends.total} ${AppLocale.people.getString(context)}",
                                    // "2 ราย",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }),
                        ),
                        const SizedBox(height: 8),
                        GestureDetector(
                          onTap: () {
                            controller.onClickFilter("accepted");
                          },
                          child: Obx(() {
                            return Container(
                              padding: const EdgeInsets.only(
                                top: 8,
                                right: 16,
                                bottom: 8,
                                left: 8,
                              ),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: Colors.white,
                                  boxShadow: const [AppTheme.softShadow],
                                  border: Border.all(
                                    width: 1,
                                    color: controller.filter.value == "accepted"
                                        ? AppColors.primary
                                        : Colors.transparent,
                                  )),
                              child: Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      // color: Colors.green.shade200,
                                      shape: BoxShape.circle,
                                    ),
                                    child: SizedBox(
                                      width: 40,
                                      height: 40,
                                      child: SvgPicture.asset(
                                        AppIcon.userTick,
                                        colorFilter: ColorFilter.mode(
                                          Colors.green,
                                          BlendMode.srcIn,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          AppLocale.yourFriendHasAccepted
                                              .getString(context),
                                          style: TextStyle(
                                            fontSize: 16,
                                          ),
                                        ),
                                        Text(
                                          AppLocale.clickToViewFriendsList
                                              .getString(context),
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: AppColors.disableText,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Text(
                                    "${myFriends.accepted} ${AppLocale.people.getString(context)}",
                                    // "1 ราย",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }),
                        ),
                        const SizedBox(height: 16),
                        Obx(
                          () {
                            if (controller.filter.value == "") {
                              return const SizedBox.shrink();
                            }
                            final text = controller.filter.value == "invited"
                                ? AppLocale.listOfFriendsInvited
                                    .getString(context)
                                : AppLocale.listOfFriendsWhoHaveAccepted
                                    .getString(context);
                            return Text(
                              text,
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            );
                          },
                        ),
                        const SizedBox(height: 16),
                        Expanded(
                          child: ListView.separated(
                            itemBuilder: (context, index) {
                              final myFriends = listMyFriends[index];
                              return Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(8),
                                  boxShadow: const [AppTheme.softShadow],
                                ),
                                child: Row(
                                  children: [
                                    SizedBox(
                                      width: 24,
                                      height: 24,
                                      child: SvgPicture.asset(
                                        AppIcon.user,
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          "${myFriends.firstName} ${myFriends.lastName}",
                                          style: TextStyle(
                                            color: AppColors.textPrimary,
                                          ),
                                        ),
                                        Text(
                                          CommonFn.hidePhoneNumber(
                                              myFriends.phone),
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: AppColors.textPrimary,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              );
                            },
                            separatorBuilder: (context, index) {
                              return const SizedBox(height: 6);
                            },
                            itemCount: listMyFriends.length,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
