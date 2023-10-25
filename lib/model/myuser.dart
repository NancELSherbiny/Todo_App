class MyUser {
  static const String collectionName = 'users';
  String? id;
  String? email;
  String? name;

  MyUser({required this.id, required this.email, required this.name});

  MyUser.fromFireStore(Map<String, dynamic> data)
      : this(id: data['id'], email: data['email'], name: data['name']);

  Map<String, dynamic> toFireStore() {
    return {'id': id, 'name': name, 'email': email};
  }
}
