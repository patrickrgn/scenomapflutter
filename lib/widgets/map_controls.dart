import 'package:flutter/material.dart';
import 'package:sceno_map_flutter/blocs/map_bloc.dart';


class MapControls extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _buildControl();
  }

  Widget _buildControl() {
    print("buildControl");
    return Column(
//      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        SizedBox(
          width: 50,
          child: IconButton(
              icon: Icon(Icons.my_location),
              color: Colors.red,
              padding: EdgeInsets.all(0),
              onPressed: () {
                mapBloc.moveToPosition();
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
              }),
        ),
        SizedBox(
          width: 50,
          child: IconButton(
              icon: Icon(Icons.zoom_out),
              color: Colors.black,
              padding: EdgeInsets.all(0),
              onPressed: () {
                mapBloc.zoomOut();
              }),
        ),
        IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              print('press');
//              _updateDataEvents();
            }),
      ],
    );
  }
}
