import 'dart:async';

import 'package:flutter/material.dart';
import 'package:latlong/latlong.dart';
import 'package:rxdart/rxdart.dart';
import 'package:sceno_map_flutter/blocs/sceno_bloc.dart';
import 'package:sceno_map_flutter/data/repository.dart';
import 'package:sceno_map_flutter/models/event.dart';
import 'package:sceno_map_flutter/models/map_model.dart';
import 'package:sceno_map_flutter/models/model.dart';

class MapBloc extends ScenoBloc {

  final _repository = Repository();

  MapModel _mapModel = MapModel(provider: TypeProviderMap.osm);
  LatLng _position;

  final BehaviorSubject<MapModel> _mapController = BehaviorSubject();
  final BehaviorSubject<LatLng> _positionController = BehaviorSubject();
  final BehaviorSubject<Null> _moveToPositionController = BehaviorSubject();
  final BehaviorSubject<List<Event>> _eventsFetcher = BehaviorSubject();

  Stream<MapModel> get mapModel => _mapController.stream;
  Stream<LatLng> get position => _positionController.stream;
  Stream<Null> get toPosition => _moveToPositionController.stream;
  Stream<List<Event>> get allEvents => _eventsFetcher.stream;

  // MAP MODEL
  void updateMapModel({@required TypeProviderMap provider, String style}) {
    if(_mapModel.provider != provider || _mapModel.style != style) {
      _mapModel.provider = provider;
      _mapModel.style = style;
      _mapController.sink.add(_mapModel);
    }

  }

  // POSITION
  void updatePosition(LatLng position) {
    print('updatePosition : $position');
    if(_mapModel != null || _mapModel.position == null || _mapModel.position != position ) {
      _mapModel.position = position;
      _mapController.sink.add(_mapModel);
    }
    if(_position == null || _position != position) {
      _position = position;
      _positionController.sink.add(position);
    }
  }

  // MOVE TO POSITION
  void moveToPosition() {
    _moveToPositionController.add(null);
  }

  // EVENTS
  void fetchAllEvents() async {
    var now = DateTime.now();
    var after = now.add(Duration(hours: 24));
    List<Event> events = await _repository.updateEvents(now, after, _position.latitude, _position.longitude);
    _eventsFetcher.sink.add(events);
  }

  @override
  void dispose() {
    _mapController.close();
    _positionController.close();
    _moveToPositionController.close();
    _eventsFetcher.close();
  }
}

final MapBloc mapBloc = MapBloc();