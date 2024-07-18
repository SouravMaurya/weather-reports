import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:in_motion/app/constants/color_constant.dart';
import 'package:in_motion/app/constants/string_constants.dart';
import 'package:in_motion/app/constants/text_style_constants.dart';
import 'package:in_motion/app/utils/debouncer.dart';
import 'package:in_motion/components/screens/home/models/weather_model.dart';
import 'package:in_motion/components/screens/weather_list/bloc/weather_list_bloc.dart';
import 'package:in_motion/components/widgets/custom_widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:in_motion/components/widgets/small_weather_card.dart';
import 'package:in_motion/components/widgets/weather_card.dart';

class WeatherListScreen extends StatefulWidget {
  const WeatherListScreen({super.key});

  @override
  State<WeatherListScreen> createState() => _WeatherListScreenState();
}

class _WeatherListScreenState extends State<WeatherListScreen> {
  TextEditingController searchController = TextEditingController();
  FocusNode searchFocus = FocusNode();
  WeatherListBloc weatherListBloc = WeatherListBloc();

  final Debouncer _deBouncer =
      Debouncer(delay: const Duration(milliseconds: 500));

  @override
  void initState() {
    weatherListBloc = context.read<WeatherListBloc>();
    weatherListBloc.add(const WeatherListEvent());
    super.initState();
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
          leading: InkWell(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: Icon(
                Icons.arrow_back,
                color: ColorConstants.whiteColor,
                size: 20.h,
              )),
          title: Text(
            StringConstants.weatherList,
            style: CustomTextStyle.getMediumText(
                textSize: 18.h, textColor: ColorConstants.whiteColor),
          ),
        ),
        body: Padding(
          padding: EdgeInsets.all(10.sp),
          child: SingleChildScrollView(
            child: Column(
              children: [
                CustomWidgets.getSearchBar(
                  context,
                  searchController: searchController,
                  searchFocus: searchFocus,
                  onTextChange: (value) {
                    _deBouncer.debounce(
                      () {
                        weatherListBloc.add(SearchWeatherEvent(
                            searchText: value.trim()));
                      },
                    );
                  },
                ),
                SizedBox(
                  height: 10.h,
                ),
                BlocBuilder<WeatherListBloc, WeatherListState>(
                  builder: (context, state) {
                    return StreamBuilder(
                      stream: state.weatherList,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return (snapshot.data!.docs.isNotEmpty)
                              ? ListView(
                                  shrinkWrap: true,
                                  physics: BouncingScrollPhysics(),
                                  children: snapshot.data!.docs.map((e) {
                                    WeatherModel weather =
                                        WeatherModel.fromJson(
                                            e.data() as Map<String, dynamic>);
                                    return Container(
                                      margin:
                                          EdgeInsets.symmetric(vertical: 5.h),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(5.r),
                                          border: Border.all(
                                              color:
                                                  ColorConstants.primaryColor)),
                                      child: ExpansionTile(
                                        backgroundColor: ColorConstants
                                            .primaryColor
                                            .withOpacity(0.2),
                                        title: Text(
                                          weather.name ?? "-",
                                          style: CustomTextStyle.getBoldText(
                                              textSize: 20.h),
                                        ),
                                        children: [
                                          SmallWeatherCard(weather: weather)
                                        ],
                                      ),
                                    );
                                  }).toList(),
                                )
                              : CustomWidgets.noWeatherReportFound();
                        }
                        if (snapshot.hasError) {
                          return CustomWidgets.noWeatherReportFound();
                        }

                        return CustomWidgets.centerLoading();
                      },
                    );
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
