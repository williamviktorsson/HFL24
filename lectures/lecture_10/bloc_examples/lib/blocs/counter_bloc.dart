// help me create a counter bloc, states, events and bloc.

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class CounterEvent {}

class Count {
  final int count;
  const Count(this.count);

  

}

class IncrementEvent extends CounterEvent {}

class DecrementEvent extends CounterEvent {}

class CounterBloc extends Bloc<CounterEvent, Count> {
  CounterBloc() : super(Count(0)) {
    on<IncrementEvent>((event, emit) {
      emit(Count(state.count+1));
    });

    on<DecrementEvent>((event, emit) {

      emit(Count(state.count-1));
    });
  }
}
