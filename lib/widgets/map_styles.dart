import 'package:flutter/material.dart';
import 'package:sceno_map_flutter/blocs/map_bloc.dart';
import 'package:sceno_map_flutter/models/map_model.dart';
import 'package:sceno_map_flutter/models/model.dart';

class MapStyles extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _buildStyleMap();
  }


  Widget _buildStyleMap() {
    return StreamBuilder(
        stream: mapBloc.mapModel,
        initialData: MapModel(provider: TypeProviderMap.osm),
        builder: (BuildContext context, AsyncSnapshot<MapModel> snapshot) {
          switch (snapshot.data.provider) {
            case TypeProviderMap.osm:
              return _buildStyleOSM();
              break;

            case TypeProviderMap.mapbox:
              return _buildStyleMapbox(snapshot.data);
              break;

            case TypeProviderMap.thunderForest:
              return _buildStyleThunderForest(snapshot.data);
              break;
          }
        }
    );
  }

  Widget _buildStyleOSM() {
    return Container();
  }

  Widget _buildStyleMapbox(MapModel model) {
    return Row(
      children: <Widget>[
        _buildStyleButton(
            title: "Streets",
            style: StyleMapbox.STREETS,
            active: model.style == StyleMapbox.STREETS,
            onPressed: this._updateStyleMapbox),
        _buildStyleButton(
            title: "Satellite",
            style: StyleMapbox.SATELLITE,
            active: model.style == StyleMapbox.SATELLITE,
            onPressed: this._updateStyleMapbox),
      ],
    );
  }

  Widget _buildStyleThunderForest(MapModel model) {
    return Row(
      children: <Widget>[
        _buildStyleButton(
            title: "Transport",
            style: StyleThunderForest.TRANSPORT,
            active: model.style == StyleThunderForest.TRANSPORT,
            onPressed: this._updateStyleThunderForest),
        _buildStyleButton(
            title: "Neighbourhood",
            style: StyleThunderForest.NEIGHBOURHOOD,
            active: model.style == StyleThunderForest.NEIGHBOURHOOD,
            onPressed: this._updateStyleThunderForest),
        _buildStyleButton(
            title: "Cycle",
            style: StyleThunderForest.CYCLE,
            active: model.style == StyleThunderForest.CYCLE,
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
    mapBloc.updateMapModel(provider: TypeProviderMap.thunderForest, style: style);
  }

  void _updateStyleMapbox(String style) {
    mapBloc.updateMapModel(provider: TypeProviderMap.mapbox, style: style);
  }
}
