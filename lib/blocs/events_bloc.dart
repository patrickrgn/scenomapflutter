

import 'package:rxdart/rxdart.dart';
import 'package:sceno_map_flutter/blocs/sceno_bloc.dart';
import 'package:sceno_map_flutter/data/repository.dart';
import 'package:sceno_map_flutter/models/event.dart';

class EventsBloc extends ScenoBloc {

  final _repository = Repository();
  final _eventsFetcher = BehaviorSubject<List<Event>>();


  Stream<List<Event>> get allEvents => _eventsFetcher.stream;

  void fetchAllEvents(DateTime startDate, DateTime endDate, double latitude, double longitute) async {
    List<Event> events = await _repository.updateEvents(startDate, endDate, latitude, longitute);
    _eventsFetcher.sink.add(events);
  }

  @override
  void dispose() {
    _eventsFetcher.close();
  }

}

final eventsBloc = EventsBloc();