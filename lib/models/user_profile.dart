class UserProfile {
  final String uid;
  final String name;
  final String email;
  final String photoUrl;
  final String loginMethod;
  final DateTime createdAt;
  /// 'user' or 'admin'
  final String role;

  const UserProfile({
    required this.uid,
    required this.name,
    required this.email,
    required this.photoUrl,
    required this.loginMethod,
    required this.createdAt,
    this.role = 'user',
  });

  factory UserProfile.fromMap(Map<String, dynamic> map) {
    return UserProfile(
      uid: map['uid'] as String,
      name: map['name'] as String,
      email: map['email'] as String,
      photoUrl: map['photoUrl'] as String,
      loginMethod: map['loginMethod'] as String,
      role: (map['role'] as String?) ?? 'user',
      createdAt: map['createdAt'] is String
          ? DateTime.parse(map['createdAt'] as String)
          : (map['createdAt'] as DateTime),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'photoUrl': photoUrl,
      'loginMethod': loginMethod,
      'role': role,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
