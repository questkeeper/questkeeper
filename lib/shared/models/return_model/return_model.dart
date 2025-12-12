import 'package:freezed_annotation/freezed_annotation.dart';

part 'return_model.freezed.dart';
part 'return_model.g.dart';

@freezed
abstract class ReturnModel with _$ReturnModel {
  const factory ReturnModel({
    required String message,
    required bool success,
    dynamic data,
    String? error,
  }) = _ReturnModel;

  factory ReturnModel.fromJson(Map<String, dynamic> json) =>
      _$ReturnModelFromJson(json);
}
