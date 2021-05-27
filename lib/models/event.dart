class Event {
  String? title;
  String? category;
  String? date;
  String? description;
  String? image;
  bool? isOnline;
  String? link;
  String? location;

  Event({
    this.title,
    this.category,
    this.date,
    this.description,
    this.image,
    this.isOnline,
    this.link,
    this.location
  }) : super();

  factory Event.fromJson(Map<String, dynamic> json) => Event(
      category: json["category"],
      date: json["date"],
      description: json["description"],
      image: json["image"],
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
        "isOnline": isOnline,
        "link": link,
        "location": location,
        "title": title
      };
}
