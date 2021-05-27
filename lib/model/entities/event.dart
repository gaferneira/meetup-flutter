class Event {
  String? title;
  String? category;
  String? date;
  String? description;
  String? image;
  String? imageDescription;
  bool? isOnline;
  String? link;
  String? location;

  Event({
    this.title,
    this.category,
    this.date,
    this.description,
    this.image,
    this.imageDescription,
    this.isOnline,
    this.link,
    this.location
  }) : super();

  factory Event.fromJson(Map<String, dynamic> json) => Event(
      category: json["category"],
      date: json["date"],
      description: json["description"],
      image: json["image"],
      imageDescription: json["imageDescription"],
      isOnline: json["isOnline"],
      link: json["link"],
      location: json["location"],
      title: json["title"]
  );

  Map<String, dynamic> toJson() => {
        "category": category,
        "date": date,
        "description": description,
        "image": image,
        "imageDescription": imageDescription,
        "isOnline": isOnline,
        "link": link,
        "location": location,
        "title": title
      };
}
