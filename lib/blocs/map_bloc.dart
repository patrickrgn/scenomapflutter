import 'dart:async';

import 'package:latlong/latlong.dart';
import 'package:rxdart/rxdart.dart';
import 'package:sceno_map_flutter/models/MapModel.dart';

class MapBloc {

  double _zoom = 0;
  final BehaviorSubject<MapModel> _mapController = BehaviorSubject();
//  final StreamController<double> _zoomController = StreamController.broadcast();
  final BehaviorSubject<double> _zoomController = BehaviorSubject();
  final BehaviorSubject<LatLng> _positionController = BehaviorSubject();
  final BehaviorSubject<Null> _moveToPositionController = BehaviorSubject();


  Stream<MapModel> get mapModel => _mapController.stream;
  Stream<double> get zoom => _zoomController.stream;
  Stream<LatLng> get position => _positionController.stream;
  Stream<Null> get toPosition => _moveToPositionController.stream;

  // MAP MODEL
  void updateMapModel(MapModel model) {
    _mapController.sink.add(model);
  }

  // ZOOM
  void updateZoom(double zoom) {
    _zoom = zoom;
    _zoomController.add(_zoom);
  }

  void zoomIn() {
    updateZoom(_zoom + 1);
  }

  void zoomOut() {
    updateZoom(_zoom - 1);
  }

  // POSITION
  void updatePosition(LatLng position) {
    _positionController.add(position);
  }

  // MOVE TO POSITION
  void moveToPosition() {
    _moveToPositionController.add(null);
  }

  void dispose() {
    _mapController.close();
    _zoomController.close();
    _positionController.close();
    _moveToPositionController.close();
  }
}

final MapBloc mapBloc = MapBloc();