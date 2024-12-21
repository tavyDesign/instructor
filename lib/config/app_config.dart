class AppConfig {
  static const String baseApiUrl = 'https://examendrpciv.ro/instructor/api/v1';
  static const int connectTimeout = 30000;
  static const int receiveTimeout = 30000;

  // API endpoints
  static const String loginEndpoint = '/user/login/';

  // SharedPreferences keys
  static const String userKey = 'user_data';
  static const String tokenKey = 'access_token';
  static const String refreshTokenKey = 'refresh_token';
}
