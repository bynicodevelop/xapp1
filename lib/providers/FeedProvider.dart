import 'dart:async';

import 'package:cloud_functions/cloud_functions.dart';
import 'package:xapp/models/PostModel.dart';

class FeedProvider {
  final List<PostModel> _listPosts = List<PostModel>();

  final HttpsCallable _callable =
      FirebaseFunctions.instance.httpsCallable('feed');

  String _lastId;

  List<PostModel> get listPosts => _listPosts;

  Future<void> load() async {
    Completer completer = Completer();

    HttpsCallableResult callableResult =
        await _callable.call({'lastId': _lastId});

    callableResult.data.forEach(
      (post) => _listPosts.add(
        PostModel(
          id: post['id'],
          imageURL: post['imageURL'],
          likes: post['likes'],
          userId: post['userId'],
          displayName: post['displayName'],
          photoURL: post['photoURL'],
          slug: post['slug'],
          status: post['status'],
        ),
      ),
    );

    _lastId = _listPosts.last.id;

    completer.complete(true);

    return completer.future;
  }
}
