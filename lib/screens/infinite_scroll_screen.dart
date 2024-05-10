import 'package:auto_size_text/auto_size_text.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:easy_rich_text/easy_rich_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_demo_apps/utils/Utils.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class InfiniteScrollScreen extends StatefulWidget {
  const InfiniteScrollScreen({super.key});

  @override
  State<InfiniteScrollScreen> createState() => _InfiniteScrollScreenState();
}

class _InfiniteScrollScreenState extends State<InfiniteScrollScreen> {
  /// keep track of switch being on/off
  bool _switchValue = false;

  /// what to append to the list every [_scrollDuration] seconds
  final List<Slide> _slides = [
    Slide("assets/images/all_collections.jpg", "All collections"),
    Slide("assets/images/stickers.jpg", "Unique Stickers"),
    Slide("assets/images/fonts.jpg", "Additional Fonts"),
    Slide("assets/images/features.jpg", "All Features"),
  ];

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: SizedBox(
          height: 1.sh,
          width: 1.sw,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.r),
            child: ScrollConfiguration(
              // used to remove the glow from scrolling lists
              behavior: NoMoreGlow(),
              child: ListView(
                shrinkWrap: true,
                children: [
                  SizedBox(height: 60.h),

                  /// SCREEN TITLE AND BACK BUTTON
                  _buildScreenTitle(),

                  SizedBox(height: 73.h),

                  /// ANIMATED SLIDESHOW
                  _buildCarousel(),

                  SizedBox(height: 80.h),

                  /// CALL TO ACTION TEXT
                  _buildCallToAction(),

                  SizedBox(height: 48.h),

                  /// SWITCH BUTTON
                  _buildToggleButton(),

                  SizedBox(height: 16.h),

                  /// CONTINUE BUTTON
                  _buildButton(),

                  SizedBox(height: 16.h),

                  /// PRICE TEXT
                  _buildPrice(),

                  SizedBox(height: 60.h),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildScreenTitle() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(width: 32.w),

        /// SCREEN TITLE
        Text(
          "Already Purchased?",
          style: Theme.of(context).textTheme.titleSmall,
        ),

        /// BACK BUTTON
        ClipOval(
          child: Material(
            color: Colors.white,
            child: InkWell(
              splashColor: Colors.transparent,
              onTap: () {
                Navigator.pop(context);
              },
              child: Padding(
                padding: EdgeInsets.all(7.r),
                child: Icon(
                  Icons.close_rounded,
                  color: Colors.black,
                  size: 14.w,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCarousel() {
    return CarouselSlider(
      items: _slides.map((slide) => _buildSlide(slide)).toList(),
      options: CarouselOptions(
        aspectRatio: 1.6,
        enlargeCenterPage: false,
        autoPlay: true,
        autoPlayInterval: const Duration(seconds: 2),
        autoPlayAnimationDuration: const Duration(seconds: 2),
        pauseAutoPlayOnTouch: false,
        scrollPhysics: const NeverScrollableScrollPhysics(),
        initialPage: 0,
        autoPlayCurve: Curves.linear,
        viewportFraction: 0.5,
      ),
    );
  }

  Widget _buildSlide(Slide slide) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w),
      height: 232.h,
      width: 162.w,
      child: Column(
        children: [
          /// SLIDE IMAGE
          SizedBox(
            height: 202.h,
            width: 162.w,
            child: ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16.sp),
                topRight: Radius.circular(16.sp),
              ),
              child: Image.asset(
                slide.img,
                fit: BoxFit.cover,
              ),
            ),
          ),

          /// SLIDE TITLE
          Expanded(
            child: Container(
              width: 162.w,
              decoration: BoxDecoration(
                color: const Color.fromRGBO(48, 48, 54, 1),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(16.sp),
                  bottomRight: Radius.circular(16.sp),
                ),
              ),
              child: Expanded(
                child: Center(
                  child: AutoSizeText(
                    slide.title,
                    style: Theme.of(context).textTheme.bodySmall,
                    minFontSize: 8,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCallToAction() {
    return Column(
      children: [
        /// CALL TO ACTION TITLE
        Text(
          "Get Full Access",
          style: Theme.of(context).textTheme.headlineMedium,
        ),

        EasyRichText(
          "Cancel Anytime, *We'll still love you.*",
          defaultStyle: Theme.of(context).textTheme.titleMedium,
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          patternList: [
            EasyRichTextPattern(
              // matches anything that is between *
              // (e.g. This is *matched* but this is not)
              targetString: '(\\*)(.*?)(\\*)',
              matchBuilder: (
                BuildContext context,
                RegExpMatch? match,
              ) {
                return TextSpan(
                  text: match?[0]?.replaceAll('*', ''),
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Colors.white.withOpacity(0.7),
                      ),
                );
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildToggleButton() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10.r, horizontal: 32.r),
      decoration: BoxDecoration(
        border: Border.all(color: const Color.fromRGBO(48, 48, 54, 1)),
        borderRadius: BorderRadius.all(Radius.circular(100.r)),
      ),
      width: 343.w,
      height: 70.h,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Flexible(
                child: AutoSizeText(
                  _switchValue ? "Free Trial Enabled" : "Not sure yet?",
                  style: Theme.of(context).textTheme.titleSmall,
                  maxLines: 1,
                ),
              ),
              !_switchValue
                  ? Flexible(
                      child: AutoSizeText(
                        "Enable free trial",
                        style: Theme.of(context).textTheme.bodyMedium,
                        maxLines: 1,
                      ),
                    )
                  : const SizedBox(),
            ],
          ),
          SizedBox(
            width: 51.w,
            // height: 31.h,
            child: FittedBox(
              fit: BoxFit.fill,
              child: CupertinoSwitch(
                  trackColor: const Color.fromRGBO(116, 116, 123, 1),
                  value: _switchValue,
                  onChanged: (val) {
                    setState(() {
                      _switchValue = val;
                    });
                  }),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildButton() {
    return SizedBox(
      width: 343.w,
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: Colors.white,
          alignment: Alignment.center,
          padding: EdgeInsets.all(16.r),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(80.r),
          ),
        ),
        child: Text(
          _switchValue ? "Start 7 Days Free trial" : "Continue",
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: Colors.black,
              ),
        ),
      ),
    );
  }

  Widget _buildPrice() {
    return Text(
      _switchValue ? "7 days for free, then \$2,99/Month" : "\$2,99/Month",
      style: Theme.of(context).textTheme.titleMedium,
      textAlign: TextAlign.center,
    );
  }
}

/// Class used to store an image and a title
class Slide {
  String img;
  String title;

  Slide(this.img, this.title);
}
