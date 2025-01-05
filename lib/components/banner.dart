import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:lottery_ck/res/color.dart';
import 'package:lottery_ck/utils/theme.dart';

class BannerComponent extends StatefulWidget {
  final List<Widget> items;
  final CarouselOptions options;
  const BannerComponent({
    super.key,
    required this.items,
    required this.options,
  });

  @override
  State<BannerComponent> createState() => _BannerComponentState();
}

class _BannerComponentState extends State<BannerComponent> {
  int _current = 0;
  final CarouselSliderController _controller = CarouselSliderController();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AspectRatio(
          aspectRatio: 21 / 9,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: const [
                AppTheme.softShadow,
              ],
            ),
            child: CarouselSlider(
              carouselController: _controller,
              items: widget.items,
              options: widget.options.copyWith(onPageChanged: (index, reason) {
                setState(() {
                  _current = index;
                });
              }),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: widget.items.asMap().entries.map(
            (e) {
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 4),
                decoration: BoxDecoration(
                  color: _current == e.key
                      ? AppColors.redTone
                      : Color.fromRGBO(171, 172, 167, 1),
                  shape: BoxShape.circle,
                ),
                width: 8,
                height: 8,
              );
            },
          ).toList(),
        ),
      ],
    );
  }
}
