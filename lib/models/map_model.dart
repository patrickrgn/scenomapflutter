

import 'package:flutter/material.dart';
import 'package:latlong/latlong.dart';
import 'package:sceno_map_flutter/models/model.dart';

class MapModel {
  TypeProviderMap provider;
  String style;
  LatLng position;

  MapModel({@required this.provider, this.style, this.position});

}