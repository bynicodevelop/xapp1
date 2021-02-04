import 'dart:async';

import 'package:cloud_functions/cloud_functions.dart';
import 'package:xapp/models/PostModel.dart';
import 'package:xapp/providers/UserProvider.dart';

class PostProvider {
  UserProvider _userProvider;

  final List<PostModel> _listFeedPosts = List<PostModel>();
  final List<PostModel> _listProfilePosts = List<PostModel>();

  final HttpsCallable _likeCallable =
      FirebaseFunctions.instance.httpsCallable('like');

  final HttpsCallable _feedCallable =
      FirebaseFunctions.instance.httpsCallable('feed');

  final HttpsCallable _profilePostsCallable =
      FirebaseFunctions.instance.httpsCallable('profilePosts');

  final HttpsCallable _createPostCallable =
      FirebaseFunctions.instance.httpsCallable('createPost');

  String _lastFeedId;
  String _lastProfilePostRef;

  set userProvider(UserProvider value) => _userProvider = value;

  List<PostModel> get listFeedPosts => _listFeedPosts;
  List<PostModel> get listProfilePosts => _listProfilePosts;

  PostModel _setPostModel(Map<dynamic, dynamic> post) => PostModel(
        id: post['id'],
        imageURL: post['imageURL'],
        likes: post['likes'] ?? 0,
        userId: post['userId'],
        displayName: post['displayName'],
        photoURL: post['photoURL'],
        slug: post['slug'],
        status: post['status'] ?? '',
        hasLiked: post['hasLiked'],
      );

  /**
   * Charge le feed principal
   */
  Future<void> feed({String userId}) async {
    Completer completer = Completer();

    HttpsCallableResult callableResult = await _feedCallable.call({
      'lastId': _lastFeedId,
      'userId': userId,
    });

    callableResult.data.forEach(
      (post) => _listFeedPosts.add(_setPostModel(post)),
    );

    _lastFeedId = _listFeedPosts.last.id;

    completer.complete(true);

    return completer.future;
  }

  /**
   * Charge le feed d'un profile
   */
  Future<List<PostModel>> profileFeed(
      String userId, bool isAuthenticated) async {
    print(_lastProfilePostRef);

    HttpsCallableResult<dynamic> posts = await _profilePostsCallable.call({
      'userId': userId,
      'isAuthenticated': isAuthenticated,
      'lastPostRef': _lastProfilePostRef,
    });

    if (posts.data.length == 0) {
      return [];
    }

    List<PostModel> listPostModel = List<PostModel>.from(
      posts.data.map(
        (post) {
          final PostModel postModel = _setPostModel(post);

          _listProfilePosts.add(postModel);

          return postModel;
        },
      ).toList(),
    );

    _lastProfilePostRef = List<dynamic>.from(posts.data).last['id'];

    return listPostModel;
  }

  Future like(String postId, String userId, {String from = 'feed'}) async {
    HttpsCallableResult callableResult = await _likeCallable.call({
      'postId': postId,
      'userId': userId,
    });

    // Mise à jour des posts likés dans le profil connecté
    _userProvider.postLikedEvent(postId);

    if (from == 'feed') {
      // Permet de récupérer le post qui a été liké
      PostModel postModel = _listFeedPosts.firstWhere(
        (el) => el.id == postId,
        orElse: () => null,
      );

      // Si le post a été trouvé
      if (postModel != null) {
        postModel.updateLikes = callableResult.data['likes'];
        postModel.toggleHasLikes();
      }
    } else {
      PostModel postModel = _listProfilePosts.firstWhere(
        (el) => el.id == postId,
        orElse: () => null,
      );

      // Si le post a été trouvé
      if (postModel != null) {
        postModel.updateLikes = callableResult.data['likes'];
        postModel.toggleHasLikes();
      }
    }
  }

  Future createPost(String imageURL, String userId) async {
    HttpsCallableResult callableResult = await _createPostCallable.call({
      'imageURL': imageURL,
      'userId': userId,
    });

    print(callableResult.data);
  }

  void disposeProfileFeed() {
    print('Clear profile posts');

    _lastProfilePostRef = null;
    _listProfilePosts.clear();
  }
}
