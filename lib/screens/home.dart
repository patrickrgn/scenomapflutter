import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
import 'package:location/location.dart';
import 'package:sceno_map_flutter/blocs/map_bloc.dart';
import 'package:sceno_map_flutter/data/repository.dart';
import 'package:sceno_map_flutter/models/MapModel.dart';
import 'package:sceno_map_flutter/models/event.dart';
import 'package:sceno_map_flutter/models/model.dart';
import 'package:sceno_map_flutter/widgets/event_icon.dart';
import 'package:sceno_map_flutter/widgets/map_controls.dart';
import 'package:sceno_map_flutter/widgets/map_infos.dart';
import 'package:sceno_map_flutter/widgets/map_providers.dart';
import 'package:sceno_map_flutter/widgets/map_sceno.dart';
import 'package:sceno_map_flutter/widgets/map_styles.dart';

class Home extends StatefulWidget {
  final String mapboxToken =
      'pk.eyJ1IjoicGF0cmlja3JnbiIsImEiOiJjanJxamV4MTgwMWJkNDludmVsY2M4cm9xIn0.ULxaU9Qghx40v52oHFaZcw';
  final String thunderForestToken = '9b9c7c37c5914503a5a75c65f0ecb615';
  final String apiEvents =
      'https://prod.app.sceno.fr/Sceno/rs/webservice/getEvents?startDate=2019-02-08 18:00:00&endDate=2019-02-08 20:00:00&latitude=47.469559&longitude=-0.550723';
  final MapModel _defaultMapModel = MapModel(provider: TypeProviderMap.osm);
  final double _defaultZoom = 15.0;

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Map<String, double> _startLocation;
  Map<String, double> _currentLocation;

  Location _location = Location();
  bool _permission = false;
  String error;

  List<Event> _events = List();
  Repository repository = Repository.getInstance();

  @override
  void initState() {
    super.initState();

    mapBloc.updateZoom(widget._defaultZoom);
    mapBloc.updateMapModel(widget._defaultMapModel);

    _initPlatformState();
    _currentLocation = {"latitude": 47.4929539, "longitude": -0.5512537};
    _location.onLocationChanged().listen((Map<String, double> result) {
      if (result != null) {
        print("latitude: ${result["latitude"]} - longitude: ${result["longitude"]}");
        mapBloc.updatePosition(LatLng(result["latitude"], result["longitude"]));
      } else {
        print("result null");
      }
    });

    repository.getEvents().listen((events) {
      setState(() {
        _events = events;
      });
    });
    _updateDataEvents();
  }



  _updateDataEvents() {
    var now = DateTime.now();
    var after = now.add(Duration(hours: 24));
    repository.updateEvents(now, after, _currentLocation["latitude"],
        _currentLocation["longitude"]);
  }

  _initPlatformState() async {
    Map<String, double> location;

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
  void dispose() {
    mapBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        appBar: AppBar(
          title: Text('Sceno - Map'),
        ),
        body: Padding(
          padding: EdgeInsets.all(0),
          child: Column(
            children: <Widget>[
              Flexible(
                child: Stack(
                  children: <Widget>[
                    MapSceno(position: LatLng(47.4929539, -0.5512537), zoom: 15.0,),
                    Positioned(
                      right: 0,
                     top: 0,
                     child: MapControls(),
                    ),
                    Positioned(
                      bottom: 0,
                      child: MapInfos(),
                    )
                  ],
                ),
              ),
              Column(
                children: <Widget>[MapProviders(), MapStyles()],
              )
            ],
          ),
        ));
  }

  List<Marker> _buildMarkers() {
    print('buildMarkers ${_events.length}');
    List<Marker> list = List();

    list.add(Marker(
      width: 30.0,
      height: 30.0,
      point:
          LatLng(_currentLocation["latitude"], _currentLocation["longitude"]),
      builder: (ctx) => Container(
            child: Icon(
              Icons.my_location,
              color: Colors.red,
              size: 35,
            ),
          ),
    ));

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
}
