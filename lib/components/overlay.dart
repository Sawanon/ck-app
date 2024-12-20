import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';
import 'package:lottery_ck/utils.dart';

class OverlayComponent extends StatefulWidget {
  final Widget child;
  const OverlayComponent({
    super.key,
    required this.child,
  });

  @override
  State<OverlayComponent> createState() => _OverlayComponentState();
}

class _OverlayComponentState extends State<OverlayComponent> {
  Future<void> _enableSecureMode() async {
    // await FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_DIM_BEHIND);
    await FlutterWindowManager.clearFlags(FlutterWindowManager.FLAG_SCALED);
  }

  @override
  void initState() {
    _enableSecureMode();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        color: Colors.blue,
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () async {
                await FlutterWindowManager.addFlags(
                    FlutterWindowManager.FLAG_WATCH_OUTSIDE_TOUCH);
                // await FlutterWindowManager.clearFlags(
                //     FlutterWindowManager.FLAG_SCALED);
              },
              child: Text(
                "FLAG_WATCH_OUTSIDE_TOUCH",
              ),
            ),
            Visibility(
              visible: false,
              child: Expanded(
                child: widget.child,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
