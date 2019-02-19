import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
import 'package:location/location.dart';
import 'package:sceno_map_flutter/data/repository.dart';
import 'package:sceno_map_flutter/models/MapModel.dart';
import 'package:sceno_map_flutter/models/event.dart';
import 'package:sceno_map_flutter/models/model.dart';
import 'package:sceno_map_flutter/blocs/map_bloc.dart';

class MapSceno extends StatelessWidget {
  final String mapboxToken =
      'pk.eyJ1IjoicGF0cmlja3JnbiIsImEiOiJjanJxamV4MTgwMWJkNDludmVsY2M4cm9xIn0.ULxaU9Qghx40v52oHFaZcw';
  final String thunderForestToken = '9b9c7c37c5914503a5a75c65f0ecb615';

  final GlobalKey mapKey = GlobalKey();

  LatLng position = LatLng(47.4929539, -0.5512537);
  double zoom = 15.0;
  String error;

  bool _mapReady = false;

  Map<String, double> _startLocation;
  Map<String, double> _currentLocation;

  MapController _mapController = MapController();
  List<Event> _events = List();
  Repository repository = Repository.getInstance();

  final StreamController<Null> positionController = StreamController
      .broadcast();
  Marker markerPosition = Marker();

  MapSceno({Key key, this.position, this.zoom}) : super(key: key) {
    markerPosition = Marker(
        point: position,
        builder: (BuildContext context) {
          print('update Marker');
          return FlutterLogo();
        }
    );

    mapBloc.zoom.listen((newZoom) {
      print('New zoom: $zoom}');
      zoom = newZoom;
      if(_mapController.ready && _mapReady) {
        print('Move zoom :$position} - $zoom');
        _mapController.move(position, zoom);

      }
    });
    mapBloc.position.listen((newPosition) {
      position = newPosition;
      if(_mapController.ready && _mapReady) {
        print('Move position :$position} - $zoom');
//        _mapController.move(position, zoom);
        positionController.add(null);
      }
    });

    mapBloc.toPosition.listen((data) {
      _mapController.move(position, zoom);
    });

    _mapController.onReady.then((value) {
      print('MapController is ready');
      _mapReady = true;
      _mapController.move(position, zoom);
    });
  }


  @override
  Widget build(BuildContext context) {
    print('build map');
    return StreamBuilder(
        stream: mapBloc.mapModel,
        initialData: MapModel(provider: TypeProviderMap.osm),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          print('buildMap');
          return FlutterMap(
            key: mapKey,
            mapController: _mapController,
            options: MapOptions(
                center: LatLng(position.latitude, position.longitude),
                zoom: zoom,
                debug: true,
                plugins: [

                ]),
            layers: [
              _getTileLayer(snapshot.data),
              MarkerLayerOptions(
                rebuild: positionController.stream,
                markers: getMarkers(),
              ),
            ],
          );
        });
  }

  List<Marker> getMarkers() {
    final Marker marker = Marker(
        point: position,
        builder: (BuildContext context) {
          print('update Marker');
          return FlutterLogo();
        }
    );
    return [marker];
  }

  TileLayerOptions _getTileLayer(MapModel map) {
    switch (map.provider) {
      case TypeProviderMap.mapbox:
        return _getMapboxTileLayer(map.style);
        break;
      case TypeProviderMap.thunderForest:
        return _getThunderForestTileLayer(map.style);
        break;
      default:
        return _getOSMTileLayer();
        break;
    }
  }

//  Widget _buildPosition() {
//    return StreamBuilder(
//      stream: mapBloc.position,
//      builder: (BuildContext context, AsyncSnapshot<LatLng> snapshot) {
//        _mapController.move(snapshot.data, _mapController.zoom);
//        return Marker(
//
//        );
//      },
//
//    );
//  }

  TileLayerOptions _getMapboxTileLayer(String style) =>
      TileLayerOptions(
          urlTemplate:
          "https://api.tiles.mapbox.com/v4/{id}/{z}/{x}/{y}@2x.png?access_token={accessToken}",
          additionalOptions: {
            'accessToken': mapboxToken,
            'id': style,
          },
          keepBuffer: 50);

  TileLayerOptions _getOSMTileLayer() =>
      TileLayerOptions(
        urlTemplate: "https://{s}.tile.openstreetmap.fr/osmfr/{z}/{x}/{y}.png",
        subdomains: ['a', 'b', 'c'],
        keepBuffer: 50,
      );

  TileLayerOptions _getThunderForestTileLayer(String style) =>
      TileLayerOptions(
        urlTemplate:
        "https://tile.thunderforest.com/{id}/{z}/{x}/{y}.png?apikey={accessToken}",
        additionalOptions: {
          'accessToken': thunderForestToken,
          'id': style,
        },
        keepBuffer: 50,
      );
}
