import 'package:flutter/material.dart';
import 'package:sceno_map_flutter/blocs/map_bloc.dart';


class MapControls extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
        onPressed: () => mapBloc.moveToPosition(),
        child: new Icon(
          Icons.my_location,
          color: Colors.red,
          size: 20.0,
        ),
        shape: new CircleBorder(),
        elevation: 2.0,
        fillColor: Colors.white,
        padding: const EdgeInsets.all(0.0),
        constraints: BoxConstraints.expand(height: 35, width: 35)
    );
  }

}
