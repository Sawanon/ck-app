import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:lottery_ck/res/app_locale.dart';
import 'package:lottery_ck/res/color.dart';
import 'package:lottery_ck/res/icon.dart';
import 'package:lottery_ck/utils.dart';

class RatingComponent extends StatefulWidget {
  final Function(double rating, String? comment) onSubmit;
  const RatingComponent({
    super.key,
    required this.onSubmit,
  });

  @override
  State<RatingComponent> createState() => _RatingComponentState();
}

class _RatingComponentState extends State<RatingComponent> {
  double _rating = 5;
  String? _comment;
  @override
  Widget build(BuildContext context) {
    return Container(
      // height:
      //     MediaQuery.of(context).size.height * 0.8,
      padding: EdgeInsets.only(
        top: 20,
        right: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
        left: 20,
      ),
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
        // boxShadow: [
        //   BoxShadow(
        //     spreadRadius: 2,
        //     blurRadius: 10,
        //     color: Colors.grey.withOpacity(0.5),
        //     offset: Offset(0, 0),
        //   )
        // ],
      ),
      child: Wrap(
        children: [
          Center(
            child: Text(
              // 'แนะนำบริการ',
              AppLocale.feedback.getString(context),
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 14),
            child: Center(
              child: RatingBar(
                glowColor: Colors.amber,
                initialRating: _rating,
                direction: Axis.horizontal,
                allowHalfRating: true,
                itemCount: 5,
                ratingWidget: RatingWidget(
                  full: Image(image: AssetImage(AppIcon.star)),
                  half: Image.asset(AppIcon.starhalf),
                  empty: Image.asset(AppIcon.starempty),
                ),
                itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                onRatingUpdate: (rating) {
                  logger.d(rating);
                  _rating = rating;
                  // _settingViewModel.onChangeRating(rating.toString());
                },
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 20),
            child: TextFormField(
              maxLines: 8,
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Color.fromRGBO(218, 218, 218, 1),
                    width: 1,
                  ),
                ),
                border: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Color.fromRGBO(218, 218, 218, 1),
                    width: 1,
                  ),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
              onChanged: (value) {
                logger.d("value: $value");
                _comment = value;
              },
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 24, bottom: 16),
            child: Material(
              color: Color.fromRGBO(0, 117, 255, 1),
              borderRadius: BorderRadius.circular(16),
              child: InkWell(
                onTap: () {
                  widget.onSubmit(_rating, _comment);
                },
                child: Container(
                  alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width,
                  height: 52,
                  child: Text(
                    AppLocale.confirm.getString(context),
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
