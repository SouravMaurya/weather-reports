import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:in_motion/app/constants/color_constant.dart';
import 'package:in_motion/app/constants/string_constants.dart';
import 'package:in_motion/app/constants/text_style_constants.dart';
import 'package:in_motion/app/firebase/firebase_constants.dart';
import 'package:in_motion/app/utils/date_utils.dart';
import 'package:in_motion/app/utils/toast_utils.dart';
import 'package:in_motion/components/screens/home/bloc/home_bloc.dart';
import 'package:in_motion/components/screens/home/models/weather_model.dart';
import 'package:in_motion/components/widgets/custom_widgets.dart';
import 'package:intl/intl.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WeatherCard extends StatefulWidget {
  WeatherModel weather;

  WeatherCard({super.key, required this.weather});

  @override
  State<WeatherCard> createState() => _WeatherCardState();
}

class _WeatherCardState extends State<WeatherCard> {
  HomeBloc homeBloc = HomeBloc();

  @override
  void initState() {
    homeBloc = context.read<HomeBloc>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width / 1.07,
      padding: EdgeInsets.all(20.sp),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.8),
        borderRadius: BorderRadius.circular(10.r),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 3,
            blurRadius: 7,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            widget.weather.name ?? "-",
            style: CustomTextStyle.getBoldText(textSize: 26.h),
          ),
          SizedBox(height: 10.h),
          Text(
            DateFormat(DateTimeUtils.EEEE).format(DateTime.now()),
            style: CustomTextStyle.getMediumText(textSize: 16.h),
          ),
          SizedBox(height: 20.h),
          Icon(
            Icons.wb_sunny,
            color: Colors.orange,
            size: 80.sp,
          ),
          SizedBox(height: 20.h),
          Text(
            "${(widget.weather.main?.temp ?? 0.00).toString()}°C",
            style: CustomTextStyle.getBoldText(textSize: 26.h),
          ),
          SizedBox(height: 20.h),
          Text(
            "MAX. ${(widget.weather.main?.tempMax ?? 0.00).toString()}°C, MAX. ${(widget.weather.main?.tempMin ?? 0.00).toString()}°C",
            style: CustomTextStyle.getRegularText(textSize: 14.h),
          ),
          SizedBox(height: 20.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomWidgets.getWeatherInfo(
                  icon: Icons.water_drop,
                  value: "${(widget.weather.main?.humidity ?? 0).toString()}%"),
              CustomWidgets.getWeatherInfo(
                  icon: Icons.air,
                  value:
                      "${(widget.weather.wind?.speed ?? 0).toString()} KM/H"),
              CustomWidgets.getWeatherInfo(
                  icon: Icons.visibility,
                  value: "${(widget.weather.visibility ?? 0).toString()} M"),
              CustomWidgets.getWeatherInfo(
                  icon: Icons.speed,
                  value:
                      "${(widget.weather.main?.pressure ?? 0).toString()} MB"),
            ],
          ),
          SizedBox(height: 20.h),
          BlocSelector<HomeBloc, HomeState, bool>(
            selector: (state) => state.addingLoader ?? false,
            builder: (context, addingLoader) {
              return CustomWidgets.getLoaderButton(context,
                  buttonText: StringConstants.add.toUpperCase(),
                  textColor: ColorConstants.whiteColor,
                  loaderColor: ColorConstants.whiteColor,
                  isLoading: addingLoader,
                  buttonColor: ColorConstants.primaryColor, onClick: () async {
                Completer completer = Completer();
                homeBloc.add(AddDataEvent(
                    weatherModel: widget.weather, completer: completer));
                await completer.future.then(
                  (value) {
                    if (value) {
                      CustomToast.showToast(StringConstants.dataAdded);
                      homeBloc.add(ResetDataEvent());
                    } else {
                      CustomToast.showToast(StringConstants.tryAgain);
                    }
                  },
                );
              });
            },
          )
        ],
      ),
    );
  }
}
