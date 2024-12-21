class User {
  final int id;
  final String email;
  final String name;
  final String role;
  final String token;

  User({
    required this.id,
    required this.email,
    required this.name,
    required this.role,
    required this.token,
  });

  // Convert a JSON object into a User instance
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      email: json['email'],
      name: json['name'],
      role: json['role'],
      token: json['token'],
    );
  }

  // Convert a User instance into a JSON object
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'role': role,
      'token': token,
    };
  }
}
