class User {
  int id;
  String name;
  // TODO 1: nullable variable
  String? email;

  // Constructor
  User({required this.id, required this.name, this.email});

  // TODO 2: factory constructor parsing JSON
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as int,
      name: (json['name'] as String?) ?? 'Khách', // fallback if missing/null
      email: json['email'] as String?, // may stay null
    );
  }

  void showProfile() {
    // TODO 3: ?? handles null email
    print('ID: $id | Tên: $name | Email: ${email ?? 'Chưa cập nhật'}');
  }
}

void main() {
  // Simulated JSON data returned from an API
  Map<String, dynamic> rawData1 = {"id": 1, "name": "Nam", "email": "nam@fpt.edu.vn"};
  Map<String, dynamic> rawData2 = {"id": 2, "name": null, "email": null};

  // TODO 4: create users from JSON and print their profiles
  final user1 = User.fromJson(rawData1);
  final user2 = User.fromJson(rawData2);

  user1.showProfile();
  user2.showProfile();
}