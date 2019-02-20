import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
import 'package:sceno_map_flutter/blocs/map_bloc.dart';
import 'package:sceno_map_flutter/data/repository.dart';
import 'package:sceno_map_flutter/models/event.dart';
import 'package:sceno_map_flutter/models/map_model.dart';
import 'package:sceno_map_flutter/models/model.dart';
import 'package:sceno_map_flutter/widgets/event_icon.dart';

class MapSceno extends StatefulWidget {
  final String mapboxToken =
      'pk.eyJ1IjoicGF0cmlja3JnbiIsImEiOiJjanJxamV4MTgwMWJkNDludmVsY2M4cm9xIn0.ULxaU9Qghx40v52oHFaZcw';
  final String thunderForestToken = '9b9c7c37c5914503a5a75c65f0ecb615';

  final GlobalKey mapKey = GlobalKey();

  String error;


  Repository repository = Repository.getInstance();

  LatLng defaultPosition;
  double defaultZoom;
  MapPosition mapPosition;

  MapSceno(
      {Key key, @required this.defaultPosition, @required this.defaultZoom})
      : super(key: key) {
  }

  @override
  State<StatefulWidget> createState() {
    return _MapScenoState();
  }
}

class _MapScenoState extends State<MapSceno> {
  MapModel _mapModel = MapModel(provider: TypeProviderMap.osm);
  Marker _markerPosition;
  MapController _mapController = MapController();
  List<Event> _events = [];

  @override
  void initState() {
    mapBloc.mapModel.listen((mapModel) {
      setState(() {
        _mapModel = mapModel;
        _markerPosition = Marker(
            point: _mapModel.position,
            builder: (BuildContext context) {
              return Icon(Icons.location_on, color: Colors.red, size: 30,);
            });
      });
    });

    mapBloc.toPosition.listen((position) {
      double zoom = _mapController.zoom != null ? _mapController.zoom : widget.defaultZoom;
      _mapController.move(_mapModel.position, zoom);
    });

    mapBloc.allEvents.listen((events) {
      setState(() {
        print('update events');
        _events = events;
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print('MapSceno build ${_mapModel.position}');


    return FlutterMap(
      mapController: _mapController,
      options: MapOptions(
          onPositionChanged: (MapPosition position, bool hasGesture) {
            widget.mapPosition = position;
          },
          center: widget.mapPosition != null
              ? widget.mapPosition.center
              : widget.defaultPosition,
          zoom: widget.mapPosition != null
              ? widget.mapPosition.zoom
              : widget.defaultZoom,
          debug: true,
          interactive: true,
          plugins: []),
      layers: [
        _getTileLayer(),
        MarkerLayerOptions(
          markers: _getListMarkers(),
        ),
      ],
    );
  }

  List<Marker> _getListMarkers() {
    List<Marker> list = List();
    if(_markerPosition != null) {
      list.add(_markerPosition);
    }
    list.addAll(_buildMarkersEvents());

    return list;
  }

  List<Marker> _buildMarkersEvents() {
    print('buildMarkers ${_events.length}');
    List<Marker> list = List();

    _events.forEach((event) {
      list.add(Marker(
        width: 35.0,
        height: 35.0,
        point: LatLng(event.latitude, event.longitude),
        anchorPos: AnchorPos.align(AnchorAlign.top),
        builder: (ctx) => Container(
          child: EventIcon(event: event),
        ),
      ));
    });

    return list;
  }

  TileLayerOptions _getTileLayer() {
    switch (_mapModel.provider) {
      case TypeProviderMap.mapbox:
        return _getMapboxTileLayer(_mapModel.style);
        break;
      case TypeProviderMap.thunderForest:
        return _getThunderForestTileLayer(_mapModel.style);
        break;
      default:
        return _getOSMTileLayer();
        break;
    }
  }

  TileLayerOptions _getMapboxTileLayer(String style) => TileLayerOptions(
      urlTemplate:
          "https://api.tiles.mapbox.com/v4/{id}/{z}/{x}/{y}@2x.png?access_token={accessToken}",
      additionalOptions: {
        'accessToken': widget.mapboxToken,
        'id': style,
      },
      keepBuffer: 50);

  TileLayerOptions _getOSMTileLayer() => TileLayerOptions(
        urlTemplate: "https://{s}.tile.openstreetmap.fr/osmfr/{z}/{x}/{y}.png",
        subdomains: ['a', 'b', 'c'],
        keepBuffer: 50,
      );

  TileLayerOptions _getThunderForestTileLayer(String style) => TileLayerOptions(
        urlTemplate:
            "https://tile.thunderforest.com/{id}/{z}/{x}/{y}.png?apikey={accessToken}",
        additionalOptions: {
          'accessToken': widget.thunderForestToken,
          'id': style,
        },
        keepBuffer: 50,
      );
}
