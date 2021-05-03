class Book {
  String? id;
  final String? name;
  final String? author;
  final String? coverUrl;

  bool selected = false;

  Book({this.name, this.author, this.coverUrl}) : super();

  factory Book.fromJson(Map<String, dynamic> json) => Book(
        name: json["name"],
        author: json["author"],
        coverUrl: json["coverUrl"],
      );

  Map<String, dynamic> toJson() =>
      {"name": name, "author": author, "coverUrl": coverUrl};
}
