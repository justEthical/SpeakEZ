import 'package:http/http.dart' as http;
import 'dart:convert';

class NetworkService {
  static Future<String> getUserCountryFromIP() async {
  final response = await http.get(Uri.parse("https://ipwho.is/"));
  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    print(data);
    return data["country_code"]; // e.g., "IN"
  } else {
    return "Unknown";
  }
}

}
