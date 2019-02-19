import 'package:flutter/material.dart';
import 'package:latlong/latlong.dart';
import 'package:sceno_map_flutter/blocs/map_bloc.dart';

class MapInfos extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
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
      ),
    );
  }
}
