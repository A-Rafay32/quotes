class Quote {
  // int id;
  String collectionName;
  String author;
  String quote;
  int isFav;

  Quote({
    // required this.id,
    required this.author,
    required this.quote,
    required this.isFav,
    required this.collectionName,
  });

  Map<String, dynamic> toMap() {
    return {
      // ' id': id,
      'collectionName': collectionName,
      'author': author,
      'isFav': isFav,
      'quote': quote,

      /*In an SQLite database, when you provide a null value when you insert a new record, the
database will automatically assign a new value, with an auto-increment logic. That's why
for the id, we are using a ternary operator: when the id is equal to 0, we change it to null,
so that SQLite will be able to set the id for us.  */
    };
  }
}

// class FavQuote {
//   int id;
//   String author;
//   String quote;

//   FavQuote({
//     required this.id,
//     required this.author,
//     required this.quote,
//   });

// }
class UserCollection {
  int id;
  String collectionName;

  UserCollection({required this.id, required this.collectionName});
}

class AuthorCollection {
  int id;
  String name;

  AuthorCollection({required this.id, required this.name});

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "name": name,
    };
  }
}

List<Quote> quotelist = [];
List<AuthorCollection> collectionList = [];
