part of 'weather_list_bloc.dart';

class WeatherListState extends Equatable {
  Stream<QuerySnapshot>? weatherList;

  WeatherListState({this.weatherList});

  WeatherListState copyWith({
    Stream<QuerySnapshot>? weatherList,
  }) {
    return WeatherListState(
      weatherList: weatherList ?? this.weatherList,
    );
  }

  @override
  List<Object?> get props => [weatherList];
}

class WeatherListInitial extends WeatherListState {
  @override
  List<Object> get props => [];
}
