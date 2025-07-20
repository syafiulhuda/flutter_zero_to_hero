class Users {
  final int id;
  final String name;
  final String email;

  Users({required this.id, required this.name, required this.email});

  factory Users.fromJson(Map<String, dynamic> json) {
    return Users(
      id:
          json['id'] is int
              ? json['id']
              : int.tryParse(json['id'].toString()) ?? 0,
      name: json['name'] ?? '',
      email: json['email'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {'id': id, 'name': name, 'email': email};
}
