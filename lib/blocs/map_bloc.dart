import 'dart:async';

import 'package:latlong/latlong.dart';
import 'package:sceno_map_flutter/models/MapModel.dart';
import 'package:sceno_map_flutter/models/model.dart';

class MapBloc {

  double _zoom = 0;
  final StreamController<MapModel> _mapController = StreamController.broadcast();
  final StreamController<double> _zoomController = StreamController.broadcast();
  final StreamController<LatLng> _positionController = StreamController.broadcast();

  Stream<MapModel> get mapModel => _mapController.stream;
  Stream<double> get zoom => _zoomController.stream;
  Stream<LatLng> get position => _positionController.stream;

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

  void dispose() {
    _mapController.close();
    _zoomController.close();
    _positionController.close();
  }
}

final MapBloc mapBloc = MapBloc();