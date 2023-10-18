class OurUser {
  final String username;
  final String email;
  final String uid;
  final String photoUrl;
  final String bio;

  const OurUser(
      {required this.username,
      required this.email,
      required this.uid,
      required this.photoUrl,
      required this.bio});

  Map<String, dynamic> toJson() => {
        "username": username,
        "uid": uid,
        "email": email,
        "photoUrl": photoUrl,
        "bio": bio,
      };
}
