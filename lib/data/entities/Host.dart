class Host {
  String? position;
  String? name;

  Host({this.position, this.name}) : super();

  factory Host.fromJson(Map<String, dynamic> json) =>
      Host(position: json["position"], name: json["name"]);

  Map<String, dynamic> toJson() => {"position": position, "name": name};
}
