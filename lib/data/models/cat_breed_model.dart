import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/cat_breed.dart';

part 'cat_breed_model.g.dart';

@JsonSerializable(explicitToJson: true)
class CatBreedModel extends CatBreed {
  CatBreedModel({
    @JsonKey(name: 'id') String? id,
    @JsonKey(name: 'name') String? name,
    @JsonKey(name: 'description') String? description,
    @JsonKey(name: 'origin') String? origin,
    @JsonKey(name: 'temperament') String? temperament,
    @JsonKey(name: 'imageUrl') Base64Decoder? imageUrl,
  }) : super(
         id: id ?? '',
         name: name ?? 'Unknown',
         description: description ?? 'No description',
         origin: origin ?? 'Unknown',
         temperament: temperament ?? 'Unknown',
         imageUrl: imageUrl != null ? 'https://cdn2.thecatapi.com/images/$imageUrl.jpg' : 'https://placekitten.com/200/200',
       );
  factory CatBreedModel.fromJson(Map<String, dynamic> json) => _$CatBreedModelFromJson(json);
  Map<String, dynamic> toJson() => _$CatBreedModelToJson(this);
}
