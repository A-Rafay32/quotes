import 'package:flutter/material.dart';
import 'package:quotes/model/helper/db_author_collection.dart';

import '../../model/models.dart';

class AuthorCollectionViewModel extends ChangeNotifier {
  Future<List<Quote>>? futureA;
  Future<List<AuthorCollection>>? futureC;

  void delAuthorCollection(String authorName) {
    DBAuthorCollection.delAuthorCollection(authorName);
    notifyListeners();
  }
}
