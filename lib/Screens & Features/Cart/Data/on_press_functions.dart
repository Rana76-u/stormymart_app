// Flutter imports:
import 'package:flutter/cupertino.dart';

// Package imports:
import 'package:flutter_bloc/flutter_bloc.dart';

// Project imports:
import 'package:stormymart_v2/Screens%20&%20Features/Cart/Bloc/cart_states.dart';
import '../Bloc/cart_bloc.dart';
import '../Bloc/cart_events.dart';

class CartOnPressFunctions {

  void onIndividualItemCheckBoxClicked(BuildContext context, int index, bool isChecked) {
    final provider = BlocProvider.of<CartBloc>(context);
    provider.add(UpdateCheckList(index: index, isChecked: isChecked));
  }

  void onSelectAllItemCheckBoxClicked(BuildContext context, CartState cartState, bool isChecked) {
    final provider = BlocProvider.of<CartBloc>(context);
    for(int i=0; i<cartState.idList.length; i++){
      provider.add(UpdateCheckList(index: i, isChecked: isChecked));
    }

  }

}
