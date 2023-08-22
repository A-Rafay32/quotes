import 'package:flutter/material.dart';
import 'package:quotes/model/helper/db_user_collection.dart';

import '../../model/models.dart';

class UserCollectionViewModel extends ChangeNotifier {
  Future<List<UserCollection>>? futureUC;

  void addUserCollection(String collectionName) async {
    DBUserCollection.addUserCollection(collectionName);
    futureUC = DBUserCollection.getUserCollection();
    notifyListeners();
  }
}
