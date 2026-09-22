class User {
  final String name, email;
  User(this.name, this.email);

  // Factory constructor: takes a JSON Map and returns a User instance
  factory User.fromJson(Map<String, dynamic> json) {
    return User(json['name'], json['email']);
  }
}

Future<List<User>> fetchUsers() async {
  // Simulated JSON response (in real apps this comes from http.get(...))
  final jsonList = [
    {'name': 'An', 'email': 'an@mail.com'},
    {'name': 'Binh', 'email': 'binh@mail.com'},
  ];

  await Future.delayed(Duration(milliseconds: 300)); // simulate network delay

  return jsonList.map((j) => User.fromJson(j)).toList();
}

void main() async {
  final users = await fetchUsers();
  for (var u in users) {
    print('${u.name} - ${u.email}');
  }
}