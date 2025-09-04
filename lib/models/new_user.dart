class NewUser {
  final String username; // The user's display name
  final String email; // The user's email address
  final String phoneNumber; // The user's phone number

  // Constructor for NewUser, requires all fields
  NewUser({
    required this.username,
    required this.email,
    required this.phoneNumber,
  });

  // Converts the NewUser object to a map for storage or transfer
  Map<String, dynamic> toMap() => {
    'username': username,
    'email': email,
    'phoneNumber': phoneNumber,
  };
}
