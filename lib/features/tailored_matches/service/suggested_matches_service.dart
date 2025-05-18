import 'dart:convert';

import 'package:get/get.dart';
import 'package:inakal/features/auth/controller/auth_controller.dart';
import 'package:inakal/features/tailored_matches/model/suggested_matches_model.dart';
import 'package:http/http.dart' as http;

class SuggestedMatchesService {
  final AuthController authController = Get.find();
  Future<SuggestedMatchesModel> getSuggestedMatches() async {
    try {
      final response = authController.userId.value == "2144" // Replace with actual user ID
      ? await _sendGetRequest(url: "https://mocki.io/v1/748f93f3-c050-4ce8-a3e4-bfd744eeaa9a")
      : await _sendGetRequest(url: "https://mocki.io/v1/6a3b214b-1ad6-4d16-8ae1-4f244c4d6d63"); 

      if (response.statusCode == 200) {
        final responseBody = await response.stream.bytesToString();
        final responseJson = json.decode(responseBody);
        final suggestedMatchesModel = SuggestedMatchesModel.fromJson(responseJson);
        if (suggestedMatchesModel.type == "success") {
          print('Suggested matches fetched successfully');
        } else {
          print('Error: ${suggestedMatchesModel.message}');
        }
        return suggestedMatchesModel;
      } else {
        print('Error: ${response.reasonPhrase}');
        return SuggestedMatchesModel(); // Return an empty model or handle the error as needed
      }
    } catch (e) {
      print('Error fetching suggested matches: $e');
      return SuggestedMatchesModel(); // Return an empty model or handle the error as needed
    }
  }

  // Helper method to send GET request
  Future<http.StreamedResponse> _sendGetRequest({
    required String url,
  }) async {
    final request = http.Request('GET', Uri.parse(url));
    return await request.send();
  }
}