import '../../Cart/Bloc/cart_states.dart';

abstract class CheckOutEvents {}

class TransferDataEvent extends CheckOutEvents {
  final CartState cartState;

  TransferDataEvent(this.cartState);
}

class LoadUserDataEvent extends CheckOutEvents {
  final String uid;

  LoadUserDataEvent({required this.uid});
}

class ChangeUserInfoEvent extends CheckOutEvents {
  final String name;
  final String phoneNumber;
  final String address;

  ChangeUserInfoEvent({required this.name, required this.phoneNumber, required this.address});
}
class ChangeDivisionEvent extends CheckOutEvents {
  final String selectedDivision;

  ChangeDivisionEvent({required this.selectedDivision});
}

class IsPromoCodeFound extends CheckOutEvents {
  final bool isPromoCodeFound;
  final double promoDiscountAmount;

  IsPromoCodeFound({required this.isPromoCodeFound, required this.promoDiscountAmount});
}


class UpdateIsUsingCoinEvent extends CheckOutEvents {
  final bool isUsingCoin;

  UpdateIsUsingCoinEvent({required this.isUsingCoin});
}

class UpdateIsLoading extends CheckOutEvents {
  final bool isLoading;

  UpdateIsLoading({required this.isLoading});
}


class UpdateTotal extends CheckOutEvents {
  final double total;

  UpdateTotal({required this.total});
}

class ResetCheckoutEvent extends CheckOutEvents {}