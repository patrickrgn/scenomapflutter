enum TypeProviderMap { osm, mapbox, thunderForest }
class StyleThunderForest {
  static final CYCLE = "cycle";
  static final NEIGHBOURHOOD= "neighbourhood";
  static final TRANSPORT= "transport";
}

class StyleMapbox {
  static final STREETS = "mapbox.streets";
  static final SATELLITE= "mapbox.satellite";
}

typedef StyleCallback = void Function(String style);