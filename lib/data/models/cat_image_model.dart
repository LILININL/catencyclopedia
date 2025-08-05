import 'package:json_annotation/json_annotation.dart';

import 'cat_breed_model.dart';

part 'cat_image_model.g.dart';

@JsonSerializable(explicitToJson: true)
class CatImageModel {
  @JsonKey(name: 'id')
  final String? id;
  @JsonKey(name: 'url')
  final String? url;
  @JsonKey(name: 'width')
  final int? width;
  @JsonKey(name: 'height')
  final int? height;
  @JsonKey(name: 'breeds')
  final List<CatBreedModel>? breeds;

  CatImageModel({this.id, this.url, this.width, this.height, this.breeds});

  factory CatImageModel.fromJson(Map<String, dynamic> json) => _$CatImageModelFromJson(json);
  Map<String, dynamic> toJson() => _$CatImageModelToJson(this);
}
