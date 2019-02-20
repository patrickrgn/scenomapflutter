

class ResultEvent {
  List<Event> events;
  ResultEvent({this.events});

  factory ResultEvent.fromJson(Map<String, List<Event>> json) => ResultEvent(events: json["Event"]);

}

class Event {
  int id;
  int idFiche;
  String idMedia;
  String startDate;
  String endDate;
  String category;
  String title;
  String article;
  String townName;
  String placeName;
  String address;
  double latitude;
  double longitude;
  String data;

  Event({
    this.id,
    this.idFiche,
    this.idMedia,
    this.startDate,
    this.endDate,
    this.category,
    this.title,
    this.article,
    this.townName,
    this.placeName,
    this.address,
    this.latitude,
    this.longitude,
    this.data,
  });

  factory Event.fromJson(Map<String, dynamic> json) => Event(
    id: json["id"],
    idFiche: json["idFiche"],
    idMedia: json["idMedia"],
    startDate: json["startDate"],
    endDate: json["endDate"],
    category: json["category"],
    title: json["title"],
    article: json["article"],
    townName: json["townName"],
    placeName: json["placeName"],
    address: json["address"],
    latitude: json["latitude"].toDouble(),
    longitude: json["longitude"].toDouble(),
    data: json["data"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "idFiche": idFiche,
    "idMedia": idMedia,
    "startDate": startDate,
    "endDate": endDate,
    "category": category,
    "title": title,
    "article": article,
    "townName": townName,
    "placeName": placeName,
    "address": address,
    "latitude": latitude,
    "longitude": longitude,
    "data": data,
  };
}