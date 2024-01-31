class DogDataModel {
  Weight? weight;
  Height? height;
  int? id;
  String? name;
  String? description;
  String? bredFor;
  String? breedGroup;
  String? lifeSpan;
  String? history;
  String? temperament;
  String? origin;
  String? referenceImageId;

  DogDataModel(
      {this.weight,
      this.height,
      this.id,
      this.name,
      this.description,
      this.bredFor,
      this.breedGroup,
      this.lifeSpan,
      this.history,
      this.temperament,
      this.origin,
      this.referenceImageId});

  DogDataModel.fromJson(Map<String, dynamic> json) {
    weight = json["weight"] == null ? null : Weight.fromJson(json["weight"]);
    height = json["height"] == null ? null : Height.fromJson(json["height"]);
    id = json["id"];
    name = json["name"];
    description = json["description"];
    bredFor = json["bred_for"];
    breedGroup = json["breed_group"];
    lifeSpan = json["life_span"];
    history = json["history"];
    temperament = json["temperament"];
    origin = json["origin"];
    referenceImageId = json["reference_image_id"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    if (weight != null) {
      _data["weight"] = weight?.toJson();
    }
    if (height != null) {
      _data["height"] = height?.toJson();
    }
    _data["id"] = id;
    _data["name"] = name;
    _data["description"] = description;
    _data["bred_for"] = bredFor;
    _data["breed_group"] = breedGroup;
    _data["life_span"] = lifeSpan;
    _data["history"] = history;
    _data["temperament"] = temperament;
    _data["origin"] = origin;
    _data["reference_image_id"] = referenceImageId;
    return _data;
  }
}

class Height {
  String? imperial;
  String? metric;

  Height({this.imperial, this.metric});

  Height.fromJson(Map<String, dynamic> json) {
    imperial = json["imperial"];
    metric = json["metric"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["imperial"] = imperial;
    _data["metric"] = metric;
    return _data;
  }
}

class Weight {
  String? imperial;
  String? metric;

  Weight({this.imperial, this.metric});

  Weight.fromJson(Map<String, dynamic> json) {
    imperial = json["imperial"];
    metric = json["metric"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["imperial"] = imperial;
    _data["metric"] = metric;
    return _data;
  }
}
