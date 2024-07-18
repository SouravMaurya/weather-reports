import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:in_motion/app/firebase/firebase_constants.dart';
import 'package:in_motion/components/screens/home/models/weather_model.dart';

part 'weather_list_event.dart';

part 'weather_list_state.dart';

class WeatherListBloc extends Bloc<WeatherListEvent, WeatherListState> {
  WeatherListBloc() : super(WeatherListInitial()) {
    on<WeatherListEvent>(onWeatherListEvent);
    on<SearchWeatherEvent>(onSearchWeatherEvent);
  }

  Future<void> onSearchWeatherEvent(
      SearchWeatherEvent event, Emitter<WeatherListState> emit) async {
    try {

      state.weatherList!.map((QuerySnapshot<Object?> snapshot) {
        final filteredDocs = snapshot.docs.where((doc) {
          WeatherModel data = WeatherModel.fromJson(doc.data() as Map<String, dynamic>);
          final fieldToSearch = data.name;
          return (fieldToSearch ?? "").toLowerCase().contains(event.searchText.toLowerCase());
        }).toList();
        return filteredDocs;
      });
      emit(state.copyWith(weatherList: state.weatherList));
    } catch (e, s) {
      print(e);
      print(s);
    }
  }

  Future<void> onWeatherListEvent(
      WeatherListEvent event, Emitter<WeatherListState> emit) async {
    try {
      CollectionReference notesItemCollection =
          FirebaseConstants.getCollectionReference();
      Stream<QuerySnapshot> snapShotsData = notesItemCollection.snapshots();
      emit(state.copyWith(weatherList: snapShotsData));
    } catch (e, s) {
      print(e);
      print(s);
    }
  }
}
