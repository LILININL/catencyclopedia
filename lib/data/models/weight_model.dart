import 'package:json_annotation/json_annotation.dart';

part 'weight_model.g.dart';

@JsonSerializable()
class WeightModel {
  @JsonKey(name: 'imperial')
  final String? imperial;

  @JsonKey(name: 'metric')
  final String? metric;

  WeightModel({this.imperial, this.metric});

  factory WeightModel.fromJson(Map<String, dynamic> json) => _$WeightModelFromJson(json);
  Map<String, dynamic> toJson() => _$WeightModelToJson(this);
}
