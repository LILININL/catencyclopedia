import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/cat_breed.dart';

part 'cat_breed_model.g.dart';

@JsonSerializable()
class CatBreedModel {
  @JsonKey(name: "id")
  String? id;
  @JsonKey(name: "url")
  String? url;
  @JsonKey(name: "breeds")
  List<Breed>? breeds;
  @JsonKey(name: "width")
  int? width;
  @JsonKey(name: "height")
  int? height;

  CatBreedModel({this.id, this.url, this.breeds, this.width, this.height});

  factory CatBreedModel.fromJson(Map<String, dynamic> json) => _$CatBreedModelFromJson(json);

  Map<String, dynamic> toJson() => _$CatBreedModelToJson(this);
}

@JsonSerializable()
class Breed {
  @JsonKey(name: "weight")
  Weight? weight;
  @JsonKey(name: "id")
  String? id;
  @JsonKey(name: "name")
  String? name;
  @JsonKey(name: "cfa_url")
  String? cfaUrl;
  @JsonKey(name: "vetstreet_url")
  String? vetstreetUrl;
  @JsonKey(name: "vcahospitals_url")
  String? vcahospitalsUrl;
  @JsonKey(name: "temperament")
  String? temperament;
  @JsonKey(name: "origin")
  String? origin;
  @JsonKey(name: "country_codes")
  String? countryCodes;
  @JsonKey(name: "country_code")
  String? countryCode;
  @JsonKey(name: "description")
  String? description;
  @JsonKey(name: "life_span")
  String? lifeSpan;
  @JsonKey(name: "indoor")
  int? indoor;
  @JsonKey(name: "lap")
  int? lap;
  @JsonKey(name: "adaptability")
  int? adaptability;
  @JsonKey(name: "affection_level")
  int? affectionLevel;
  @JsonKey(name: "child_friendly")
  int? childFriendly;
  @JsonKey(name: "cat_friendly")
  int? catFriendly;
  @JsonKey(name: "dog_friendly")
  int? dogFriendly;
  @JsonKey(name: "energy_level")
  int? energyLevel;
  @JsonKey(name: "grooming")
  int? grooming;
  @JsonKey(name: "health_issues")
  int? healthIssues;
  @JsonKey(name: "intelligence")
  int? intelligence;
  @JsonKey(name: "shedding_level")
  int? sheddingLevel;
  @JsonKey(name: "social_needs")
  int? socialNeeds;
  @JsonKey(name: "stranger_friendly")
  int? strangerFriendly;
  @JsonKey(name: "vocalisation")
  int? vocalisation;
  @JsonKey(name: "bidability")
  int? bidability;
  @JsonKey(name: "experimental")
  int? experimental;
  @JsonKey(name: "hairless")
  int? hairless;
  @JsonKey(name: "natural")
  int? natural;
  @JsonKey(name: "rare")
  int? rare;
  @JsonKey(name: "rex")
  int? rex;
  @JsonKey(name: "suppressed_tail")
  int? suppressedTail;
  @JsonKey(name: "short_legs")
  int? shortLegs;
  @JsonKey(name: "wikipedia_url")
  String? wikipediaUrl;
  @JsonKey(name: "hypoallergenic")
  int? hypoallergenic;
  @JsonKey(name: "reference_image_id")
  String? referenceImageId;

  Breed({
    this.weight,
    this.id,
    this.name,
    this.cfaUrl,
    this.vetstreetUrl,
    this.vcahospitalsUrl,
    this.temperament,
    this.origin,
    this.countryCodes,
    this.countryCode,
    this.description,
    this.lifeSpan,
    this.indoor,
    this.lap,
    this.adaptability,
    this.affectionLevel,
    this.childFriendly,
    this.catFriendly,
    this.dogFriendly,
    this.energyLevel,
    this.grooming,
    this.healthIssues,
    this.intelligence,
    this.sheddingLevel,
    this.socialNeeds,
    this.strangerFriendly,
    this.vocalisation,
    this.bidability,
    this.experimental,
    this.hairless,
    this.natural,
    this.rare,
    this.rex,
    this.suppressedTail,
    this.shortLegs,
    this.wikipediaUrl,
    this.hypoallergenic,
    this.referenceImageId,
  });

