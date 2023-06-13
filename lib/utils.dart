class Quote {
  int id;
  String collectionName;
  String author;
  String quote;
  int isFav;

  Quote({
    required this.id,
    required this.author,
    required this.quote,
    required this.isFav,
    required this.collectionName,
  });

  Map<String, dynamic> toMap() {
    return {
      ' id': id,
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

class Collection {
  int id;
  String name;

  Collection({required this.id, required this.name});

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "name": name,
    };
  }
}

List<Quote> quotelist = [
  Quote(
      id: 1,
      isFav: 0,
      collectionName: "Rene",
      author: "Rene",
      quote: "Hell is another people"),
  Quote(
      id: 2,
      isFav: 0,
      collectionName: "Carlos",
      author: "Carlos",
      quote: "Hell is me"),
  Quote(
      id: 3,
      isFav: 0,
      collectionName: "Kant",
      author: "Kant",
      quote: "Hell sex"),
  Quote(
      id: 4,
      isFav: 0,
      collectionName: "Carlos",
      author: "Carlos",
      quote: "Just Fuck it"),
];
List<Collection> collectionList = [
  Collection(id: 0, name: "Rene"),
  Collection(id: 1, name: "Carlos"),
  Collection(id: 2, name: "Kant"),
];
