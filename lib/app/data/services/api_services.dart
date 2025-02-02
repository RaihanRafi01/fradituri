import 'dart:convert';
import 'dart:io';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

class ApiService {
  final FlutterSecureStorage _storage = FlutterSecureStorage();

  // Base URL for the API
  final String baseUrl =
      'https://1eda-115-127-156-9.ngrok-free.app/'; // Replace with your API base URL

  // Send message to the API and get the response
  Future<http.Response> sendMessage(String userInput) async {
    // Construct the endpoint URL
    final Uri url = Uri.parse(
        'http://192.168.10.208:5500/api/doctor_assist/'); // Updated with trailing slash

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

  // Sign-up method
  Future<http.Response> signUp(
      String email, String password, String name) async {
    // Construct the endpoint URL
    final Uri url = Uri.parse('${baseUrl}api/auth/signup');

    // Headers for the HTTP request
    final Map<String, String> headers = {
      "Content-Type": "application/json",
    };

    // Request body
    final Map<String, String> body = {
      "email": email,
      "password": password,
      "name": name,
    };

    // Make the POST request
    return await http.post(
      url,
      headers: headers,
      body: jsonEncode(body),
    );
  }

  Future<http.Response> login(String email, String password) async {
    // Construct the endpoint URL
    final Uri url = Uri.parse('${baseUrl}api/auth/login');

    // Headers for the HTTP request
    final Map<String, String> headers = {
      "Content-Type": "application/json",
    };

    // Request body
    final Map<String, String> body = {
      "email": email,
      "password": password,
    };

    // Make the POST request
    return await http.post(
      url,
      headers: headers,
      body: jsonEncode(body),
    );
  }

  Future<http.Response> sendOtp(String email) async {
    // Construct the endpoint URL
    final Uri url = Uri.parse('${baseUrl}api/auth/password/reset');

    // Headers for the HTTP request
    final Map<String, String> headers = {
      "Content-Type": "application/json",
    };

    // Request body
    final Map<String, String> body = {"email": email};

    // Make the POST request
    return await http.post(
      url,
      headers: headers,
      body: jsonEncode(body),
    );
  }

  Future<http.Response> verifyOtp(String email, String otp) async {
    // Construct the endpoint URL
    final Uri url = Uri.parse('${baseUrl}api/auth/verify-otp');

    // Headers for the HTTP request
    final Map<String, String> headers = {
      "Content-Type": "application/json",
    };

    // Request body
    final Map<String, String> body = {"email": email, "otp": otp};

    // Make the POST request
    return await http.post(
      url,
      headers: headers,
      body: jsonEncode(body),
    );
  }

  Future<http.Response> changePassword(
      String email, String otp, String newPassword) async {
    // Construct the endpoint URL
    final Uri url = Uri.parse('${baseUrl}api/auth/password/reset/verify');

    // Headers for the HTTP request
    final Map<String, String> headers = {
      "Content-Type": "application/json",
    };

    // Request body
    final Map<String, String> body = {
      "email": email,
      "otp": otp,
      "newPassword": newPassword
    };

    // Make the POST request
    return await http.post(
      url,
      headers: headers,
      body: jsonEncode(body),
    );
  }

  Future<http.Response> logout() async {
    // Construct the endpoint URL
    final Uri url = Uri.parse('${baseUrl}api/auth/logout');

    String? accessToken = await _storage.read(key: 'access_token');

    // Headers for the HTTP request
    final Map<String, String> headers = {
      "Content-Type": "application/json",
    };

    // Request body
    final Map<String, String> body = {
      "token": accessToken!,
    };

    // Make the POST request
    return await http.post(
      url,
      headers: headers,
      body: jsonEncode(body),
    );
  }

  ///// CHAT

  /// Create a new chat with the first message
  Future<http.Response> createChat(String message) async {
    final Uri url = Uri.parse('${baseUrl}api/chatbot/message');
    // Retrieve the stored access token
    String? accessToken = await _storage.read(key: 'access_token');

    // Headers for the HTTP request with Bearer token
    final Map<String, String> headers = {
      "Content-Type": "application/json",
      "Authorization": "Bearer $accessToken", // Add the Bearer token
    };

    // Request body
    final Map<String, String> body = {
      "userMessage": message,
    };

    return await http.post(
      url,
      headers: headers,
      body: jsonEncode(body),
    );
  }

  /// Send a message to an existing chat
  Future<http.Response> sendMessageToChat(String chatId, String message) async {
    final Uri url = Uri.parse('${baseUrl}api/chatbot/message');
    String? accessToken = await _storage.read(key: 'access_token');

    // Headers for the HTTP request with Bearer token
    final Map<String, String> headers = {
      "Content-Type": "application/json",
      "Authorization": "Bearer $accessToken", // Add the Bearer token
    };

    // Request body
    final Map<String, String> body = {"chatId": chatId, "userMessage": message};

    return http.post(
      url,
      headers: headers,
      body: jsonEncode(body),
    );
  }

  /// Fetch chat history
  Future<http.Response> getChatHistory(String chatId) async {
    final Uri url = Uri.parse('${baseUrl}api/chatbot/history/$chatId');
    String? accessToken = await _storage.read(key: 'access_token');

    // Headers for the HTTP request with Bearer token
    final Map<String, String> headers = {
      "Content-Type": "application/json",
      "Authorization": "Bearer $accessToken", // Add the Bearer token
    };
    return await http.get(
      url,
      headers: headers,
    );
  }

  Future<http.Response> getHistory() async {
    final Uri url = Uri.parse('${baseUrl}api/chatbot/all-chats');
    String? accessToken = await _storage.read(key: 'access_token');

    // Headers for the HTTP request with Bearer token
    final Map<String, String> headers = {
      "Content-Type": "application/json",
      "Authorization": "Bearer $accessToken", // Add the Bearer token
    };
    return await http.get(
      url,
      headers: headers,
    );
  }

  Future<List<Map<String, String>>> fetchAllHistory() async {
    final Uri url = Uri.parse('${baseUrl}api/chatbot/all-chats');
    String? accessToken = await _storage.read(key: 'access_token');

    // Headers for the HTTP request with Bearer token
    final Map<String, String> headers = {
      "Content-Type": "application/json",
      "Authorization": "Bearer $accessToken", // Add the Bearer token
    };

    try {
      final response = await http.get(url, headers: headers);

      print(
          ':::::::::::::::RESPONSE:::::::::::::::::::::${response.body.toString()}');
      print(':::::::::::::::CODE:::::::::::::::::::::${response.statusCode}');
      print(':::::::::::::::REQUEST:::::::::::::::::::::${response.request}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = jsonDecode(response.body);

        // Check if 'chatHistories' exists in the response and is a list
        if (responseData['success'] == true &&
            responseData['chatHistories'] is List) {
          // Return the mapped list of chat histories
          return List<Map<String, String>>.from(
            (responseData['chatHistories'] as List<dynamic>).map((chat) {
              return {
                'id': chat['_id'] as String,
                'name': chat['chat_name'] as String,
              };
            }),
          );
        } else {
          throw Exception('No chat histories found or invalid response format');
        }
      } else {
        throw Exception('Failed to load chat histories');
      }
    } catch (e) {
      throw Exception('Error fetching chat histories: $e');
    }
  }

  Future<http.Response> updateChatName(String chatName, String chatId) async {
    final Uri url = Uri.parse('${baseUrl}api/chatbot/update-chat-name/$chatId');
    String? accessToken = await _storage.read(key: 'access_token');

    // Headers for the HTTP request with Bearer token
    final Map<String, String> headers = {
      "Content-Type": "application/json",
      "Authorization": "Bearer $accessToken", // Add the Bearer token
    };

    // Request body
    final Map<String, String> body = {
      "newChatName": chatName,
    };

    return http.put(
      url,
      headers: headers,
      body: jsonEncode(body),
    );
  }

  Future<http.Response> deleteChat(String chatId) async {
    final Uri url = Uri.parse('${baseUrl}api/chatbot/delete-chat/$chatId');
    String? accessToken = await _storage.read(key: 'access_token');

    // Headers for the HTTP request with Bearer token
    final Map<String, String> headers = {
      "Content-Type": "application/json",
      "Authorization": "Bearer $accessToken", // Add the Bearer token
    };

    return http.delete(url, headers: headers);
  }

  Future<http.Response> uploadProfileImage(File profilePic) async {
    final Uri url = Uri.parse('${baseUrl}api/user/upload-profile-image');
    String? accessToken = await _storage.read(key: 'access_token');

    // Headers for the HTTP request with Bearer token
    final Map<String, String> headers = {
      "Authorization": "Bearer $accessToken", // Add the Bearer token
    };

    // Create multipart request to upload image
    var request = http.MultipartRequest('POST', url)..headers.addAll(headers);

    // Check if profile picture exists and is a valid file
    if (profilePic.existsSync()) {
      var picStream = http.ByteStream(profilePic.openRead());
      var picLength = await profilePic.length();

      // Determine the file extension and set the content type accordingly
      String extension =
          profilePic.uri.pathSegments.last.split('.').last.toLowerCase();
      String contentType;

      switch (extension) {
        case 'png':
          contentType = 'image/png';
          break;
        case 'jpg':
        case 'jpeg':
          contentType = 'image/jpeg';
          break;
        default:
          contentType =
              'application/octet-stream'; // Default if type is unknown
          break;
      }

      // Create the multipart file
      var picMultipart = http.MultipartFile(
        'image', // The parameter name expected by the API
        picStream,
        picLength,
        filename: profilePic.uri.pathSegments.last,
        contentType: MediaType.parse(contentType),
      );

      // Add the file to the request
      request.files.add(picMultipart);
    }

    try {
      // Send the request
      final response = await request.send();

      // Convert the response stream to string
      final responseData = await response.stream.bytesToString();

      return http.Response(responseData, response.statusCode);
    } catch (e) {
      print('Error uploading image: $e');
      return http.Response(
          'Error: $e', 500); // Return an error response in case of failure
    }
  }

  Future<http.Response> getUserInformation() async {
    final Uri url = Uri.parse('${baseUrl}api/user/profile');
    String? accessToken = await _storage.read(key: 'access_token');

    // Headers for the HTTP request with Bearer token
    final Map<String, String> headers = {
      "Content-Type": "application/json",
      "Authorization": "Bearer $accessToken", // Add the Bearer token
    };
    return await http.get(
      url,
      headers: headers,
    );
  }

  Future<http.Response> helpAndSupport(String email, String problem) async {
    // Construct the endpoint URL
    final Uri url = Uri.parse('${baseUrl}api/problem/report');

    String? accessToken = await _storage.read(key: 'access_token');

    // Headers for the HTTP request with Bearer token
    final Map<String, String> headers = {
      "Content-Type": "application/json",
      "Authorization": "Bearer $accessToken", // Add the Bearer token
    };

    // Request body
    final Map<String, String> body = {"email": email, "description": problem};

    // Make the POST request
    return await http.post(
      url,
      headers: headers,
      body: jsonEncode(body),
    );
  }

  Future<http.Response> privacy() async {
    // Construct the endpoint URL
    final Uri url = Uri.parse('${baseUrl}api/policy/privacy');

    String? accessToken = await _storage.read(key: 'access_token');

    // Headers for the HTTP request with Bearer token
    final Map<String, String> headers = {
      "Content-Type": "application/json",
      "Authorization": "Bearer $accessToken", // Add the Bearer token
    };

    // Make the POST request
    return await http.get(
      url,
      headers: headers
    );
  }
  Future<http.Response> terms() async {
    // Construct the endpoint URL
    final Uri url = Uri.parse('${baseUrl}api/policy/terms');

    String? accessToken = await _storage.read(key: 'access_token');

    // Headers for the HTTP request with Bearer token
    final Map<String, String> headers = {
      "Content-Type": "application/json",
      "Authorization": "Bearer $accessToken", // Add the Bearer token
    };

    // Make the POST request
    return await http.get(
        url,
        headers: headers
    );
  }
}
