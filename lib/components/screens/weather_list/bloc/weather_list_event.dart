part of 'weather_list_bloc.dart';

class WeatherListEvent extends Equatable {
  const WeatherListEvent();

  @override
  List<Object?> get props => [];
}

class SearchWeatherEvent extends WeatherListEvent {
  String searchText;

  SearchWeatherEvent({required this.searchText});

  @override
  List<Object?> get props => [searchText];
}
