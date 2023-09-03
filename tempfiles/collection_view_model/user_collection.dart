import 'package:flutter/material.dart';
import 'package:quotes/model/data/db_user_collection.dart';

import '../../lib/model/models.dart';

class UserCollectionViewModel extends ChangeNotifier {
  Future<List<UserCollection>>? futureUC;

  void addUserCollection(String collectionName) async {
    DBUserCollection.addUserCollection(collectionName);
    futureUC = DBUserCollection.getUserCollection();
    notifyListeners();
  }
}
