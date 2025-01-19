import 'package:flutter_bloc/flutter_bloc.dart';

class FilterItemsCubit extends Cubit<String> {
  FilterItemsCubit() : super("");

  filter(String string) {
    emit(string);
  }

  clear() {
    emit("");
  }
}
