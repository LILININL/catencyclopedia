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
    );

Map<String, dynamic> _$CatBreedModelToJson(CatBreedModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'origin': instance.origin,
      'temperament': instance.temperament,
    };
