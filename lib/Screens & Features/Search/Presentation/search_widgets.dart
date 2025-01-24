import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:stormymart_v2/Screens%20&%20Features/Search/Bloc/search_bloc.dart';
import 'package:stormymart_v2/Screens%20&%20Features/Search/Bloc/search_states.dart';
import '../Bloc/search_events.dart';

class SearchWidgets {

  Widget floatingActionButtonWidget(BuildContext context, SearchStates searchState, ) {
    return Visibility(
      visible: searchState.searchedText != '' ? true : false,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 20, right: 10),
        child: FloatingActionButton.extended(
          onPressed: () {
            GoRouter.of(context).push('/');
          },
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(100.0),
          ),
          icon: const Icon(
              Icons.arrow_back_rounded
          ),
          label: const Text('Go Back'),
        ),
      ),
    );
  }

  Widget title() {
    return const Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(8),
            child: Text(
              "Search Products",
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      );
  }

  Widget searchField(BuildContext context, SearchStates searchState) {

    final blocProvider = BlocProvider.of<SearchBloc>(context);

    return Card(
      elevation: 6,
      child: Row(
        children: [
          SizedBox(
            height: 46,
            width: MediaQuery.of(context).size.width - 24, //*0.9
            child: TextField(
              focusNode: searchState.searchFocusNode,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: "Search",
                hintStyle: TextStyle(
                    fontSize: 17.0,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade500,
                ),
                prefixIcon: GestureDetector(
                    onTap: () {
                      FocusScope.of(context).unfocus();
                      searchState.searchController.clear();

                      blocProvider.add(UpdateIsTyping(false));
                      blocProvider.add(UpdateIsFilterOpen(false));

                      GoRouter.of(context).pop();
                    },
                    child: const Icon(Icons.arrow_back_rounded)
                ),
                suffixIcon: GestureDetector(
                    onTap: () {
                      if(searchState.searchController.text != ''){
                        blocProvider.add(UpdateIsTyping(true));
                        blocProvider.add(UpdateSearchedText(searchState.searchController.text));
                        blocProvider.add(UpdateIsFilterOpen(false));
                        blocProvider.add(UpdateSelectedMinPrice(0));
                        blocProvider.add(UpdateSelectedMaxPrice(1000000));
                      }
                    },
                    child: const Icon(
                      Icons.search_rounded,
                    )
                ),
              ),
              controller: searchState.searchController,
              onSubmitted: (value) {
                // Start the search when the user enters a value in the text field
                blocProvider.add(UpdateIsTyping(true));
                blocProvider.add(UpdateSearchedText(searchState.searchController.text));
                blocProvider.add(UpdateIsFilterOpen(false));
                blocProvider.add(UpdateSelectedMinPrice(0));
                blocProvider.add(UpdateSelectedMaxPrice(1000000));
              },
            ),
          ),
          /*GestureDetector(
            onTap: () {
              blocProvider.add(UpdateIsFilterOpen(true));
            },
            child: Icon(
              Icons.filter_alt_outlined,
              color: searchState.searchFocusNode.hasFocus ? Colors.blue : Colors.grey ,
            ),
          )*/
        ],
      ),
    );
  }

  Widget filteringWidget(BuildContext context, SearchStates searchState) {

    final blocProvider = BlocProvider.of<SearchBloc>(context);

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 200),
      child: searchState.isFilterOpen ?
      Row(
        children: [
          //Rating
          /*Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(top: 10, left: 18),
                            child: Text(
                                'Rating',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontFamily: 'Urbanist'
                              ),
                            )
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width*0.45,
                          child: RangeSlider(
                            values: RangeValues(_selectedMinRating, _selectedMaxRating),
                            min: _minRating,
                            max: _maxRating,
                            divisions: 5,
                            labels: RangeLabels(
                              _selectedMinRating.toString(),
                              _selectedMaxRating.toString(),
                            ),
                            onChanged: (RangeValues values) {
                              setState(() {
                                _selectedMinRating = values.start;
                                _selectedMaxRating = values.end;
                                performSearch(
                                    searchedText,
                                    minRating: _selectedMaxRating,
                                    minPrice: _selectedMinPrice,
                                    maxPrice: _selectedMaxPrice
                                );
                              });
                            },
                          ),
                        )
                      ],
                    ),*/
          //Price
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                  padding: EdgeInsets.only(top: 10, left: 18),
                  child: Text(
                    'Price',
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                    ),
                  )
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width - 30,//0.45
                child: RangeSlider(
                  values: RangeValues(searchState.selectedMinPrice, searchState.selectedMaxPrice),
                  min: 0,
                  max: 10000,
                  divisions: 100,
                  labels: RangeLabels(
                    searchState.selectedMinPrice.toString(),
                    searchState.selectedMaxPrice.toString(),
                  ),
                  onChanged: (RangeValues values) {

                    blocProvider.add(UpdateSelectedMinPrice(values.start));
                    blocProvider.add(UpdateSelectedMaxPrice(values.end));

                    //todo: may not need
                    /*SearchServices().performSearch(
                        searchState.searchedText,
                        //minRating: _selectedMaxRating,
                        minPrice: searchState.selectedMinPrice,
                        maxPrice: searchState.selectedMaxPrice
                    );*/

                  },
                ),
              )
            ],
          )
        ],
      ) : const SizedBox(),
    );
  }

  Widget showSearchedText(BuildContext context, SearchStates searchState) {
    if(searchState.searchedText != ''){
      return Padding(
        padding: const EdgeInsets.only(top: 8, left: 10,),
        child: Row(
          children: [
            const Text('Showing search results for ',),
            Text(
              '"${searchState.searchedText}"',
              style: const TextStyle(
                  fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 5,),
            GestureDetector(
              onTap: () {
                BlocProvider.of<SearchBloc>(context).add(UpdateSearchedText(''));
              },
              child: const Icon(
                Icons.cancel_outlined,
                color: Colors.grey,
                size: 17,
              ),
            )
          ],
        ),
      );
    }
    else {
      return const SizedBox();
    }
  }
}