enum Category { LOISIRS, MUSIQUE, THTRE, SPECTACLE, EXPOSITION, DANSE, AUTRES, LITTRATURE, CINMA, FESTIVAL, CONFRENCE, CIRQUE, SPORT }

final categoryValues = new EnumValues({
  "Autres": Category.AUTRES,
  "Cinéma": Category.CINMA,
  "Cirque": Category.CIRQUE,
  "Conférence": Category.CONFRENCE,
  "Danse": Category.DANSE,
  "Exposition": Category.EXPOSITION,
  "Festival": Category.FESTIVAL,
  "Littérature": Category.LITTRATURE,
  "Loisirs": Category.LOISIRS,
  "Musique": Category.MUSIQUE,
  "Spectacle": Category.SPECTACLE,
  "Sport": Category.SPORT,
  "Théâtre": Category.THTRE
});

class EnumValues<T> {
  Map<String, T> map;
  Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    if (reverseMap == null) {
      reverseMap = map.map((k, v) => new MapEntry(v, k));
    }
    return reverseMap;
  }
}