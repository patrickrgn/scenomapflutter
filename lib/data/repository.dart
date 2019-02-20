import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:sceno_map_flutter/models/event.dart';

class Repository {

  Repository();

  factory Repository.getInstance() {
    return Repository();
  }

  Future<List<Event>> updateEvents(DateTime startDate, DateTime endDate, double latitude, double longitute) async {
    var formatDate = DateFormat("yyyy-MM-dd HH:mm:ss");
    var queryParameters = {
      'startDate': formatDate.format(startDate),
      'endDate': formatDate.format(endDate),
      'latitude': latitude.toString(),
      'longitude': longitute.toString()
    };

    var uri = Uri.https('prod.app.sceno.fr', 'Sceno/rs/webservice/getEvents', queryParameters);
    final client = Client();
    final response = await client.get(uri);

    Map<String, dynamic> eventsJSON = jsonDecode(response.body.toString());
    List<Event> events = List<Event>();
    for (var eventJSON in eventsJSON["Event"]) {
      var event = Event.fromJson(eventJSON);
      events.add(event);
      print('${event.id} [${event.latitude}, ${event.longitude}] - ${event.category}');
    }

    return events;
  }

}