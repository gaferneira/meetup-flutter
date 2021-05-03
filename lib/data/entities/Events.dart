import 'Host.dart';

class Events {
  String? category;
  String? date;
  String? description;
  String? imageDescription;
  bool? isOnline;
  String? link;
  String? location;
  String? title;
  Host? hostedBy;

  Events(
      {this.category,
      this.date,
      this.description,
      this.imageDescription,
      this.isOnline,
      this.link,
      this.location,
      this.title,
      this.hostedBy})
      : super();

  factory Events.fromJson(Map<String, dynamic> json) => Events(
      category: json["category"],
      date: json["date"],
      description: json["description"],
      imageDescription: json["imageDescription"],
      isOnline: json["isOnline"],
      link: json["link"],
      location: json["location"],
      title: json["title"],
      hostedBy: json["hostedby"]);

  Map<String, dynamic> toJson() => {
        "category": category,
        "date": date,
        "description": description,
        "imageDescription": imageDescription,
        "isOnline": isOnline,
        "link": link,
        "location": location,
        "title": title,
        "hostedby": hostedBy
      };
}
