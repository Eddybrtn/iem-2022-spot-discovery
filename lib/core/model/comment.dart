import 'package:json_annotation/json_annotation.dart';

part 'comment.g.dart';

@JsonSerializable(checked: true, fieldRename: FieldRename.snake)
class SpotComment {
  String comment;
  int createdAt;

  SpotComment({required this.comment, required this.createdAt});

  factory SpotComment.fromJson(Map<String, dynamic> json) =>
      _$SpotCommentFromJson(json);

  Map<String, dynamic> toJson() => _$SpotCommentToJson(this);
}
