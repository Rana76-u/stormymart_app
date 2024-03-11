abstract class CartEvents {}

class AddItemEvent extends CartEvents {
  String id;
  double price;
  String size;
  String variant;
  int quantity;

  AddItemEvent({
    required this.id,
    required this.price,
    required this.size,
    required this.variant,
    required this.quantity
  });
}

class UpdateCheckList extends CartEvents {
  final int index;
  final bool isChecked;

  UpdateCheckList({
    required this.index,
    required this.isChecked,
  });
}

class DeleteItemEvent extends CartEvents {
  final int index;

  DeleteItemEvent({
    required this.index,
});
}

class SelectAllCheckList extends CartEvents {
  final bool isSelectAll;

  SelectAllCheckList({required this.isSelectAll});
}
