import 'package:equatable/equatable.dart';

class ArtObject extends Equatable {
  /// object ID to fetch data from API and identify
  final String objNr;

  /// title of the art object
  final String title;

  /// image of the art object (not the header one)
  final String img;

  /// store the image ratio to display correct placeholders
  final double imgRatio;

  /// some extra description
  final String? label;
  final String? description;
  final List<String>? types;

  /// materials used for the art object
  final List<String>? materials;

  /// principal or original maker
  final String? maker;

  /// dating period (e.g. 1990 - 1993)
  final String? date;

  const ArtObject({
    required this.objNr,
    required this.title,
    required this.img,
    required this.imgRatio,
    this.label,
    this.description,
    this.types,
    this.materials,
    this.maker,
    this.date,
  });

  /// Method used to convert JSON data from API to [ArtObject]
  static Set<ArtObject> fromJSON(dynamic json) {
    Set<ArtObject> res = <ArtObject>{};

    json = json['artObjects'];

    for (int i = 0; i < json.length; i++) {
      if (json[i]['objectNumber'] == null ||
          json[i]['objectNumber'].toString().isEmpty) {
        throw Exception("Empty or null objectNumber");
      }

      ArtObject obj = ArtObject(
        objNr: json[i]['objectNumber'],
        title: json[i]['title'] ?? " - ",
        img: json[i]['webImage']['url'] ?? "",
        imgRatio:
            json[i]['webImage']['width'] / json[i]['webImage']['height'] ?? 1,
      );

      res.add(obj);
    }
    return res;
  }

  /// Add details to [ArtObject] from JSON data
  static ArtObject fromJSONSingle(dynamic json, ArtObject artObject) {
    ArtObject res = artObject;
    json = json['artObject'];

    /// parse the json list of types
    if (json['objectTypes'] != null &&
        json['objectTypes'].toString().isNotEmpty) {
      String types = json['objectTypes'].toString();
      res =
          res.copyWith(types: types.substring(1, types.length - 1).split(","));
    } else {
      res = res.copyWith(types: [" - "]);
    }

    /// parse the json list of materials
    if (json['materials'] != null && json['materials'].toString().isNotEmpty) {
      String materials = json['materials'].toString();
      res = res.copyWith(
        materials: materials.substring(1, materials.length - 1).split(","),
      );
    } else {
      res = res.copyWith(materials: [" - "]);
    }

    res = res.copyWith(
      maker: json['principalMaker'] ?? " - ",
      description: json['label']['description'] ?? " - ",
      label: json['label']['makerLine'] ?? " - ",
    );

    dynamic early = json['dating']['yearEarly'];
    dynamic late = json['dating']['yearLate'];
    if (early != null &&
        early.toString().isNotEmpty &&
        late != null &&
        late.toString().isNotEmpty) {
      if (early is! int || late is! int) {
        throw Exception("Dating years format incorrect");
      } else if (early > late) {
        throw Exception("Early years is after late year.");
      } else if (early == late) {
        res = res.copyWith(date: early.toString());
      } else {
        res = res.copyWith(date: "$early - $late");
      }
    }

    return res;
  }

  bool detailsFetched() {
    return label == null ||
        description == null ||
        types == null ||
        materials == null ||
        maker == null ||
        date == null;
  }

  ArtObject copyWith({
    String? objNr,
    String? title,
    String? img,
    double? imgRatio,
    String? label,
    String? description,
    List<String>? types,
    List<String>? materials,
    String? maker,
    String? date,
  }) {
    return ArtObject(
      objNr: objNr ?? this.objNr,
      title: title ?? this.title,
      img: img ?? this.img,
      imgRatio: imgRatio ?? this.imgRatio,
      label: label ?? this.label,
      description: description ?? this.description,
      types: types ?? this.types,
      materials: materials ?? this.materials,
      maker: maker ?? this.maker,
      date: date ?? this.date,
    );
  }

  @override
  List<Object?> get props => [
        objNr,
        title,
        img,
        imgRatio,
        label,
        description,
        types,
        materials,
        maker,
        date,
      ];
}
