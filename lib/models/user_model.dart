class AppUser {
  final String uid;
  final String firstName;
  final String lastName;
  final String email;

  AppUser({
    required this.uid,
    required this.firstName,
    required this.lastName,
    required this.email,
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'first_name': firstName,
      'last_name': lastName,
      'email': email,
    };
  }
}
