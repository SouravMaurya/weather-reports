import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:in_motion/app/constants/string_constants.dart';
import 'package:in_motion/app/firebase/firebase_constants.dart';
import 'package:in_motion/components/screens/home/bloc/repository/home_repository.dart';
import 'package:in_motion/components/screens/home/models/weather_model.dart';

part 'home_event.dart';

part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeRepository homeRepository = HomeRepository();

  HomeBloc() : super(HomeInitial()) {
    on<GetCityWeatherEvent>(onGetCityWeatherEvent);
    on<ResetDataEvent>(onResetDataEvent);
    on<AddDataEvent>(onAddDataEvent);
  }

  Future<void> onAddDataEvent(
      AddDataEvent event, Emitter<HomeState> emit) async {
    try {
      emit(state.copyWith(addingLoader: true));
      DocumentReference documentReferencer =
          FirebaseConstants.getCollectionReference()
              .doc(event.weatherModel.name);

      Map<String, dynamic> data = event.weatherModel.toJson();
      await documentReferencer.set(data).whenComplete(() {
        emit(state.copyWith(addingLoader: false, addedIntoDatabase: true));
        event.completer.complete(true);
      }).catchError((e) {
        emit(state.copyWith(addingLoader: false, addedIntoDatabase: false));
        event.completer.complete(false);
      });
    } catch (e) {
      emit(state.copyWith(addingLoader: false, addedIntoDatabase: false));
      event.completer.complete(false);
      print(e);
    }
  }

  void onResetDataEvent(ResetDataEvent event, Emitter<HomeState> emit) {
    try {
      emit(state.copyWith(weather: WeatherModel()));
    } catch (e) {
      print(e);
    }
  }

  Future<void> onGetCityWeatherEvent(
      GetCityWeatherEvent event, Emitter<HomeState> emit) async {
    try {
      emit(state.copyWith(dataLoading: true));
      WeatherModel? weatherModel =
          await homeRepository.getWeatherByCity(event.cityName.toLowerCase());
      emit(state.copyWith(dataLoading: false, weather: weatherModel));
      event.completer.complete();
    } catch (e) {
      emit(state.copyWith(dataLoading: false));
      event.completer.completeError(e);
      print(e);
    }
  }
}
