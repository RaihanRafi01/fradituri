import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  // Base URL for the API
  final String baseUrl = ''; // Replace with your API base URL

  // Send message to the API and get the response
  Future<http.Response> sendMessage(String userInput) async {
    // Construct the endpoint URL
    final Uri url = Uri.parse('http://192.168.10.208:5500/api/doctor_assist/'); // Updated with trailing slash

    // Headers for the HTTP request
    final Map<String, String> headers = {
      "Content-Type": "application/json",
    };

    // Request body
    final Map<String, String> body = {
      "user_input": userInput,
    };

    // Make the POST request
    return await http.post(
      url,
      headers: headers,
      body: jsonEncode(body),
    );
  }
}
