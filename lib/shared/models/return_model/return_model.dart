import 'package:freezed_annotation/freezed_annotation.dart';

part 'return_model.freezed.dart';

@freezed
class ReturnModel with _$ReturnModel {
  const factory ReturnModel({
    required String message,
    required bool success,
    String? error,
  }) = _ReturnModel;
}
