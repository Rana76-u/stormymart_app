import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stormymart_v2/Screens%20&%20Features/Search/Bloc/search_events.dart';
import 'package:stormymart_v2/Screens%20&%20Features/Search/Bloc/search_states.dart';

class SearchBloc extends Bloc<SearchEvent, SearchStates> {
  SearchBloc() : super(SearchStates(
      minPrice: 0,
      maxPrice: 100000,
      selectedMinPrice: 0,
      selectedMaxPrice: 10000,
      searchedText: '',
      isSearching: false,
      isTyping: false,
      isFilterOpen: false,
      searchResults: []
  )){
    on<SearchEvent>((event, emit) {
      SearchStates newState = state;

      if(event is UpdateMinPrice){
        newState = newState.copyWith(minPrice: event.minPrice);
      }
      else if(event is UpdateMaxPrice){
        newState = newState.copyWith(maxPrice: event.maxPrice);
      }
      else if(event is UpdateSelectedMinPrice){
        newState = newState.copyWith(selectedMinPrice: event.selectedMinPrice);
      }
      else if(event is UpdateSelectedMaxPrice){
        newState = newState.copyWith(selectedMaxPrice: event.selectedMaxPrice);
      }
      else if(event is UpdateSearchedText){
        newState = newState.copyWith(searchedText: event.searchedText);
      }
      else if(event is UpdateIsSearching){
        newState = newState.copyWith(isSearching: event.isSearching);
      }
      else if(event is UpdateIsTyping){
        newState = newState.copyWith(isTyping: event.isTyping);
      }
      else if(event is UpdateIsFilterOpen){
        newState = newState.copyWith(isFilterOpen: event.isFilterOpen);
      }
      else if(event is UpdateSearchResults){
        newState = newState.copyWith(searchResults: event.searchResults);
      }

      emit(newState);
    },);
  }
}