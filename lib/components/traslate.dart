import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottery_ck/main.dart';
import 'package:lottery_ck/res/icon.dart';

class TranslateComponent extends StatelessWidget {
  const TranslateComponent({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30), topRight: Radius.circular(30)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 10,
            offset: Offset(0, -2),
          )
        ],
      ),
      padding: EdgeInsets.all(40),
      width: MediaQuery.of(context).size.width,
      child: Wrap(
        alignment: WrapAlignment.center,
        children: [
          Text(
            'คุณต้องการเปลี่ยนภาษา ?',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w600,
              color: Color.fromRGBO(89, 89, 89, 1),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    InkWell(
                      onTap: () {
                        localization.translate('lo');
                        Get.back();
                        // MyApp.setLocale(
                        //   context,
                        //   Locale('lo'),
                        // );
                      },
                      child: Image(
                        image: AssetImage(AppIcon.lo),
                      ),
                    ),
                    SizedBox(height: 12),
                    Text('ภาษาลาว'),
                  ],
                ),
                Column(
                  children: [
                    InkWell(
                      onTap: () {
                        localization.translate('th');
                        Get.back();
                        // MyApp.setLocale(
                        //   context,
                        //   Locale('th'),
                        // );
                      },
                      child: Image(
                        image: AssetImage(AppIcon.th),
                      ),
                    ),
                    SizedBox(height: 12),
                    Text('ภาษาไทย'),
                  ],
                ),
                Column(
                  children: [
                    InkWell(
                      onTap: () {
                        localization.translate('en');
                        Get.back();
                        // MyApp.setLocale(
                        //   context,
                        //   Locale('en'),
                        // );
                      },
                      child: Image(
                        image: AssetImage(AppIcon.en),
                      ),
                    ),
                    SizedBox(height: 12),
                    Text('ภาษาอังกฤษ'),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
