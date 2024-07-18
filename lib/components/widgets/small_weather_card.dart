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

class SmallWeatherCard extends StatefulWidget {
  WeatherModel weather;

  SmallWeatherCard({super.key, required this.weather});

  @override
  State<SmallWeatherCard> createState() => _SmallWeatherCardState();
}

class _SmallWeatherCardState extends State<SmallWeatherCard> {
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
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${(widget.weather.main?.temp ?? 0.00).toString()}°C",
                      style: CustomTextStyle.getBoldText(textSize: 24.h),
                    ),
                    SizedBox(height: 10.h),
                    Text(
                      "MAX. ${(widget.weather.main?.tempMax ?? 0.00).toString()}°C, MAX. ${(widget.weather.main?.tempMin ?? 0.00).toString()}°C",
                      style: CustomTextStyle.getRegularText(textSize: 12.h),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.wb_sunny,
                color: Colors.orange,
                size: 80.sp,
              ),
            ],
          ),
          SizedBox(height: 10.h),
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
        ],
      ),
    );
  }
}
