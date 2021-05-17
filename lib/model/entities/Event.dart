import 'Host.dart';

class Event {
  String? category;
  String? date;
  String? description;
  String? image;
  String? imageDescription;
  bool? isOnline;
  String? link;
  String? location;
  String? title;
  Host? hostedBy;

  Event(
      {this.category,
      this.date,
      this.description,
      this.image,
      this.imageDescription,
      this.isOnline,
      this.link,
      this.location,
      this.title,
      this.hostedBy})
      : super();

  factory Event.fromJson(Map<String, dynamic> json) => Event(
      category: json["category"],
      date: json["date"],
      description: json["description"],
      image: json["image"],
      imageDescription: json["imageDescription"],
      isOnline: json["isOnline"],
      link: json["link"],
      location: json["location"],
      title: json["title"],
      hostedBy: Host.fromJson(json["hostedby"])
  );

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