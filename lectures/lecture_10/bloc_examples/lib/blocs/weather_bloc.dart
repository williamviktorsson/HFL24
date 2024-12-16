// help me create a counter bloc, states, events and bloc.

import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:rxdart/rxdart.dart';

sealed class WeatherEvent {}

class WeatherSearch extends WeatherEvent {
  final String city;

  WeatherSearch(this.city);
}

sealed class WeatherState {}

class WeatherInitial extends WeatherState {
  WeatherInitial();
}

class WeatherLoaded extends WeatherState {
  final Map<String, dynamic> json;
  final String citySearched;

  WeatherLoaded(this.citySearched, this.json);
}

class WeatherSearching extends WeatherState {
  final String citySearched;

  WeatherSearching(this.citySearched);
}

class WeatherError extends WeatherState {
  final String citySearched;
  final String error;

  WeatherError(this.citySearched, this.error);
}

class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
  WeatherBloc() : super(WeatherInitial()) {
    const String apiUrl = 'https://goweather.herokuapp.com/weather/';

    on<WeatherSearch>((event, emit) async {
      if (event.city == "") {
        emit(WeatherInitial());
        return;
      }
      emit(WeatherSearching(event.city));

      await Future.delayed(const Duration(milliseconds: 1500));

      emit(WeatherLoaded(event.city, {
        "temperature": "25°C",
        "wind": "10 km/h",
        "description": "Sunny",
      }));

     /*  final response = await http.get(Uri.parse(apiUrl + event.city));
      if (response.statusCode == 200) {
        emit(WeatherLoaded(event.city, json.decode(response.body)));
      } else {
        emit(WeatherError(event.city, response.body));
      } */
    },
        transformer: (events, mapper) => events
            .debounceTime(const Duration(milliseconds: 500))
            .switchMap(mapper));
  }
}
