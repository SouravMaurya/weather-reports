import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:in_motion/app/constants/color_constant.dart';
import 'package:in_motion/app/constants/string_constants.dart';
import 'package:in_motion/app/constants/text_style_constants.dart';
import 'package:in_motion/app/utils/route_util.dart';
import 'package:in_motion/components/screens/home/bloc/home_bloc.dart';
import 'package:in_motion/components/screens/home/models/weather_model.dart';
import 'package:in_motion/components/widgets/custom_text_field.dart';
import 'package:in_motion/components/widgets/custom_widgets.dart';
import 'package:in_motion/components/widgets/weather_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _cityController = TextEditingController();
  final FocusNode _cityFocus = FocusNode();

  HomeBloc homeBloc = HomeBloc();

  @override
  void initState() {
    init();
    super.initState();
  }

  Future init() async {
    homeBloc = context.read<HomeBloc>();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: ColorConstants.whiteColor,
        appBar: AppBar(
          backgroundColor: ColorConstants.primaryColor,
          title: Text(
            StringConstants.weatherReport,
            style: CustomTextStyle.getMediumText(
                textSize: 18.h, textColor: ColorConstants.whiteColor),
          ),
          actions: [
            InkWell(
              onTap: () {
                RouteUtil.visitWeatherListPage(context);
              },
              child: Icon(
                Icons.navigate_next,
                color: ColorConstants.whiteColor,
                size: 35.h,
              ),
            )
          ],
        ),
        body: Padding(
          padding: EdgeInsets.all(10.sp),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: CustomTextField(
                        textEditingController: _cityController,
                        focusNode: _cityFocus,
                        hintText: StringConstants.enterCity,
                      ),
                    ),
                    SizedBox(
                      width: 10.w,
                    ),
                    BlocSelector<HomeBloc, HomeState, bool>(
                      selector: (state) => state.dataLoading ?? false,
                      builder: (context, dataLoading) {
                        return CustomWidgets.getLoaderButton(context,
                            buttonText: StringConstants.get.toUpperCase(),
                            textColor: ColorConstants.whiteColor,
                            isLoading: dataLoading,
                            loaderColor: ColorConstants.whiteColor,
                            buttonColor: ColorConstants.primaryColor,
                            buttonWidth: 85.w, onClick: () async {
                          if (_cityController.text.trim().isNotEmpty) {
                            FocusScope.of(context).unfocus();
                            Completer completer = Completer();
                            homeBloc.add(GetCityWeatherEvent(
                                cityName: _cityController.text.trim(),
                                completer: completer));
                            await completer.future.then(
                              (value) {
                                _cityController.clear();
                              },
                            );
                          }
                        });
                      },
                    ),
                  ],
                ),
                SizedBox(
                  height: 20.h,
                ),
                BlocSelector<HomeBloc, HomeState, WeatherModel>(
                  selector: (state) => state.weather ?? WeatherModel(),
                  builder: (context, weather) {
                    if (weather.id != null) {
                      return WeatherCard(weather: weather);
                    }
                    return CustomWidgets.noWeatherReportFound();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
