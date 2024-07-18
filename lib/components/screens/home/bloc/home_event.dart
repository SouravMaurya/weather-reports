part of 'home_bloc.dart';

class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object?> get props => [];
}

class GetCityWeatherEvent extends HomeEvent {
  String cityName;
  Completer completer;

  GetCityWeatherEvent({required this.cityName, required this.completer});

  @override
  List<Object?> get props => [cityName, completer];
}

class ResetDataEvent extends HomeEvent {
  ResetDataEvent();

  @override
  List<Object?> get props => [];
}

class AddDataEvent extends HomeEvent {
  WeatherModel weatherModel;
  Completer completer;

  AddDataEvent({required this.weatherModel, required this.completer});

  @override
  List<Object?> get props => [weatherModel, completer];
}
