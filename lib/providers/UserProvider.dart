import 'dart:async';

import 'package:cloud_functions/cloud_functions.dart';
import 'package:xapp/models/UserModel.dart';

class UserProvider {
  HttpsCallable _userCallable =
      FirebaseFunctions.instance.httpsCallable('user');

  bool _isAuthenticated = false;

  UserModel _userModel;

  UserModel get userModel => _userModel;

  bool get isAuthenticated => _isAuthenticated;

  /**
   * 
   */
  Future<UserModel> init(Map<String, dynamic> user) async {
    Completer completer = Completer();

    if (user != null) {
      _isAuthenticated = true;

      HttpsCallableResult callableResult =
          await _userCallable.call({'userId': user['uid']});

      _userModel = UserModel(
        uid: user['uid'],
        email: user['email'],
        displayName: callableResult.data['displayName'],
        slug: callableResult.data['slug'],
        likes: callableResult.data['likes'],
      );

      print('UserModel - init: ${_userModel.toJson()}');
    }

    completer.complete(_userModel);

    return completer.future;
  }

  /**
   * Permet de mettre à jour la liste des posts likés
   * par l'utilisateur connecté
   */
  void postLikedEvent(String postId) {
    List<dynamic> likes = List<dynamic>.from(_userModel.likes);
    dynamic likeFound =
        likes.firstWhere((like) => like['id'] == postId, orElse: () => null);

    if (likeFound != null) {
      likes.removeWhere((like) => like['id'] == postId);
    } else {
      likes.add({'id': postId});
    }

    _userModel.updateLikes = likes ?? [];
  }

  /**
   * Retourne vrai si le post a été liké
   * 
   * String postId : Le post testé
   */
  bool postHasLiked(String postId) {
    print('Likes: $_userModel');
    dynamic like = _userModel.likes
        .firstWhere((like) => like['id'] == postId, orElse: () => null);

    return like != null;
  }
}
