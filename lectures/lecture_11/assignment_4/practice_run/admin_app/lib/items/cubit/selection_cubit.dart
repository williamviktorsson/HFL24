
// selection_cubit.dart
import 'package:replay_bloc/replay_bloc.dart';
import 'package:shared/shared.dart';

class SelectionCubit extends ReplayCubit<Item?> {
  SelectionCubit() : super(null);

  void selectItem(Item? item) => emit(item);
  void clearSelection() => emit(null);
}