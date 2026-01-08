
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiUrls {
  static final apiKey = dotenv.env['API_KEY'];
  static final baseURL = "https://reqres.in";

  /// User
  static const String getUser = '/api/users';
}
