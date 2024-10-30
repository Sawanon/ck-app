import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottery_ck/components/gender_radio.dart';
import 'package:lottery_ck/components/header.dart';
import 'package:lottery_ck/components/input_text.dart';
import 'package:lottery_ck/components/long_button.dart';
import 'package:lottery_ck/modules/kyc/controller/kyc.controller.dart';
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
          backgroundColor: AppColors.kycBackground,
          body: SafeArea(
            child: Column(
              children: [
                Header(title: ""),
                Expanded(
                  child: ListView(
                    children: [
                      // banner user
                      UserBannerComponent(),
                      const SizedBox(height: 24),
                      Container(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "รายละเอียด",
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textPrimary,
                                  fontSize: 14,
                                ),
                              ),
                            ),
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
                                    "ชื่อ",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.textPrimary,
                                      fontSize: 14,
                                    ),
                                  ),
                                  InputText(
                                    onChanged: (value) {
                                      controller.firstName = value;
                                    },
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    "นามสกุล",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.textPrimary,
                                      fontSize: 14,
                                    ),
                                  ),
                                  InputText(
                                    onChanged: (value) {
                                      controller.lastName = value;
                                    },
                                  ),
                                  const SizedBox(height: 24),
                                  // Row(
                                  //   children: [
                                  //     Expanded(
                                  //       child: Container(
                                  //         padding: EdgeInsets.all(14),
                                  //         decoration: BoxDecoration(
                                  //           border: Border.all(
                                  //             width: 1,
                                  //             color: AppColors.inputBorder,
                                  //           ),
                                  //           borderRadius:
                                  //               BorderRadius.circular(4),
                                  //         ),
                                  //         child: Stack(
                                  //           alignment: Alignment.center,
                                  //           children: [
                                  //             Positioned(
                                  //               left: 0,
                                  //               child: Container(
                                  //                 width: 16,
                                  //                 height: 16,
                                  //                 decoration: BoxDecoration(
                                  //                   shape: BoxShape.circle,
                                  //                   color: Colors.red,
                                  //                   border: Border.all(
                                  //                     width: 1,
                                  //                     color:
                                  //                         AppColors.inputBorder,
                                  //                   ),
                                  //                 ),
                                  //               ),
                                  //             ),
                                  //             Text(
                                  //               "ผู้ชาย",
                                  //               style: TextStyle(
                                  //                 fontSize: 14,
                                  //                 fontWeight: FontWeight.w600,
                                  //                 color: AppColors.textPrimary,
                                  //               ),
                                  //             ),
                                  //           ],
                                  //         ),
                                  //       ),
                                  //     ),
                                  //     const SizedBox(width: 4),
                                  //     Expanded(
                                  //       child: Container(
                                  //         padding: EdgeInsets.all(14),
                                  //         decoration: BoxDecoration(
                                  //           border: Border.all(
                                  //             width: 1,
                                  //             color: AppColors.inputBorder,
                                  //           ),
                                  //           borderRadius:
                                  //               BorderRadius.circular(4),
                                  //         ),
                                  //         child: Stack(
                                  //           alignment: Alignment.center,
                                  //           children: [
                                  //             Positioned(
                                  //               left: 0,
                                  //               child: Container(
                                  //                 width: 16,
                                  //                 height: 16,
                                  //                 decoration: BoxDecoration(
                                  //                   shape: BoxShape.circle,
                                  //                   // color: Colors.red,
                                  //                   border: Border.all(
                                  //                     width: 1,
                                  //                     color:
                                  //                         AppColors.inputBorder,
                                  //                   ),
                                  //                 ),
                                  //               ),
                                  //             ),
                                  //             Text(
                                  //               "ผู้หญิง",
                                  //               style: TextStyle(
                                  //                 fontSize: 14,
                                  //                 fontWeight: FontWeight.w600,
                                  //                 color: AppColors.textPrimary,
                                  //               ),
                                  //             ),
                                  //           ],
                                  //         ),
                                  //       ),
                                  //     ),
                                  //   ],
                                  // ),
                                  GenderRadio(
                                    onChange: (gender) {
                                      controller.gender = gender.name;
                                    },
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    "วันเกิด",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.textPrimary,
                                      fontSize: 14,
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () async {
                                      final datetime = await showDatePicker(
                                        context: context,
                                        firstDate: DateTime(1970),
                                        lastDate: DateTime.now(),
                                        initialDate: DateTime.now(),
                                        // initialDate: controller.birthDate,
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
                                          color: AppColors.inputBorder,
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
                                ],
                              ),
                            ),
                            const SizedBox(height: 16),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "ที่อยู่",
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textPrimary,
                                  fontSize: 14,
                                ),
                              ),
                            ),
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
                                    "บ้านเลขที่",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.textPrimary,
                                      fontSize: 14,
                                    ),
                                  ),
                                  InputText(
                                    onChanged: (value) =>
                                        controller.address = value,
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    "เมือง",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.textPrimary,
                                      fontSize: 14,
                                    ),
                                  ),
                                  InputText(
                                    onChanged: (value) =>
                                        controller.city = value,
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    "แขวง",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.textPrimary,
                                      fontSize: 14,
                                    ),
                                  ),
                                  InputText(
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
                                "รูปเอกสารของท่าน",
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textPrimary,
                                  fontSize: 14,
                                ),
                              ),
                            ),
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
                                          "กรุณาป้อนข้อมูลและถ่ายรูปบัตรประชาชนของท่าน",
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
                                    "(ตัวอย่าง)",
                                    style: TextStyle(
                                      color: Colors.red,
                                      fontWeight: FontWeight.w600,
                                      decoration: TextDecoration.underline,
                                      decorationColor: Colors.red,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    children: [
                                      Row(
                                        children: [
                                          Container(
                                            width: 14,
                                            height: 14,
                                            padding: EdgeInsets.all(2),
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              border: Border.all(
                                                width: 1,
                                                color: AppColors.inputBorder,
                                              ),
                                            ),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: Colors.red,
                                              ),
                                            ),
                                          ),
                                          Text(
                                            "เลขที่บัตรประชาชน",
                                            style: TextStyle(
                                              color: AppColors.textPrimary,
                                              fontWeight: FontWeight.w600,
                                              fontSize: 14,
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                  InputText(
                                    onChanged: (value) =>
                                        controller.idCard = value,
                                  ),
                                  const SizedBox(height: 8),
                                  controller.documentImage != null
                                      ? Image.file(controller.documentImage!)
                                      : Container(
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
                                        ),
                                  const SizedBox(height: 8),
                                  LongButton(
                                    onPressed: () async {
                                      controller.takeIdCard();
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
                                          "ถ่ายรูป",
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
                            ),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "รูปภาพยืนยันตัวตน",
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textPrimary,
                                  fontSize: 14,
                                ),
                              ),
                            ),
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
                                          "กรุณาถ่ายรูปขอวท่านและให้เห็นเอกสารของท่านอย่างชัดเจน",
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
                                    "(ตัวอย่าง)",
                                    style: TextStyle(
                                      color: Colors.red,
                                      fontWeight: FontWeight.w600,
                                      decoration: TextDecoration.underline,
                                      decorationColor: Colors.red,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  controller.selfieWithDocumentImage != null
                                      ? Image.file(
                                          controller.selfieWithDocumentImage!)
                                      : Container(
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
                                        ),
                                  const SizedBox(height: 8),
                                  LongButton(
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
                                          "ถ่ายรูป",
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
                    onPressed: () {
                      controller.sendKYC();
                    },
                    child: Text(
                      "ยืนยัน",
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
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      width: 3,
                      color: Colors.white,
                    ),
                  ),
                  child: Icon(
                    Icons.person,
                    size: 40,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  "firstName lastName",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "+8562055265064",
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
