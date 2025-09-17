class UserModel {
  final String uid;
  final String email;
  final String name;
  final bool isEmailVerified;
  final DateTime createdAt;

  UserModel({
    required this.uid,
    required this.email,
    required this.name,
    required this.isEmailVerified,
    required this.createdAt,
  });

  factory UserModel.fromFirestore(Map<String, dynamic> data, String uid) {
    return UserModel(
      uid: uid,
      email: data['email'] ?? '',
      name: data['name'] ?? '',
      isEmailVerified: data['isEmailVerified'] ?? false,
      createdAt: DateTime.fromMillisecondsSinceEpoch(
        data['createdAt']?.millisecondsSinceEpoch ?? 0,
      ),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'email': email,
      'name': name,
      'isEmailVerified': isEmailVerified,
      'createdAt': createdAt,
    };
  }
}