import '../Cart Bloc/cart_states.dart';

abstract class CheckOutEvents {}

class TransferDataEvent extends CheckOutEvents {
  final CartState cartState;

  TransferDataEvent(this.cartState);
}

class LoadUserDataEvent extends CheckOutEvents {
  final String uid;

  LoadUserDataEvent({required this.uid});
}

class ChangeDivisionEvent extends CheckOutEvents {
  final String selectedDivision;

  ChangeDivisionEvent({required this.selectedDivision});
}