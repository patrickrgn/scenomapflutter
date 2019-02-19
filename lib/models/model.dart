enum TypeProviderMap { osm, mapbox, thunderForest }
class StyleThunderForest {
  static const CYCLE = "cycle";
  static const NEIGHBOURHOOD= "neighbourhood";
  static const TRANSPORT= "transport";
}

class StyleMapbox {
  static const STREETS = "mapbox.streets";
  static const SATELLITE= "mapbox.satellite";
}

typedef StyleCallback = void Function(String style);