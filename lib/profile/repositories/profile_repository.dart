import 'package:questkeeper/shared/models/return_model/return_model.dart';
import 'package:questkeeper/shared/utils/http_service.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

class ProfileRepository {
  final HttpService _httpService = HttpService();

  Future<ReturnModel> getMyProfile() async {
    try {
      final response = await _httpService.get('/social/profile/me');

      if (response.statusCode == 200) {
        return ReturnModel(
          message: "Profile fetched successfully",
          success: true,
          data: response.data,
        );
      } else {
        return ReturnModel(
          message: "Error fetching profile",
          success: false,
          error: response.data.toString(),
        );
      }
    } catch (error) {
      Sentry.captureException(error);
      return ReturnModel(
        message: "Error fetching profile",
        success: false,
        error: error.toString(),
      );
    }
  }

  Future<ReturnModel> updateUsername(String username) async {
    return updateProfile({"username": username});
  }

  Future<ReturnModel> updateProfile(Map<String, dynamic> data) async {
    try {
      final response =
          await _httpService.post('/social/profile/me', data: data);

      if (response.statusCode == 200) {
        return const ReturnModel(
          message: "Profile updated successfully",
          success: true,
        );
      } else {
        return ReturnModel(
          message: response.statusCode == 409 && data.containsKey("username")
              ? "Username already taken"
              : "Error updating profile",
          success: false,
          error: response.statusCode == 409 && data.containsKey("username")
              ? "Username already taken"
              : response.data,
        );
      }
    } catch (error) {
      Sentry.captureException(error);
      return ReturnModel(
        message: "Error updating profile",
        success: false,
        error: error.toString(),
      );
    }
  }

  Future<ReturnModel> getProfile(String username) async {
    try {
      final response = await _httpService.get('/social/profile/$username');

      if (response.statusCode == 200) {
        return ReturnModel(
          message: "Profile fetched successfully",
          success: true,
          data: response.data.toString(),
        );
      } else {
        return ReturnModel(
          message: "Error fetching profile",
          success: false,
          error: response.data.toString(),
        );
      }
    } catch (error) {
      Sentry.captureException(error);
      return ReturnModel(
        message: "Error fetching profile",
        success: false,
        error: error.toString(),
      );
    }
  }
}
