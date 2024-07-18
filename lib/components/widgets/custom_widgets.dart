import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:in_motion/app/constants/color_constant.dart';
import 'package:in_motion/app/constants/string_constants.dart';
import 'package:in_motion/app/constants/text_style_constants.dart';
import 'package:in_motion/components/widgets/custom_text_field.dart';
import 'package:in_motion/main.dart';

class CustomWidgets {
  static Widget getLoaderButton(BuildContext context,
      {required String buttonText,
      bool? isLoading,
      Color? buttonColor,
      Color? textColor,
      Color? loaderColor,
      double? textSize,
      double? buttonWidth,
      double? loaderSize,
      Function? onClick}) {
    return InkWell(
      onTap: () {
        onClick!();
      },
      child: Container(
        height: 38.h,
        width: buttonWidth,
        decoration: BoxDecoration(
            color: buttonColor ?? ColorConstants.transparent,
            borderRadius: BorderRadius.circular(8.r),
            border: Border.all(color: ColorConstants.primaryColor)),
        child: Padding(
          padding: EdgeInsets.all(10.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              (isLoading ?? false)
                  ? SpinKitThreeBounce(
                      size: 23.h,
                      color: ColorConstants.whiteColor,
                    )
                  : Text(
                      buttonText,
                      style: CustomTextStyle.getMediumText(
                          textSize: textSize ?? 14.h,
                          textColor: textColor ?? ColorConstants.blackColor),
                    )
            ],
          ),
        ),
      ),
    );
  }

  static Widget getSearchBar(BuildContext context,
      {required TextEditingController searchController,
      required FocusNode searchFocus,
      required Function(String) onTextChange}) {
    return CustomTextField(
      textEditingController: searchController,
      focusNode: searchFocus,
      hintText: StringConstants.search,
      prefixIcon: const Icon(
        CupertinoIcons.search,
        size: 20,
        color: ColorConstants.hintColor,
      ),
      onChange: (value) {
        onTextChange(value ?? "");
      },
      suffixIcon: GestureDetector(
        onTap: () {
          if (searchController.text.trim().isNotEmpty) {
            FocusScope.of(context).unfocus();
            searchController.clear();
          }
        },
        child: const Icon(
          Icons.cancel_outlined,
          color: ColorConstants.hintColor,
        ),
      ),
    );
  }

  static Widget noWeatherReportFound() {
    final size = MediaQuery.of(globalNavigationKey.currentState!.context).size;
    return SizedBox(
      width: size.width,
      child: Column(
        children: [
          SizedBox(
            height: size.height / 3,
          ),
          Text(
            StringConstants.noWeatherReportFound,
            style: CustomTextStyle.getBoldText(
                textSize: 18.sp, textColor: ColorConstants.primaryColor),
          ),
        ],
      ),
    );
  }

  static Widget centerLoading() {
    final size = MediaQuery.of(globalNavigationKey.currentState!.context).size;
    return SizedBox(
      width: size.width,
      child: Column(
        children: [
          SizedBox(
            height: size.height / 2.7,
          ),
          SpinKitThreeBounce(
            size: 23.h,
            color: ColorConstants.primaryColor,
          ),
        ],
      ),
    );
  }

  static Widget getWeatherInfo({
    required IconData icon,
    required String value,
  }) {
    return Column(
      children: [
        Icon(icon, size: 30, color: ColorConstants.primaryColor),
        const SizedBox(height: 5),
        Text(
          value,
          style: CustomTextStyle.getRegularText(textSize: 12.sp),
        ),
      ],
    );
  }
}
