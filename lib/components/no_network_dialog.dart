import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:lottery_ck/components/long_button.dart';
import 'package:lottery_ck/res/app_locale.dart';

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
            margin: const EdgeInsets.symmetric(horizontal: 16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  AppLocale.noInternetConnectionFound.getString(context),
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  AppLocale.noInternetConnectionFoundDetail.getString(context),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 16),
                LongButton(
                  onPressed: onConfirm,
                  child: Text(
                    AppLocale.retry.getString(context),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
