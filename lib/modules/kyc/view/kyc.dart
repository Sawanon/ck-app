import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottery_ck/components/gender_radio.dart';
import 'package:lottery_ck/components/header.dart';
import 'package:lottery_ck/components/input_text.dart';
import 'package:lottery_ck/components/long_button.dart';
import 'package:lottery_ck/components/prefix_radio.dart';
import 'package:lottery_ck/modules/kyc/controller/kyc.controller.dart';
import 'package:lottery_ck/modules/layout/controller/layout.controller.dart';
import 'package:lottery_ck/modules/setting/controller/setting.controller.dart';
import 'package:lottery_ck/res/app_locale.dart';
import 'package:lottery_ck/res/color.dart';
import 'package:lottery_ck/utils.dart';

class KYCPage extends StatelessWidget {
  const KYCPage({super.key});

  @override
  Widget build(BuildContext context) {
    // controller:lazy
    return GetBuilder<KYCController>(
      builder: (controller) {
        return Scaffold(
          backgroundColor: AppColors.background,
          body: SafeArea(
            child: Column(
              children: [
                Header(
                  title: AppLocale.identityVerification.getString(context),
                ),
                Expanded(
                  child: ListView(
                    children: [
                      // banner user
                      // UserBannerComponent(),
                      // const SizedBox(height: 24),
                      Container(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                AppLocale.personalData.getString(context),
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textPrimary,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Container(
                              padding: EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  width: 1,
                                  color: AppColors.containerBorder,
                                ),
                                color: Colors.white,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    AppLocale.prefix.getString(context),
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.textPrimary,
                                      fontSize: 14,
                                    ),
                                  ),
                                  PrefixRadio(
                                    errorText: controller.remark?['gender']
                                                ['status'] ==
                                            false
                                        ? controller.remark!['gender']
                                            ['message']
                                        : null,
                                    defaultValue: controller.gender,
                                    disabled: controller.isLoading,
                                    onChange: (preFix) {
                                      logger.d(preFix);
                                      controller.handleChangeGender(preFix);
                                      return;
                                      controller.gender = preFix.name;
                                    },
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    AppLocale.firstName.getString(context),
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.textPrimary,
                                      fontSize: 14,
                                    ),
                                  ),
                                  InputText(
                                    isError: controller.remark?['firstName']
                                            ['status'] ==
                                        false,
                                    errorText: controller.remark?['firstName']
                                        ['message'],
                                    controller: controller.firstNameController,
                                    disabled: controller.isLoading,
                                    onChanged: (value) {
                                      controller.firstName = value;
                                    },
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    AppLocale.lastName.getString(context),
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.textPrimary,
                                      fontSize: 14,
                                    ),
                                  ),
                                  InputText(
                                    isError: controller.remark?['lastName']
                                            ['status'] ==
                                        false,
                                    errorText: controller.remark?['lastName']
                                        ['message'],
                                    controller: controller.lastNameController,
                                    disabled: controller.isLoading,
                                    onChanged: (value) {
                                      controller.lastName = value;
                                    },
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    AppLocale.birthDate.getString(context),
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.textPrimary,
                                      fontSize: 14,
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () async {
                                      if (controller.isLoading) return;
                                      final datetime = await showDatePicker(
                                        context: context,
                                        firstDate: DateTime(1970),
                                        lastDate: DateTime.now(),
                                        initialDate: DateTime.now(),
                                      );
                                      if (datetime == null) return;
                                      controller.changeBirthDate(datetime);
                                    },
                                    child: Container(
                                      width: double.infinity,
                                      height: 48,
                                      alignment: Alignment.center,
                                      padding: const EdgeInsets.only(
                                          left: 16, right: 8),
                                      decoration: BoxDecoration(
                                        // color: Colors.white,
                                        borderRadius: BorderRadius.circular(4),
                                        border: Border.all(
                                          width: 1,
                                          color: controller.remark?['birthDate']
                                                      ['status'] ==
                                                  false
                                              ? AppColors.errorBorder
                                              : AppColors.inputBorder,
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(controller.birthDate != ""
                                              ? controller.renderBirthDate(
                                                  controller.birthDate)
                                              : "--/--/----"),
                                          Icon(
                                            Icons.calendar_month_outlined,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  if (controller.remark?['birthDate']
                                          ['status'] ==
                                      false) ...[
                                    const SizedBox(height: 8),
                                    Text(
                                      controller.remark?['birthDate']
                                          ['message'],
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: AppColors.errorBorder,
                                      ),
                                    ),
                                  ]
                                ],
                              ),
                            ),
                            const SizedBox(height: 16),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                AppLocale.address.getString(context),
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textPrimary,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Container(
                              padding: EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  width: 1,
                                  color: AppColors.containerBorder,
                                ),
                                color: Colors.white,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    AppLocale.houseNo.getString(context),
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.textPrimary,
                                      fontSize: 14,
                                    ),
                                  ),
                                  InputText(
                                    errorText: controller.remark?['address']
                                                ['status'] ==
                                            false
                                        ? controller.remark!['address']
                                            ['message']
                                        : null,
                                    controller: controller.addressController,
                                    disabled: controller.isLoading,
                                    onChanged: (value) =>
                                        controller.address = value,
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    AppLocale.city.getString(context),
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.textPrimary,
                                      fontSize: 14,
                                    ),
                                  ),
                                  InputText(
                                    errorText: controller.remark?['city']
                                                ['status'] ==
                                            false
                                        ? controller.remark!['city']['message']
                                        : null,
                                    controller: controller.cityController,
                                    disabled: controller.isLoading,
                                    onChanged: (value) =>
                                        controller.city = value,
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    AppLocale.district.getString(context),
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.textPrimary,
                                      fontSize: 14,
                                    ),
                                  ),
                                  InputText(
                                    errorText: controller.remark?['district']
                                                ['status'] ==
                                            false
                                        ? controller.remark!['district']
                                            ['message']
                                        : null,
                                    controller: controller.districtController,
                                    disabled: controller.isLoading,
                                    onChanged: (value) =>
                                        controller.district = value,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 16),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                AppLocale.yourDocumentPhoto.getString(context),
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textPrimary,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Container(
                              padding: EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  width: 1,
                                  color: AppColors.containerBorder,
                                ),
                                color: Colors.white,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Icon(
                                        Icons.new_releases,
                                        color: Colors.red,
                                      ),
                                      Expanded(
                                        child: Text(
                                          AppLocale
                                              .pleaseEnterInformationAndPhotoIDCard
                                              .getString(context),
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                            color: AppColors.textPrimary,
                                          ),
                                          softWrap: true,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Text(
                                    "(${AppLocale.example.getString(context)})",
                                    style: TextStyle(
                                      color: Colors.red,
                                      fontWeight: FontWeight.w600,
                                      decoration: TextDecoration.underline,
                                      decorationColor: Colors.red,
                                    ),
                                  ),
                                  // const SizedBox(height: 8),
                                  // Row(
                                  //   children: [
                                  //     Row(
                                  //       children: [
                                  //         Container(
                                  //           width: 14,
                                  //           height: 14,
                                  //           padding: EdgeInsets.all(2),
                                  //           decoration: BoxDecoration(
                                  //             shape: BoxShape.circle,
                                  //             border: Border.all(
                                  //               width: 1,
                                  //               color: AppColors.inputBorder,
                                  //             ),
                                  //           ),
                                  //           child: Container(
                                  //             decoration: BoxDecoration(
                                  //               shape: BoxShape.circle,
                                  //               color: Colors.red,
                                  //             ),
                                  //           ),
                                  //         ),
                                  //         const SizedBox(width: 4),
                                  //         Text(
                                  //           "เลขที่บัตรประชาชน",
                                  //           style: TextStyle(
                                  //             color: AppColors.textPrimary,
                                  //             fontWeight: FontWeight.w600,
                                  //             fontSize: 14,
                                  //           ),
                                  //         ),
                                  //       ],
                                  //     )
                                  //   ],
                                  // ),
                                  const SizedBox(height: 8),
                                  InputText(
                                    maxLength: 10,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.digitsOnly,
                                    ],
                                    keyboardType: TextInputType.number,
                                    errorText: controller.remark?['idCard']
                                                ['status'] ==
                                            false
                                        ? controller.remark!['idCard']
                                            ['message']
                                        : null,
                                    controller: controller.idCardController,
                                    disabled: controller.isLoading,
                                    onChanged: (value) =>
                                        controller.idCard = value,
                                  ),
                                  const SizedBox(height: 8),
                                  Container(
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                      width: 2,
                                      color: controller.remark?['documentImage']
                                                  ['status'] ==
                                              false
                                          ? AppColors.errorBorder
                                          : Colors.transparent,
                                    )),
                                    child: Builder(
                                      builder: (context) {
                                        if (controller.documentImage != null) {
                                          return Image.file(
                                              controller.documentImage!);
                                        }
                                        if (controller.documentImageUrl !=
                                            null) {
                                          return CachedNetworkImage(
                                            imageUrl:
                                                controller.documentImageUrl!,
                                            progressIndicatorBuilder: (
                                              context,
                                              url,
                                              downloadProgress,
                                            ) =>
                                                Center(
                                              child: CircularProgressIndicator(
                                                value:
                                                    downloadProgress.progress,
                                              ),
                                            ),
                                            errorWidget:
                                                (context, url, error) =>
                                                    const Icon(Icons.error),
                                          );
                                        }
                                        return Container(
                                          padding: EdgeInsets.all(28),
                                          width: double.infinity,
                                          decoration: BoxDecoration(
                                            color: AppColors.documentBackground,
                                          ),
                                          child: SizedBox(
                                            height: 100,
                                            child: Image.asset(
                                              "assets/idcard.png",
                                              fit: BoxFit.fitHeight,
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                  if (controller.remark?['documentImage']
                                          ['message'] !=
                                      "") ...[
                                    const SizedBox(height: 8),
                                    Text(
                                      controller.remark?['documentImage']
                                              ['message'] ??
                                          "",
                                      style: TextStyle(
                                        color: AppColors.errorBorder,
                                        fontSize: 12,
                                      ),
                                    )
                                  ],
                                  const SizedBox(height: 8),
                                  LongButton(
                                    disabled: controller.isLoading,
                                    onPressed: () async {
                                      controller.takeIdCard();
                                    },
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        const Icon(
                                          Icons.camera_alt,
                                          color: Colors.white,
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          AppLocale.takePhoto
                                              .getString(context),
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 16),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                AppLocale.verificationPhoto.getString(context),
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textPrimary,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Container(
                              padding: EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  width: 1,
                                  color: AppColors.containerBorder,
                                ),
                                color: Colors.white,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Icon(
                                        Icons.new_releases,
                                        color: Colors.red,
                                      ),
                                      Expanded(
                                        child: Text(
                                          AppLocale
                                              .pleaseTakePhotoAndClearlyYourDocuments
                                              .getString(context),
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                            color: AppColors.textPrimary,
                                          ),
                                          softWrap: true,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Text(
                                    "(${AppLocale.example.getString(context)})",
                                    style: TextStyle(
                                      color: Colors.red,
                                      fontWeight: FontWeight.w600,
                                      decoration: TextDecoration.underline,
                                      decorationColor: Colors.red,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Container(
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                      width: 2,
                                      color: controller.remark?['verifySelfie']
                                                  ['status'] ==
                                              false
                                          ? AppColors.errorBorder
                                          : Colors.transparent,
                                    )),
                                    child: Builder(
                                      builder: (context) {
                                        if (controller
                                                .selfieWithDocumentImage !=
                                            null) {
                                          return Image.file(controller
                                              .selfieWithDocumentImage!);
                                        }
                                        if (controller
                                                .selfieWithDocumentImageUrl !=
                                            null) {
                                          return CachedNetworkImage(
                                            imageUrl: controller
                                                .selfieWithDocumentImageUrl!,
                                            progressIndicatorBuilder: (
                                              context,
                                              url,
                                              downloadProgress,
                                            ) =>
                                                Center(
                                              child: CircularProgressIndicator(
                                                value:
                                                    downloadProgress.progress,
                                              ),
                                            ),
                                            errorWidget:
                                                (context, url, error) =>
                                                    const Icon(Icons.error),
                                          );
                                        }
                                        return Container(
                                          width: double.infinity,
                                          decoration: BoxDecoration(
                                            color: AppColors.documentBackground,
                                          ),
                                          child: SizedBox(
                                            height: 150,
                                            child: Image.asset(
                                              "assets/idcard_selfie.png",
                                              fit: BoxFit.fitHeight,
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                  if (controller.remark?['verifySelfie']
                                          ['message'] !=
                                      "") ...[
                                    const SizedBox(height: 8),
                                    Text(
                                      controller.remark?['verifySelfie']
                                              ['message'] ??
                                          "",
                                      style: TextStyle(
                                        color: AppColors.errorBorder,
                                        fontSize: 12,
                                      ),
                                    )
                                  ],
                                  const SizedBox(height: 8),
                                  LongButton(
                                    disabled: controller.isLoading,
                                    onPressed: () async {
                                      controller.takeSelfieWithIdCard();
                                    },
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.camera_alt,
                                          color: Colors.white,
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          AppLocale.takePhoto
                                              .getString(context),
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: LongButton(
                    isLoading: controller.isLoading,
                    onPressed: () {
                      controller.sendKYC();
                    },
                    child: Text(
                      AppLocale.confirm.getString(context),
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
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

class UserBannerComponent extends StatelessWidget {
  const UserBannerComponent({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.kycBanner,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            top: -70,
            right: 0,
            child: Container(
              width: 140,
              height: 140,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.secodaryBorder.withOpacity(0.2),
              ),
            ),
          ),
          Positioned(
            right: -140,
            bottom: -130,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.secodaryBorder.withOpacity(0.2),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Container(
                  width: 100,
                  height: 100,
                  // padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      width: 3,
                      color: Colors.white,
                    ),
                  ),
                  child: SettingController.to.profileByte.value != null
                      ? Container(
                          width: 100,
                          height: 100,
                          clipBehavior: Clip.hardEdge,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                          ),
                          child: Image.memory(
                            SettingController.to.profileByte.value!,
                            fit: BoxFit.cover,
                          ),
                        )
                      : Icon(
                          Icons.person,
                          size: 40,
                          color: Colors.white,
                        ),
                ),
                const SizedBox(height: 16),
                Text(
                  LayoutController.to.userApp?.fullName ?? "firstName lastName",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  LayoutController.to.userApp?.phoneNumber ?? "+8562012341234",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
