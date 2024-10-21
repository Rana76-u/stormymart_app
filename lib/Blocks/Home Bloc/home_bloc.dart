import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stormymart_v2/Blocks/Home%20Bloc/home_event.dart';
import 'package:stormymart_v2/Blocks/Home%20Bloc/home_state.dart';

class HomeBloc extends Bloc<HomeEvents, HomeState> {
  HomeBloc() : super(HomeState(
    profileName: 'Login / Sign up',
    profileImageUrl: '',
    cartValue: 0,
  )) {

    on<HomeEvents>((event, emit) {

      if(event is UpdateProfileEvent) {
        emit(state.copyWith(
          profileName: event.name,
          profileImageUrl: event.imageUrl,
        ));
      }

      if(event is UpdateCartValueEvent) {
        emit(state.copyWith(
          cartValue: event.cartValue
        ));
      }
    });
  }
}