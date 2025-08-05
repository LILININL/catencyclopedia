// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cat_breed_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CatBreedModel _$CatBreedModelFromJson(Map<String, dynamic> json) =>
    CatBreedModel(
      id: json['id'] as String?,
      name: json['name'] as String?,
      description: json['description'] as String?,
      origin: json['origin'] as String?,
      temperament: json['temperament'] as String?,
      weight: json['weight'] == null
          ? null
          : WeightModel.fromJson(json['weight'] as Map<String, dynamic>),
      lifeSpan: json['lifeSpan'] as String?,
      indoor: (json['indoor'] as num?)?.toInt(),
      lap: (json['lap'] as num?)?.toInt(),
      adaptability: (json['adaptability'] as num?)?.toInt(),
      affectionLevel: (json['affectionLevel'] as num?)?.toInt(),
      childFriendly: (json['childFriendly'] as num?)?.toInt(),
      catFriendly: (json['catFriendly'] as num?)?.toInt(),
      dogFriendly: (json['dogFriendly'] as num?)?.toInt(),
      energyLevel: (json['energyLevel'] as num?)?.toInt(),
      grooming: (json['grooming'] as num?)?.toInt(),
      healthIssues: (json['healthIssues'] as num?)?.toInt(),
      intelligence: (json['intelligence'] as num?)?.toInt(),
      sheddingLevel: (json['sheddingLevel'] as num?)?.toInt(),
      socialNeeds: (json['socialNeeds'] as num?)?.toInt(),
      strangerFriendly: (json['strangerFriendly'] as num?)?.toInt(),
      vocalisation: (json['vocalisation'] as num?)?.toInt(),
      hypoallergenic: (json['hypoallergenic'] as num?)?.toInt(),
    );

Map<String, dynamic> _$CatBreedModelToJson(CatBreedModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'origin': instance.origin,
      'temperament': instance.temperament,
      'weight': instance.weight,
      'lifeSpan': instance.lifeSpan,
      'indoor': instance.indoor,
      'lap': instance.lap,
      'adaptability': instance.adaptability,
      'affectionLevel': instance.affectionLevel,
      'childFriendly': instance.childFriendly,
      'catFriendly': instance.catFriendly,
      'dogFriendly': instance.dogFriendly,
      'energyLevel': instance.energyLevel,
      'grooming': instance.grooming,
      'healthIssues': instance.healthIssues,
      'intelligence': instance.intelligence,
      'sheddingLevel': instance.sheddingLevel,
      'socialNeeds': instance.socialNeeds,
      'strangerFriendly': instance.strangerFriendly,
      'vocalisation': instance.vocalisation,
      'hypoallergenic': instance.hypoallergenic,
    };
