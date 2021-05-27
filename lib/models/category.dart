import 'package:flutter_meetup/models/drop_down_item.dart';

class Category extends DropDownItem {
  String? name;
  String? image;

  Category({this.name, this.image}) : super();

  factory Category.fromJson(Map<String, dynamic> json) =>
      Category(name: json["name"], image: json["image"]);

  Map<String, dynamic> toJson() => {"name": name, "image": image};
}
