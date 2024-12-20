import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottery_ck/components/long_button.dart';

class NoNetworkDialog extends StatelessWidget {
  final String identifier;
  final void Function() onConfirm;
  const NoNetworkDialog({
    super.key,
    required this.identifier,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Material(
          color: Colors.transparent,
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 16),
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "ບໍ່ພົບການເຊື່ອມຕໍ່ອິນເຕີເນັດ",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  "ກະລຸນາກວດສອບການເຊື່ອມຕໍ່ອິນເຕີເນັດ/Wifi ໃນອຸປະກອນມືຖືຂອງເຈົ້າ ແລະລອງເຂົ້າສູ່ລະບົບອີກຄັ້ງ",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 16),
                LongButton(
                  onPressed: onConfirm,
                  child: Text("Reload"),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
