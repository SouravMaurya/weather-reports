import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:in_motion/app/constants/app_constants.dart';
import 'package:in_motion/app/constants/routing_constants.dart';
import 'package:in_motion/app/utils/route_util.dart';
import 'package:in_motion/components/screens/home/bloc/home_bloc.dart';
import 'package:in_motion/components/screens/weather_list/bloc/weather_list_bloc.dart';

GlobalKey<NavigatorState> globalNavigationKey = GlobalKey<NavigatorState>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyCYfHpwPFHlwWXPo9nVmQv91UmrjWJVKls",
      projectId: "practical-fc4a1",
      appId: "com.example.practical",
      messagingSenderId: ""
    ),
  );
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(builder: (context, child) {
      return MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => HomeBloc(),
          ),
          BlocProvider(
            create: (context) => WeatherListBloc(),
          ),
        ],
        child: MaterialApp(
          title: AppConstants.appName,
          navigatorKey: globalNavigationKey,
          debugShowCheckedModeBanner: false,
          onGenerateRoute: RouteUtil.generateRoute,
          initialRoute: RoutingConstants.homeScreenRoute,
          themeMode: ThemeMode.light,
        ),
      );
    });
  }
}
