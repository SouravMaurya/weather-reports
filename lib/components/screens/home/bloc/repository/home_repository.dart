import 'package:in_motion/app/constants/app_constants.dart';
import 'package:in_motion/app/utils/network_util.dart';
import 'package:in_motion/components/screens/home/models/weather_model.dart';

class HomeRepository {
  Future<WeatherModel?> getWeatherByCity(String cityName) async {
    try {
      var response =
          await NetworkUtil().get(path: "${AppConstants.baseUrl}/city/$cityName/EN");
      return WeatherModel.fromJson(response);
    } catch (e, s) {
      print(e);
      print(s);
    }
    return null;
  }
}
