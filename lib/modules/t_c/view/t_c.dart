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
  final bool? enabledAcceptBtn;
  const TCPage({
    super.key,
    this.enabledAcceptBtn = true,
  });

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
                    Text(
                      "ຂໍ້ກໍານົດ ແລະ ເງື່ອນໄຂ",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
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
                            controller: controller.scrollController,
                            shrinkWrap: true,
                            children: [
                              Text("   ${controller.title}"),
                              const SizedBox(height: 16),
                              Text(
                                "1. ຂໍ້ມູນສ່ວນຕົວຂອງຜູ້ນໍາໃຊ້",
                              ),
                              Text(
                                "   ຫວຍຊີເຄ ຈໍາເປັນຈະຕ້ອງເກັບຂໍ້ມູນພື້ນຖານທີ່ກົງກັບຂໍ້ມູນສ່ວນຕົວ, ເບີໂທລະສັບ ແລະ ອື່ນໆ ຂອງບັນດາລູກຄ້າທີ່ໃຊ້ບໍລິການ ໂດຍການເກັບໄວ້ໃນລະບົບແຕ່ລະຄັ້ງ ເພື່ອອໍານວຍຄວາມສະດວກໃນການເຮັດທຸລະກໍາທຸກຮູບແບບ ແລະ ການແກ້ໄຂບັນຫາຕ່າງໆ ທີ່ອາດຈະເກີດຂຶ້ນ ພ້ອມທັງນໍາໃຊ້ເຂົ້າໃນການປັບປຸງການໃຫ້ການບໍລິການຂອງ ຫວຍຊີເຄ ເພື່ອໃຫ້ແທດເຫມາະກັບສະພາບຄວາມເປັນຈິງ ຕາມຄວາມຮຽກຮ້ອງຕ້ອງການຂອງການນໍາໃຊ້ໃນແຕ່ລະໄລຍະ ຊຶ່ງທຸກໆການບັນທຶກຂໍ້ມູນຈະຖືກເກັບຮັກສາໄວ້ເປັນຄວາມລັບ ແລະ ຈະບໍ່ຖືກເປີດເຜີຍໃຫ້ກັບທຸກພາກສ່ວນທີ່ບໍ່ກ່ຽວຂ້ອງຢ່າງເດັດຂາດ.",
                                softWrap: true,
                              ),
                              const SizedBox(height: 8),
                              Text("2. ເງື່ອນໄຂການໃຫ້ບໍລິການ"),
                              Text(
                                "    ຜູ້ໃຊ້ບໍລິການ ແມ່ນສາມາດແນະນໍາຫມູ່ເພື່ອນນໍາໃຊ້ແອັບ ຫວຍຊີເຄ ຈະໄດ້ຮັບຜົນຕອບແທນ 5% ໂດຍການເຮັດທຸລະກໍາແຕ່ລະຄັ້ງ ແລະ ຈະຖືກໂອນເຂົ້າເລກບັນຊີຂອງຜູ້ໃຊ້ບໍລິການບໍ່ເກີນ 5 ນາທີ, ຜູ້ໃຊ້ບໍລິການແອັບ ຫວຍຊີເຄ ຕ້ອງປະຕິບັດຕາມຂໍ້ກໍານົດ ໂດຍບໍລິສັດພວກເຮົາສະຫງວນສິດໃນການປ່ຽນແປງ ໂດຍບໍ່ມີການແຈ້ງລ່ວງຫນ້າ ແລະ ເງື່ອນໄຂຂອງການໃຫ້ບໍລິການ ຊຶ່ງມີລາຍລະອຽດດັ່ງນີ້:",
                              ),
                              const SizedBox(height: 4),
                              Text(
                                "   1) ການຊື້ຫວຍ",
                              ),
                              Row(
                                children: [
                                  const SizedBox(
                                    width: 16,
                                  ),
                                  Expanded(
                                    child: Text(
                                      "- ບໍລິການຊື້ຫວຍ ເພື່ອສ່ຽງໂຊກ ແລະ ຊິງລາງວັນກັບບໍລິສັດ ລັດວິສາຫະກິດ ຫວຍພັດທະນາ ຜູ້ໃຊ້ບໍລິການຕ້ອງປະຕິບັດຕາມກົດຫມາຍ, ຂໍ້ກໍານົດ, ເງື່ອນໄຂ ຫວຍຊີເຄ ແລະ ລະບຽບການຂອງຫວຍພັດທະນາ ຢ່າງເຂັ້ມງວດ;",
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  const SizedBox(
                                    width: 16,
                                  ),
                                  Expanded(
                                    child: Text(
                                      "- ມີກຸ່ມເລກແຕ່ ເລກ 1 ຫາ 6 ໂຕ ທີ່ອອກທຸກໆ ວັນຈັນ, ວັນພຸດ ແລະ ວັນສຸກ ທີ່ໃຫ້ບໍລິການຜ່ານແອັບ",
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  const SizedBox(
                                    width: 16,
                                  ),
                                  Expanded(
                                    child: Text(
                                      "- ຜູ້ໃຊ້ບໍລິການ ຕ້ອງມີແອັບບັນຊີທະນາຄານ ເພື່ອຊໍາລະຄ່າບໍລິການຊື້ຫວຍ ແລະ ຮັບເງິນລາງວັນ;",
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  const SizedBox(
                                    width: 16,
                                  ),
                                  Expanded(
                                    child: Text(
                                      "- ຜູ້ໂຊກດີທີ່ໄດ້ຊື້ຜ່ານແອັບແຕ່ລະງວດ ຈະໄດ້ຮັບເງິນລາງວັນຜ່ານແອັບບັນຊີທະນາຄານ ທີ່ເຮັດການຊໍາລະເງິນ ທັນທີ ຫລື ຊ້າສຸດບໍ່ເກີນ 1 ຊົ່ວໂມງ ພາຍຫລັງທີ່ປະກາດຜົນການອອກເລກລາງວັນຢ່າງເປັນທາງການ;",
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  const SizedBox(
                                    width: 16,
                                  ),
                                  Expanded(
                                    child: Text(
                                      "- ສໍາລັບການແນະນໍາໃຊ້ແອັບບໍລິການຊື້ຫວຍ ແມ່ນທາງບໍລິສັດໄດ້ມີການກໍານົດເງື່ອນໄຂ ແລະ ນະໂຍບາຍ;",
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  const SizedBox(
                                    width: 16,
                                  ),
                                  Expanded(
                                    child: Text(
                                      "- ໃຫ້ທ່ານກວດປະຫວັດບິນຫວຍທຸກຄັ້ງ, ຖ້າຊື້ບໍ່ໄດ້ບິນ ໃຫ້ແຈ້ງ Call Center ທາງເຮົາຈະສົ່ງເງິນຄືນທັນທີກ່ອນເລກອອກ 20:00 ໂມງແລງ.",
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  const SizedBox(
                                    width: 16,
                                  ),
                                  Expanded(
                                    child: Text(
                                      "#ຫມາຍເຫດ: ກໍລະນີບິນຖືກລາງວັນ ຈະບໍ່ມີສິດໄດ້ຮັບເງິນລາງວັນ ຈະໄດ້ຄືນແຕ່ເງິນທີ່ຖືກຕັດ.",
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  const SizedBox(
                                    width: 16,
                                  ),
                                  Expanded(
                                    child: Text(
                                      "2) ການຈ່າຍເງິນລາງວັນຖືກຫວຍ ມີຮູບແບບດັ່ງນີ້:",
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  const SizedBox(
                                    width: 16,
                                  ),
                                  Expanded(
                                    child: Text(
                                      "- ກໍລະນີຫາກລູກຄ້າຖືກຫວຍລາງວັນ ລະບົບຈະດໍາເນີນການຊໍາລະໂອນເງິນລາງວັນ ໄປທີ່ບັນຊີຂອງລູກຄ້າທີ່ໄດ້ຊໍາລະໃນການຊື້ຫວຍ.",
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text("3. ຄວາມຮັບຜິດຊອບຂອງຜູ້ໃຊ້ບໍລິການ"),
                              Text(
                                "   ຜູ້ໃຊ້ບໍລິການ ຕ້ອງຮັບຜິດຊອບຕໍ່ຜົນເສຍຫາຍທີ່ເກີດຂຶ້ນ ຈາກຄວາມຜິດພາດຂອງຕົນ ໂດຍອີງຕາມຂໍ້ກໍານົດ, ນະໂຍບາຍ, ເງື່ອນໄຂຂອງການບໍລິການ, ລະບຽບການ ແລະ ກົດຫມາຍທີ່ກ່ຽວຂ້ອງຂອງ ສປປ ລາວ ທີ່ກໍານົດໄວ້.",
                              ),
                              Text("4. ຄວາມຮັບຜິດຊອບຂອງ ຫວຍຊີເຄ"),
                              Text(
                                "   ຫວຍຊີເຄ ຈະມີຄວາມຮັບຜິດຊອບໃຊ້ແທນຄ່າເສຍຫາຍທີ່ເກີດຂຶ້ນ ຈາກຂອດການໃຫ້ບໍລິການ ໂດຍອີງໃສ່ຂໍ້ກໍານົດ, ເງື່ອນໄຂ ຂອງການບໍລິການແຕ່ລະດ້ານ ບົນພື້ນຖານພາຍໃຕ້ລະບຽບກົດຫມາຍຂອງ ສປປ ລາວ ໄດ້ກໍານົດໄວ້.",
                              ),
                              Text("5. ຂໍ້ຫ້າມ"),
                              Text(
                                "   - ຫ້າມຜູ້ໃຊ້ບໍລິການຂອງ ຫວຍຊີເຄ ມີພຶດຕິກໍາໃນການສໍ້ໂກງ, ຍັກຍ້ອກຊັບ ຫລື ສ້າງບັນຫາຕ່າງໆ ທີ່ຜິດຕໍ່ລະບຽບ ແລະ ກົດຫມາຍຂອງ ສປປ ລາວ ກໍານົດໄວ້;",
                              ),
                              Text(
                                "   - ຫ້າມນໍາໃຊ້ແອັບ ຫວຍຊີເຄ ເພື່ອເປັນສາກບັງຫນ້າໃນການເຄື່ອນໄຫວສິ່ງຜິດກົດຫມາຍ ເປັນຕົ້ນ: ການຂົນ ສົ່ງສິນຄ້າເກືອດຫ້າມ ແລະ ການຈໍາຫນ່າຍຫວຍເຖື່ອນຢ່າງເດັດຂາດ;",
                              ),
                              Text(
                                "   - ຫວຍຊີເຄ ຂໍສະຫງວນລິຂະສິດໃນບັນດາການປ່ຽນແປງຂໍ້ກໍານົດ, ນະໂຍບາຍ ແລະ ເງື່ອນໄຂຕ່າງໆ ໂດຍບໍ່ມີການແຈ້ງໃຫ້ຜູ້ໃຊ້ບໍລິການຊາບລ່ວງຫນ້າ, ຊຶ່ງບັນດາຂໍ້ມູນຂ້າງເທິງ ແມ່ນໄດ້ອີງໃສ່ກົດຫມາຍ ແລະ ນິຕິກໍາອື່ນໆ ພາຍໃຕ້ກົດຫມາຍ ເພື່ອເປັນບ່ອນອີງໃນການຈັດຕັ້ງປະຕິບັດ.",
                              ),
                              Text("6. ຄະແນນ"),
                              Text(
                                "   - ຄະແນນ ແມ່ນໄດ້ຮັບຈາກການຊີ້ຫວຍພັດທະນາ ແລະ ອື່ນໆ ຕາມນະໂຍບາຍໃນແຕ່ລະໄລຍະຂອງບໍລິສັດ ຊີເຄ ການຄ້າ ຂາອອກ-ຂາເຂົ້າ ຈໍາກັດຜູ້ດຽວ;",
                              ),
                              Text(
                                "   •	ເງື່ອນໄຂການໄດ້ຮັບຄະແນນ",
                              ),
                              Row(
                                children: [
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Text(
                                      "-	ຊື້ຫວຍພັດທະນາ, ຕື່ມມູນຄ່າໂທ ແລະ ອື່ນໆ ໂດຍຊໍາລະເງິນຜ່ານລະບົບບັນຊີທະນາຄານ ຫລື ກະເປົ໋າເງິນເອເລັກໂຕຣນິກຂັ້ນຕໍ່າ 10.000 ກີບ ຂຶ້ນໄປ ຈະໄດ້ຮັບຄະແນນທັນທີ, ຜະລິດຕະພັນທີ່ຈະໄດ້ຮັບຄະແນນ ແລະ ເປີ ເຊັນຂອງຄະແນນທີ່ໄດ້ຮັບ ແມ່ນໄດ້ອີງຕາມນະໂຍບາຍຂອງ ບໍລິສັດ ຊີເຄ ການຄ້າ ຂາອອກ-ຂາເຂົ້າ ຈໍາກັດຜູ້ດຽວ.",
                                    ),
                                  ),
                                ],
                              ),
                              Text(
                                "   •	ການນໍາໃຊ້ຄະແນນ",
                              ),
                              Row(
                                children: [
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Text(
                                      "- 1 ຄະແນນເທົ່າກັບ 1 ກີບ:",
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Text(
                                      "- ການນໍາໃຊ້ຄະແນນໃນແຕ່ລະຄັ້ງ ຕ້ອງແມ່ນຈໍານວນເງິນທຽບເທົ່າກັບມູນຄ່າຜະລິດຕະພັນທີ່ຊື້;",
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Text(
                                      "- ຕົວຢ່າງ: ຖ້າລູກຄ້າມີຄະແນນສະສົມຮອດ 1.000 ຄະແນນ ລູກຄ້າສາມາດແລກຊື້ຫວຍພັດທະນາ ໂດຍອີງຕາມນະໂຍບາຍໃນແຕ່ລະໄລຍະ ຂອງ ຊີເຄ ການຄ້າ ຂາອອກ-ຂາເຂົ້າ ຈໍາກັດຜູ້ດຽວ.",
                                    ),
                                  ),
                                ],
                              ),
                              Text("   • ເງື່ອນໄຂຂອງເງິນແນະນໍາ"),
                              Row(
                                children: [
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Text(
                                      "- ໃນຫນ້າຈໍຊໍາລະເງິນ: ຈະມີຫ້ອງໃຫ້ທ່ານປ້ອນເລກຫມາຍຂອງຜູ້ແນະນໍາໃສ່, ແນະນໍາຫມູ່ເພື່ອນປ້ອນເລກຫມາຍແນະນໍາຂອງທ່ານໃສ່ຫ້ອງດັ່ງກ່າວ.",
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Text(
                                      "- ທ່ານຈະໄດ້ຮັບເງິນແນະນໍາ ຈໍານວນ 5% ຈາກຫມູ່ເພື່ອນໃນເວລາມີການຊື້ຫວຍຜ່ານແອັບ;",
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Text(
                                      "- ພາຍໃນ 6 ເດືອນທໍາອິດ ເພື່ອນຂອງທ່ານຈະບໍ່ສາມາດປ່ຽນແປງລະຫັດແນະນໍາຂອງທ່ານໄດ້ ຈົນກວ່າຈະສິ້ນສຸດກໍານົດເວລາ ແລ້ວຈຶ່ງສາມາດປ່ຽນເລກແນະນໍາໃຫ້ຄົນອື່ນແທນ;",
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Text(
                                      "- ທ່ານຈະໄດ້ຮັບເງິນແນະນໍາ ໂດຍການໂອນເຂົ້າບັນຊີທະນາຄານການຄ້າ (BCEL) ຫລື ທະນາຄານອື່ນໆ ທີ່ທ່ານໃຊ້ໃນຄັ້ງທໍາອິດ;",
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Text(
                                      "- ການປ່ຽນແປງເງື່ອນໄຂ ຫລື ນະໂຍບາຍຕ່າງໆໃນແຕ່ລະຄັ້ງ ທາງບໍລິສັດແມ່ນຂໍສະຫງວນສິດ ໂດຍບໍ່ມີການແຈ້ງໃຫ້ທ່ານຮັບຊາບລ່ວງຫນ້າ.",
                                    ),
                                  ),
                                ],
                              ),

                              // ...controller.tc['lo']!.map((data) {
                              //   return Column(
                              //     mainAxisSize: MainAxisSize.min,
                              //     children: [
                              //       Row(
                              //         children: [
                              //           SizedBox(
                              //             width: 16,
                              //             child: Text("${data['point']}."),
                              //           ),
                              //           Text("${data['title']}"),
                              //         ],
                              //       ),
                              //       Row(
                              //         children: [
                              //           SizedBox(
                              //             width: 16,
                              //           ),
                              //           Expanded(
                              //             child: Text(
                              //               "${data['text']}",
                              //               softWrap: true,
                              //             ),
                              //           ),
                              //         ],
                              //       ),
                              //     ],
                              //   );
                              // }).toList(),
                            ],
                          );
                        }),
                      ),
                    ),
                    if (enabledAcceptBtn == true)
                      Container(
                        alignment: Alignment.bottomCenter,
                        padding: const EdgeInsets.all(16.0),
                        child: Obx(() {
                          return LongButton(
                            disabled: controller.disabledButton.value,
                            isLoading: controller.isLoading,
                            onPressed: () {
                              controller.onAccept();
                            },
                            child: Text(
                              AppLocale.accept.getString(context),
                            ),
                          );
                        }),
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
