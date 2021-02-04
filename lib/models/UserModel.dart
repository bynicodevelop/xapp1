class UserModel {
  final String uid;
  final String email;
  final String displayName;
  final String slug;
  final String status;
  final String photoURL;
  List<dynamic> likes = List<dynamic>();

  UserModel({
    this.uid,
    this.email,
    this.displayName,
    this.slug,
    this.status,
    this.photoURL,
    this.likes,
  });

  set updateLikes(List<dynamic> value) => likes = value;

  Map<String, dynamic> toJson() => {
        'uid': uid,
        'email': email,
        'displayName': displayName,
        'slug': slug,
        'status': status,
        'photoURL': photoURL,
        'likes': likes
      };
}
