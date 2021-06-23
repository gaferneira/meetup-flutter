import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class Event {
  String? documentId;
  String? title;
  String? category;
  String? description;
  String? image;
  String? link;
  String? location;
  String? owner;
  Timestamp? when;
  List<String>? participants;
  List<String>? saved;
  bool isOwner = false;
  bool isFavorite = false;
  bool isSubscribed = false;

  Event({
    this.documentId,
    this.title,
    this.category,
    this.owner,
    this.description,
    this.image,
    this.when,
    this.link,
    this.isOwner = false,
    this.location,
    this.participants,
    this.saved,
    this.isFavorite = false,
    this.isSubscribed = false
  }) : super();

  factory Event.fromJson(String id, Map<String, dynamic> json, User? user) => Event(
      documentId: id,
      category: json["category"],
      description: json["description"],
      image: json["image"],
      link: json["link"],
      location: json["location"],
      title: json["title"],
      owner: json["owner"],
      when: json["when"],
      participants : List.castFrom(json['participants'] ?? []),
      saved : List.castFrom(json['saved'] ?? []),
      isOwner: json["owner"] == user?.email,
      isFavorite: List.castFrom(json['saved'] ?? []).contains(user?.email),
      isSubscribed: List.castFrom(json['participants'] ?? []).contains(user?.email)
  );

  Map<String, dynamic> toJson() => {
        "category": category,
        "when": when,
        "description": description,
        "image": image,
        "link": link,
        "location": location,
        "title": title,
        "owner" : owner,
        "participants" :List.from(participants ?? []),
        "saved" :List.from(saved ?? [])
      };

  String get date {
    if (when != null) {
      return DateFormat('yyyy-MM-dd').format(when!.toDate());
    } else {
      return "";
    }
  }

  String get time {
    if (when != null) {
      return DateFormat('kk:mm').format(when!.toDate());
    } else {
      return "";
    }
  }
}
