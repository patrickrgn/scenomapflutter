import 'package:flutter/material.dart';
import 'package:latlong/latlong.dart';
import 'package:sceno_map_flutter/blocs/map_bloc.dart';


class MapControl extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _buildControl();
  }

  Widget _buildControl() {
    print("buildControl");
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

//                _mapController.move(
//                    LatLng(_currentLocation["latitude"], _currentLocation["longitude"]), _mapController.zoom);
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
                    color: Colors.black,
                    padding: EdgeInsets.all(0),
                    onPressed: () {
                      mapBloc.zoomOut();
//                      setState(() {
//                        _zoom--;
//                        _mapController.move(_mapController.center, _zoom);
//                      });
                    }),
              ),
              SizedBox(
                width: 50,
                child: IconButton(
                    icon: Icon(Icons.zoom_in),
                    color: Colors.black,
                    padding: EdgeInsets.all(0),
                    onPressed: () {
                      mapBloc.zoomIn();
//                      setState(() {
//                        _zoom++;
//                        _mapController.move(_mapController.center, _zoom);
//                      });
                    }),
              ),
            ],
          ),
        ),
        IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              print('press');
//              _updateDataEvents();
            }),
        Column(
          children: <Widget>[
            StreamBuilder(
              stream: mapBloc.position,
              builder: (BuildContext context, AsyncSnapshot<LatLng> snapshot) {
                final double latitude = snapshot.data != null && snapshot.data.latitude != null ? snapshot.data.latitude : 0;
                final double longitude = snapshot.data != null && snapshot.data.longitude != null ? snapshot.data.longitude: 0;
                return Text('$latitude|$longitude');
              },
            ),
            StreamBuilder(
              stream: mapBloc.zoom,
              builder: (BuildContext context, AsyncSnapshot<double> snapshot) {
                print('update zoom');
                final double zoom = snapshot.data != null ? snapshot.data : 0;
                return Text('Zoom : $zoom');
              },
            )
          ],
        )


      ],
    );
  }
}
