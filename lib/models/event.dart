class Event {
  String? title;
  String? category;
  String? date;
  String? time;
  String? description;
  String? image;
  String? link;
  String? location;

  Event({
    this.title,
    this.category,
    this.date,
    this.time,
    this.description,
    this.image,
    this.link,
    this.location
  }) : super();

  factory Event.fromJson(Map<String, dynamic> json) => Event(
      category: json["category"],
      date: json["date"],
      time: json["time"],
      description: json["description"],
      image: json["image"],
      link: json["link"],
      location: json["location"],
      title: json["title"]
  );

  Map<String, dynamic> toJson() => {
        "category": category,
        "date": date,
        "time": time,
        "description": description,
        "image": image,
        "link": link,
        "location": location,
        "title": title
      };
}
