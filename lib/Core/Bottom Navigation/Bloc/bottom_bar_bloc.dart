// Package imports:
import 'package:flutter_bloc/flutter_bloc.dart';

// Project imports:
import 'bottom_bar_events.dart';
import 'bottom_bar_state.dart';

class BottomBarBloc extends Bloc<BottomBarEvent, BottomBarState> {
  BottomBarBloc() : super(BottomBarState(index: 0)) {
    on<BottomBarSelectedItem>((event, emit) {
      emit(BottomBarState(index: event.index));
    });
  }
}
