import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/cat_breed.dart';
import 'weight_model.dart';

part 'cat_breed_model.g.dart';

@JsonSerializable(explicitToJson: true)
class CatBreedModel extends CatBreed {
  CatBreedModel({
    @JsonKey(name: 'id') String? id,
    @JsonKey(name: 'name') String? name,
    @JsonKey(name: 'description') String? description,
    @JsonKey(name: 'origin') String? origin,
    @JsonKey(name: 'temperament') String? temperament,
    @JsonKey(name: 'reference_image_id') String? imageId,
    @JsonKey(name: 'weight') WeightModel? weight, // เปลี่ยนเป็น WeightModel?
    @JsonKey(name: 'life_span') String? lifeSpan,
    @JsonKey(name: 'indoor') int? indoor,
    @JsonKey(name: 'lap') int? lap,
    @JsonKey(name: 'adaptability') int? adaptability,
    @JsonKey(name: 'affection_level') int? affectionLevel,
    @JsonKey(name: 'child_friendly') int? childFriendly,
    @JsonKey(name: 'cat_friendly') int? catFriendly,
    @JsonKey(name: 'dog_friendly') int? dogFriendly,
    @JsonKey(name: 'energy_level') int? energyLevel,
    @JsonKey(name: 'grooming') int? grooming,
    @JsonKey(name: 'health_issues') int? healthIssues,
    @JsonKey(name: 'intelligence') int? intelligence,
    @JsonKey(name: 'shedding_level') int? sheddingLevel,
    @JsonKey(name: 'social_needs') int? socialNeeds,
    @JsonKey(name: 'stranger_friendly') int? strangerFriendly,
    @JsonKey(name: 'vocalisation') int? vocalisation,
    @JsonKey(name: 'hypoallergenic') int? hypoallergenic,
  }) : super(
         id: id ?? '',
         name: name ?? 'Unknown',
         description: description ?? 'No description',
         origin: origin ?? 'Unknown',
         temperament: temperament ?? 'Unknown',
         imageUrl: imageId != null ? 'https://cdn2.thecatapi.com/images/$imageId.jpg' : 'https://placecats.com/200/200',
         weight: weight?.metric ?? 'Unknown', // map metric เป็น String สำหรับ entity
         lifeSpan: lifeSpan ?? 'Unknown',
         indoor: indoor ?? 0,
         lap: lap ?? 0,
         adaptability: adaptability ?? 0,
         affectionLevel: affectionLevel ?? 0,
         childFriendly: childFriendly ?? 0,
         catFriendly: catFriendly ?? 0,
         dogFriendly: dogFriendly ?? 0,
         energyLevel: energyLevel ?? 0,
         grooming: grooming ?? 0,
         healthIssues: healthIssues ?? 0,
         intelligence: intelligence ?? 0,
         sheddingLevel: sheddingLevel ?? 0,
         socialNeeds: socialNeeds ?? 0,
         strangerFriendly: strangerFriendly ?? 0,
         vocalisation: vocalisation ?? 0,
         hypoallergenic: hypoallergenic ?? 0,
       );

  factory CatBreedModel.fromJson(Map<String, dynamic> json) => _$CatBreedModelFromJson(json);
  Map<String, dynamic> toJson() => _$CatBreedModelToJson(this);
}
