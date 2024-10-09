import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:questkeeper/constants.dart';
import 'package:questkeeper/shared/models/return_model/return_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfileRepository {
  final Session session = Supabase.instance.client.auth.currentSession!;
  final header = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    'Authorization':
        'Bearer ${Supabase.instance.client.auth.currentSession!.accessToken}'
  };
  Future<ReturnModel> getMyProfile() async {
    final response = await http.get(Uri.parse('$baseApiUri/social/profile/me'),
        headers: header);

    if (response.statusCode != 200) {
      return ReturnModel(
          message: "Error fetching profile",
          success: false,
          error: response.body);
    } else {
      return ReturnModel(
          message: "Profile fetched successfully",
          success: true,
          data: response.body);
    }
  }

  Future<ReturnModel> updateUsername(String username) async {
    final response = await http.post(Uri.parse('$baseApiUri/social/profile/me'),
        body: const JsonEncoder().convert({"username": username}),
        headers: header);

    if (response.statusCode != 200) {
      return ReturnModel(
          message: response.statusCode == 409
              ? response.body
              : "Error updating username",
          success: false,
          error: response.body);
    } else {
      return const ReturnModel(
          message: "Username updated successfully", success: true);
    }
  }

  Future<ReturnModel> getProfile(String username) async {
    final response = await http.get(
        Uri.parse('$baseApiUri/social/profile/$username'),
        headers: header);

    if (response.statusCode != 200) {
      return ReturnModel(
          message: "Error fetching profile",
          success: false,
          error: response.body);
    } else {
      return ReturnModel(
          message: "Profile fetched successfully",
          success: true,
          data: response.body);
    }
  }
}
