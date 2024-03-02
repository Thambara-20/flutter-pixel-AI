import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;

class Authenticator {
  static String _apiToken = '';
  static void setApiToken(String token) {
    _apiToken = token;
  }

  static String getApiToken() {
    if (_apiToken.isEmpty) {
      throw Exception('API token is not set. Call setApiToken() first.');
    }
    return _apiToken;
  }
}

Future<Uint8List> imageGenerator(String title) async {

  var api_key = Authenticator.getApiToken();

  var headers = {
    'Authorization':'Bearer $api_key',
    'Content-Type': 'application/json',
  };

  var url = Uri.parse('https://api.edenai.run/v2/image/generation');
  var payload = {
    'providers': 'openai',
    'text': title,
    'resolution': '512x512',
    'fallback_providers': '',
  };

  try {
    print('Generating Image');
    var response = await http.post(
      url,
      headers: headers,
      body: jsonEncode(payload),
    );

    var result = json.decode(response.body);
    print(result['openai']['items'][0]);

    final bytes = base64.decode((result['openai']['items'][0])['image']);
    return bytes;
  } catch (e) {
    print('Error from AI package: $e');
    return Uint8List(0);
  }
}
