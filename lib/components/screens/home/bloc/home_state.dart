part of 'home_bloc.dart';

class HomeState extends Equatable {
  bool? dataLoading;
  WeatherModel? weather;
  bool? addedIntoDatabase;
  bool? addingLoader;

  HomeState(
      {this.dataLoading,
      this.weather,
      this.addedIntoDatabase,
      this.addingLoader});

  HomeState copyWith({
    bool? dataLoading,
    WeatherModel? weather,
    bool? addedIntoDatabase,
    bool? addingLoader,
  }) {
    return HomeState(
      dataLoading: dataLoading ?? this.dataLoading,
      weather: weather ?? this.weather,
      addedIntoDatabase: addedIntoDatabase ?? this.addedIntoDatabase,
      addingLoader: addingLoader ?? this.addingLoader,
    );
  }

  @override
  List<Object?> get props =>
      [dataLoading, weather, addedIntoDatabase, addingLoader];
}

final class HomeInitial extends HomeState {
  @override
  List<Object> get props => [];
}
