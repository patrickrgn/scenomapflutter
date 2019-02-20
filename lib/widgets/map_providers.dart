
import 'package:flutter/material.dart';
import 'package:sceno_map_flutter/blocs/map_bloc.dart';
import 'package:sceno_map_flutter/models/map_model.dart';
import 'package:sceno_map_flutter/models/model.dart';

class MapProviders extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _buildProviderMap();
  }


  Widget _buildProviderMap() {
    return StreamBuilder(
        stream: mapBloc.mapModel,
        initialData: MapModel(provider: TypeProviderMap.osm),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          return Row(
            children: <Widget>[
              _buildProviderMapButton("OSM", TypeProviderMap.osm, null, snapshot.data),
              _buildProviderMapButton("Mapbox", TypeProviderMap.mapbox, StyleMapbox.STREETS, snapshot.data),
              _buildProviderMapButton("ThunderForest", TypeProviderMap.thunderForest, StyleThunderForest.CYCLE, snapshot.data)
            ],
          );
        }
    );
  }

  Widget _buildProviderMapButton(String title, TypeProviderMap type, String style, MapModel model) =>
      RaisedButton(
          child: Text(title),
          color: model.provider == type ? Colors.green : Colors.white,
          textColor: model.provider == type ? Colors.white : Colors.green,
          padding: EdgeInsets.all(0),
          elevation: model.provider == type ? 0 : 3,
          onPressed: () {
            mapBloc.updateMapModel(provider: type, style: style);
          });
}
