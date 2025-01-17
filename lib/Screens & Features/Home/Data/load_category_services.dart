// Package imports:
import 'package:cloud_firestore/cloud_firestore.dart';

// Project imports:
import '../../../Core/Utils/global_variables.dart';

Future<Map<dynamic, List<dynamic>>> loadCategory() async {

  if (categories.isEmpty) {
    await FirebaseFirestore
        .instance
        .collection('/Category')
        .doc('/Drawer')
        .get()
        .then((value) { // value is the snapshot of the document '/Drawer'

      int length = value.data()!.keys.length; // length of the categories

      for (int i = 0; i < length; i++) {
        //value.data() is the total value of the documents in '/Drawer'
        //value.data()!.keys.elementAt(i) is the each category

        //category (value.data()!) and its values 'subCategory' (.values) of each category (.elementAt(i))
        //= load subcategories
        for (int j = 0; j < value.data()!.values.elementAt(i).length; j++) {
          categories[value.data()!.keys.elementAt(i)] = value.data()!.values.elementAt(i);
        }
      }

    });
  }
  return categories;
}
