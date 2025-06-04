import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:lottery_ck/components/long_button.dart';
import 'package:lottery_ck/res/app_locale.dart';
import 'package:lottery_ck/utils.dart';

class NoNetworkDialog extends StatefulWidget {
  final String identifier;
  final Future<void> Function() onConfirm;
  const NoNetworkDialog({
    super.key,
    required this.identifier,
    required this.onConfirm,
  });

  @override
  State<NoNetworkDialog> createState() => _NoNetworkDialogState();
}

class _NoNetworkDialogState extends State<NoNetworkDialog> {
  bool isLoading = false;

  void setIsLoading(bool value) {
    print("isLoading: $value");
    setState(() {
      isLoading = value;
    });
  }

  Future<void> handleOnConfirm() async {
    try {
      setIsLoading(true);
      await widget.onConfirm();
    } catch (e) {
      logger.e(e);
    } finally {
      setIsLoading(false);
    }
  }

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
                  onPressed: handleOnConfirm,
                  isLoading: isLoading,
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