  factory Breed.fromJson(Map<String, dynamic> json) => _$BreedFromJson(json);

  Map<String, dynamic> toJson() => _$BreedToJson(this);
}

@JsonSerializable()
class Weight {
  @JsonKey(name: "imperial")
  String? imperial;
  @JsonKey(name: "metric")
  String? metric;

  Weight({this.imperial, this.metric});

  factory Weight.fromJson(Map<String, dynamic> json) => _$WeightFromJson(json);

  Map<String, dynamic> toJson() => _$WeightToJson(this);
}

// @JsonSerializable(explicitToJson: true)
// class CatBreedModel extends CatBreed {
//   final String? description;
//   final String? temperament;
//   final String? imageUrl;
//   final String? origin;
//   final String? lifeSpan;
//   final WeightModel? weight;
//   final int? indoor;
//   final int? lap;
//   final int? adaptability;
//   final int? affectionLevel;
//   final int? childFriendly;
//   final int? catFriendly;
//   final int? dogFriendly;
//   final int? energyLevel;
//   final int? grooming;
//   final int? healthIssues;
//   final int? intelligence;
//   final int? sheddingLevel;
//   final int? socialNeeds;
//   final int? strangerFriendly;
//   final int? vocalisation;
//   final int? hypoallergenic;

//   CatBreedModel({
//     String? id,
//     String? name,
//     this.description,
//     this.origin,
//     this.temperament,
//     String? referenceImageId,
//     this.weight,
//     this.lifeSpan,
//     this.indoor,
//     this.lap,
//     this.adaptability,
//     this.affectionLevel,
//     this.childFriendly,
//     this.catFriendly,
//     this.dogFriendly,
//     this.energyLevel,
//     this.grooming,
//     this.healthIssues,
//     this.intelligence,
//     this.sheddingLevel,
//     this.socialNeeds,
//     this.strangerFriendly,
//     this.vocalisation,
//     this.hypoallergenic,
//   }) : imageUrl = referenceImageId != null ? 'https://cdn2.thecatapi.com/images/$referenceImageId.jpg' : 'https://placecats.com/200/200',
//        super(
//          id: id ?? '',
//          name: name ?? 'ไม่มีข้อมูล',
//          origin: origin ?? 'ไม่มีข้อมูล',
//          lifeSpan: lifeSpan ?? 'ไม่มีข้อมูล',
//          temperament: temperament ?? 'ไม่มีข้อมูลทางอารมย์',
//          imageUrl: referenceImageId != null ? 'https://cdn2.thecatapi.com/images/$referenceImageId.jpg' : 'https://placecats.com/200/200',
//          weight: weight,
//          indoor: indoor,
//          lap: lap,
//          adaptability: adaptability,
//          affectionLevel: affectionLevel,
//          childFriendly: childFriendly,
//          catFriendly: catFriendly,
//          dogFriendly: dogFriendly,
//          energyLevel: energyLevel,
//          grooming: grooming,
//          healthIssues: healthIssues,
//          intelligence: intelligence,
//          sheddingLevel: sheddingLevel,
//          socialNeeds: socialNeeds,
//          strangerFriendly: strangerFriendly,
//          vocalisation: vocalisation,
//          hypoallergenic: hypoallergenic,
//        );

//   factory CatBreedModel.fromJson(Map<String, dynamic> json) {
//     return _$CatBreedModelFromJson(json);
//   }

//   Map<String, dynamic> toJson() => _$CatBreedModelToJson(this);
// }

// @JsonSerializable()
// class WeightModel {
//   @JsonKey(name: 'imperial')
//   final String? imperial;
//   @JsonKey(name: 'metric')
//   final String? metric;

//   WeightModel({this.imperial, this.metric});

//   factory WeightModel.fromJson(Map<String, dynamic> json) => _$WeightModelFromJson(json);
//   Map<String, dynamic> toJson() => _$WeightModelToJson(this);
// }
