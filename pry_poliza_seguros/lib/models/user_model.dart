class User {
  final String email;
  final String password;
  final String? token;

  User({
    required this.email,
    required this.password,
    this.token,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        email: json['email'],
        password: json['password'],
        token: json['token'],
      );

  Map<String, dynamic> toJson() => {
        'email': email,
        'password': password,
        if (token != null) 'token': token,
      };
}
