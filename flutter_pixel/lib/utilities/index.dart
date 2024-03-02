import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;

enum ImageSize {
  small,
  medium,
  large,
}

String getImagePath(ImageSize size) {
  switch (size) {
    case ImageSize.small:
      return '256x256';
    case ImageSize.medium:
      return '512x512';
    case ImageSize.large:
      return '1024x1024';
    default:
      return '512x512';
  }
}

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

Future<Uint8List> imageGenerator(String title, imageSize) async {
  var apiKey = Authenticator.getApiToken();
  final resolution = getImagePath(imageSize);

  var headers = {
    'Authorization': 'Bearer $apiKey',
    'Content-Type': 'application/json',
  };

  var url = Uri.parse('https://api.edenai.run/v2/image/generation');
  var payload = {
    'providers': 'openai',
    'text': title,
    'resolution': resolution,
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
    final bytes = base64.decode((result['openai']['items'][0])['image']);
    return bytes;
  } catch (e) {
    throw Exception();
  }
}
