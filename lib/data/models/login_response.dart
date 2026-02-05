class LoginResponse {
  final String token;

  const LoginResponse({required this.token});

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    final token = json['token'] as String?;
    if (token == null || token.isEmpty) {
      throw Exception('Invalid response: token is null or empty');
    }
    return LoginResponse(token: token);
  }
}
