abstract class CartEvents {}

//---------------------------STARTS FROM HERE-----------------------------------
class InitCheckListEvent extends CartEvents{
  final int numberOfItem;

  InitCheckListEvent({required this.numberOfItem});
}

class AddSelectedItemEvent extends CartEvents{
  final double itemPrice;
  final String itemId;

  AddSelectedItemEvent({required this.itemPrice, required this.itemId});
}

class RemoveSelectedItemEvent extends CartEvents{
  final double itemPrice;
  final String itemId;

  RemoveSelectedItemEvent({required this.itemPrice, required this.itemId});
}

class DeleteItemEvent extends CartEvents {
  final double? price;
  final String id;
  final int index;

  DeleteItemEvent({
    required this.index,
    required this.price,
    required this.id,
});
}

class DeleteFromTempList extends CartEvents {
  final int index;

  DeleteFromTempList({required this.index});
}