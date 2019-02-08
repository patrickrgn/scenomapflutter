import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
import 'package:location/location.dart';
import 'package:sceno_map_flutter/model.dart';

class ScenoMap extends StatefulWidget {
  ScenoMap({Key key, this.title}) : super(key: key);

  final String mapboxToken =
      'pk.eyJ1IjoicGF0cmlja3JnbiIsImEiOiJjanJxamV4MTgwMWJkNDludmVsY2M4cm9xIn0.ULxaU9Qghx40v52oHFaZcw';
  final String thunderForestToken = '9b9c7c37c5914503a5a75c65f0ecb615';
  final String title;

  @override
  _ScenoMapState createState() => _ScenoMapState();
}

class _ScenoMapState extends State<ScenoMap> {
  GlobalKey _flutterMapKey = new GlobalKey();

  Map<String, double> _startLocation;
  Map<String, double> _currentLocation;

  StreamSubscription<Map<String, double>> _locationSubscription;

  Location _location = new Location();
  bool _permission = false;
  String error;

  TypeProviderMap _providerMap;
  String _styleThunderForest;
  String _styleMapbox;

  MapController _mapController;
  double _zoom;

  @override
  void initState() {
    super.initState();

    initPlatformState();
    _zoom = 15;
    _mapController = MapController();
    _providerMap = TypeProviderMap.osm;
    _styleThunderForest = StyleThunderForest.TRANSPORT;
    _styleMapbox = StyleMapbox.STREETS;
    _currentLocation = {"latitude": 47.4929539, "longitude": -0.5512537};
    _locationSubscription =
        _location.onLocationChanged().listen((Map<String, double> result) {
      if (result != null) {
        print(
            "latitude: ${result["latitude"]} - longitude: ${result["longitude"]}");
        setState(() {
          _currentLocation = result;
          _mapController.move(
              LatLng(
                  _currentLocation["latitude"], _currentLocation["longitude"]),
              _mapController.zoom);
        });
      } else {
        print("result null");
      }
    });
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  initPlatformState() async {
    Map<String, double> location;
    // Platform messages may fail, so we use a try/catch PlatformException.

    try {
      _permission = await _location.hasPermission();
      location = await _location.getLocation();

      error = null;
    } on PlatformException catch (e) {
      if (e.code == 'PERMISSION_DENIED') {
        error = 'Permission denied';
      } else if (e.code == 'PERMISSION_DENIED_NEVER_ASK') {
        error =
            'Permission denied - please ask the user to enable it from the app settings';
      }

      location = null;
    }

    setState(() {
      _startLocation = location;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Padding(
          padding: EdgeInsets.all(0),
          child: Column(
            children: <Widget>[
              Flexible(
                child: _buildMap(context),
              ),
              Column(
                children: <Widget>[
                  _buildControl(),
                  _buildProviderMap(),
                  _buildStyle()
                ],
              )
            ],
          ),
        ));
  }

  Widget _buildMap(BuildContext context) {
    return FlutterMap(
      key: _flutterMapKey,
      mapController: _mapController,
      options: MapOptions(
          center: LatLng(
              _currentLocation["latitude"], _currentLocation["longitude"]),
          zoom: _zoom,
          debug: true),
      layers: [
        _getTileLayer(),
        MarkerLayerOptions(
          markers: [
            Marker(
              width: 30.0,
              height: 30.0,
              point: LatLng(
                  _currentLocation["latitude"], _currentLocation["longitude"]),
              builder: (ctx) => Container(
                    child: Icon(
                      Icons.location_on,
                      color: Colors.red,
                    ),
                  ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildControl() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        SizedBox(
          width: 50,
          child: IconButton(
              icon: Icon(Icons.my_location),
              color: Colors.red,
              padding: EdgeInsets.all(0),
              onPressed: () {
                _mapController.move(
                    LatLng(_currentLocation["latitude"],
                        _currentLocation["longitude"]),
                    _mapController.zoom);
              }),
        ),
        Container(
          margin: EdgeInsets.only(left: 5.0, right: 5.0),
          child: Row(
            children: <Widget>[
              SizedBox(
                width: 50,
                child: IconButton(
                    icon: Icon(Icons.zoom_out),
                    color: Colors.grey,
                    padding: EdgeInsets.all(0),
                    onPressed: () {
                      setState(() {
                        _zoom--;
                        _mapController.move(_mapController.center, _zoom);
                      });
                    }),
              ),
              SizedBox(
                width: 50,
                child: IconButton(
                    icon: Icon(Icons.zoom_in),
                    color: Colors.grey,
                    padding: EdgeInsets.all(0),
                    onPressed: () {
                      setState(() {
                        _zoom++;
                        _mapController.move(_mapController.center, _zoom);
                      });
                    }),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildProviderMap() {
    return Row(
      children: <Widget>[
        _buildProviderMapButton("OSM", TypeProviderMap.osm),
        _buildProviderMapButton("Mapbox", TypeProviderMap.mapbox),
        _buildProviderMapButton("ThunderForest", TypeProviderMap.thunderForest)
      ],
    );
  }

  Widget _buildProviderMapButton(String title, TypeProviderMap type) =>
      RaisedButton(
          child: Text(title),
          color: _providerMap == type ? Colors.green : Colors.white,
          textColor: _providerMap == type ? Colors.white : Colors.green,
          padding: EdgeInsets.all(0),
          elevation: _providerMap == type ? 0 : 3,
          onPressed: () {
            setState(() {
              _providerMap = type;
            });
          });

  Widget _buildStyle() {
    switch (_providerMap) {
      case TypeProviderMap.osm:
        return _buildStyleOSM();
        break;

      case TypeProviderMap.mapbox:
        return _buildStyleMapbox();
        break;

      case TypeProviderMap.thunderForest:
        return _buildStyleThunderForest();
        break;
    }
  }

  Widget _buildStyleOSM() {
    return Container();
  }

  Widget _buildStyleMapbox() {
    return Row(
      children: <Widget>[
        _buildStyleButton(
            title: "Streets",
            style: StyleMapbox.STREETS,
            active: _styleMapbox == StyleMapbox.STREETS,
            onPressed: this._updateStyleMapbox),
        _buildStyleButton(
            title: "Satellite",
            style: StyleMapbox.SATELLITE,
            active: _styleMapbox == StyleMapbox.SATELLITE,
            onPressed: this._updateStyleMapbox),
      ],
    );
  }

  Widget _buildStyleThunderForest() {
    return Row(
      children: <Widget>[
        _buildStyleButton(
            title: "Transport",
            style: StyleThunderForest.TRANSPORT,
            active: _styleThunderForest == StyleThunderForest.TRANSPORT,
            onPressed: this._updateStyleThunderForest),
        _buildStyleButton(
            title: "Neighbourhood",
            style: StyleThunderForest.NEIGHBOURHOOD,
            active: _styleThunderForest == StyleThunderForest.NEIGHBOURHOOD,
            onPressed: this._updateStyleThunderForest),
        _buildStyleButton(
            title: "Cycle",
            style: StyleThunderForest.CYCLE,
            active: _styleThunderForest == StyleThunderForest.CYCLE,
            onPressed: this._updateStyleThunderForest),
      ],
    );
  }

  Widget _buildStyleButton(
          {String title, String style, bool active, StyleCallback onPressed}) =>
      RaisedButton(
          child: Text(title),
          color: active ? Colors.blue : Colors.white,
          textColor: active ? Colors.white : Colors.blue,
          padding: EdgeInsets.all(0),
          elevation: active ? 0 : 3,
          onPressed: () => onPressed(style));

  void _updateStyleThunderForest(String style) {
    setState(() {
      _styleThunderForest = style;
    });
  }

  void _updateStyleMapbox(String style) {
    setState(() {
      _styleMapbox = style;
    });
  }

  TileLayerOptions _getTileLayer() {
    switch (_providerMap) {
      case TypeProviderMap.osm:
        return _getOSMTileLayer();
        break;
      case TypeProviderMap.mapbox:
        return _getMapboxTileLayer();
        break;
      case TypeProviderMap.thunderForest:
        return _getThunderForestTileLayer();
        break;
    }
  }

  TileLayerOptions _getMapboxTileLayer() => TileLayerOptions(
      urlTemplate:
          "https://api.tiles.mapbox.com/v4/{id}/{z}/{x}/{y}@2x.png?access_token={accessToken}",
      additionalOptions: {
        'accessToken': widget.mapboxToken,
        'id': _styleMapbox,
      },
      keepBuffer: 50);

  TileLayerOptions _getOSMTileLayer() => TileLayerOptions(
        urlTemplate: "https://{s}.tile.openstreetmap.fr/osmfr/{z}/{x}/{y}.png",
        subdomains: ['a', 'b', 'c'],
        keepBuffer: 50,
      );

  TileLayerOptions _getThunderForestTileLayer() => TileLayerOptions(
        urlTemplate:
            "https://tile.thunderforest.com/{id}/{z}/{x}/{y}.png?apikey={accessToken}",
        additionalOptions: {
          'accessToken': widget.thunderForestToken,
          'id': _styleThunderForest,
        },
        keepBuffer: 50,
      );
}
