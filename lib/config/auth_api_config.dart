class AuthApiConfig{
  static const String authUrl = "/api/auth";
  static const String apiHost = "10.0.2.2";
  static const int apiPort = 8080;
  static const String apiUrl = "$apiHost:$apiPort$authUrl";
}