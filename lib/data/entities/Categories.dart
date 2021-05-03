class Categories {
  String? name;
  String? image;

  Categories({this.name, this.image}) : super();

  factory Categories.fromJson(Map<String, dynamic> json) =>
      Categories(name: json["name"], image: json["image"]);

  Map<String, dynamic> toJson() => {"name": name, "image": image};
}
