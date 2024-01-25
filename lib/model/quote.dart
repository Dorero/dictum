import 'package:dictum/model/author.dart';

class Quote {
  final String id;
  final String text;
  final Author author;

  Quote({required this.id, required this.text, required this.author});

  factory Quote.fromJson(Map<String, dynamic> json) {
    return Quote(
        id: json["id"],
        text: json["text"],
        author: Author.fromJson(json["author"]));
  }

  factory Quote.fromString(String quoteString) {
    final data = quoteString.split(" -> ");
    final quote = data.first.split(" : ");
    final author = data.last.split(" : ");

    return Quote(id: quote.first, text: quote.last, author: Author(id: author.first, name: author.last));
  }


  @override
  String toString() {
    return "$id : $text -> ${author.id} : ${author.name}";
  }
}
