class User {
  const User({
    required this.id,
    required this.name,
    required this.email,
    required this.token,
  });

  final String id;
  final String name;
  final String email;
  final String token;

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['user']['id'] as String? ?? json['id'] as String,
      name: json['user']['name'] as String? ?? json['name'] as String,
      email: json['user']['email'] as String? ?? json['email'] as String,
      token: json['token'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'token': token,
      'user': {
        'id': id,
        'name': name,
        'email': email,
      },
    };
  }
}


