import 'dart:convert';

import 'package:bloc_examples/blocs/weather_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WeatherAPIView extends StatelessWidget {
  const WeatherAPIView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          const Expanded(child: SearchResults()),
          TextField(
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Search',
            ),
            onChanged: (value) {
              context.read<WeatherBloc>().add(WeatherSearch(value));
            },
            onSubmitted: (value) {
              context.read<WeatherBloc>().add(WeatherSearch(value));
            },
          ),
        ],
      ),
    );
  }
}

class SearchResults extends StatelessWidget {
  const SearchResults({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<WeatherBloc>().state;

    return switch (state) {
      WeatherInitial() =>
        Center(child: Text("enter a city name to search for weather")),
      // TODO: Handle this case.
      WeatherLoaded(citySearched: var citySearched, json: var json) =>
        Text(const JsonEncoder.withIndent(' ').convert(json)),
      // TODO: Handle this case.
      WeatherSearching(citySearched: var citySearched) => Column(
          children: [
            Text("Searching for $citySearched"),
            LinearProgressIndicator(),
          ],
        ),
      // TODO: Handle this case.
      WeatherError(error: var errorText) => Text("Error: $errorText"),
    };
  }
}
