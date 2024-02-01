class DogImageModel {
    DogImageModel({
        required this.id,
        required this.url,
        required this.breeds,
        required this.width,
        required this.height,
    });

    final String? id;
    final String? url;
    final List<Breed> breeds;
    final int? width;
    final int? height;

    factory DogImageModel.fromJson(Map<String, dynamic> json){ 
        return DogImageModel(
            id: json["id"],
            url: json["url"],
            breeds: json["breeds"] == null ? [] : List<Breed>.from(json["breeds"]!.map((x) => Breed.fromJson(x))),
            width: json["width"],
            height: json["height"],
        );
    }

    Map<String, dynamic> toJson() => {
        "id": id,
        "url": url,
        "breeds": breeds.map((x) => x?.toJson()).toList(),
        "width": width,
        "height": height,
    };

}

class Breed {
    Breed({
        required this.weight,
        required this.height,
        required this.id,
        required this.name,
        required this.countryCode,
        required this.bredFor,
        required this.breedGroup,
        required this.lifeSpan,
        required this.temperament,
        required this.origin,
        required this.referenceImageId,
    });

    final Eight? weight;
    final Eight? height;
    final int? id;
    final String? name;
    final String? countryCode;
    final String? bredFor;
    final String? breedGroup;
    final String? lifeSpan;
    final String? temperament;
    final String? origin;
    final String? referenceImageId;

    factory Breed.fromJson(Map<String, dynamic> json){ 
        return Breed(
            weight: json["weight"] == null ? null : Eight.fromJson(json["weight"]),
            height: json["height"] == null ? null : Eight.fromJson(json["height"]),
            id: json["id"],
            name: json["name"],
            countryCode: json["country_code"],
            bredFor: json["bred_for"],
            breedGroup: json["breed_group"],
            lifeSpan: json["life_span"],
            temperament: json["temperament"],
            origin: json["origin"],
            referenceImageId: json["reference_image_id"],
        );
    }

    Map<String, dynamic> toJson() => {
        "weight": weight?.toJson(),
        "height": height?.toJson(),
        "id": id,
        "name": name,
        "country_code": countryCode,
        "bred_for": bredFor,
        "breed_group": breedGroup,
        "life_span": lifeSpan,
        "temperament": temperament,
        "origin": origin,
        "reference_image_id": referenceImageId,
    };

}

class Eight {
    Eight({
        required this.imperial,
        required this.metric,
    });

    final String? imperial;
    final String? metric;

    factory Eight.fromJson(Map<String, dynamic> json){ 
        return Eight(
            imperial: json["imperial"],
            metric: json["metric"],
        );
    }

    Map<String, dynamic> toJson() => {
        "imperial": imperial,
        "metric": metric,
    };

}
