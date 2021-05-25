import 'package:flutter_meetup/view/customwidgets/DropDownFormField.dart';

class Location extends DropDownItem {

  String? name = "";

  Location({this.name}) : super();

  factory Location.fromJson(Map<String, dynamic> json) =>
      Location(name: json["name"]);

  Map<String, dynamic> toJson() => {"name": name};

}