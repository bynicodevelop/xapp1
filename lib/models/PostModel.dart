class PostModel {
  final String id;
  final String userId;
  final String slug;
  final String displayName;
  final String status;
  final String photoURL;
  final String imageURL;
  final int createdAt;
  int likes;
  bool hasLiked;

  PostModel({
    this.id,
    this.userId,
    this.photoURL,
    this.slug,
    this.displayName,
    this.status,
    this.imageURL,
    this.likes = 0,
    this.createdAt,
    this.hasLiked = false,
  });

  set updateLikes(int value) => likes = value;

  toggleHasLikes({bool isLiked}) => hasLiked = isLiked ?? !hasLiked;

  Map<String, dynamic> toJson() => {
        'id': id,
        'userId': userId,
        'photoURL': photoURL,
        'slug': slug,
        'displayName': displayName,
        'status': status,
        'imageURL': imageURL,
        'likes': likes,
        'createdAt': createdAt,
        'hasLiked': hasLiked,
      };
}
