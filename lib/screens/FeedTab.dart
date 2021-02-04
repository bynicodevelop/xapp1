import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:xapp/providers/PostProvider.dart';
import 'package:xapp/providers/UserProvider.dart';
import 'package:xapp/screens/Auth.dart';
import 'package:xapp/screens/Profile.dart';
import 'package:xapp/widgets/AvatarBtn.dart';
import 'package:xapp/widgets/ImageView.dart';
import 'package:xapp/widgets/LikeButton.dart';

class FeedTab extends StatefulWidget {
  FeedTab({Key key}) : super(key: key);

  @override
  _FeedTabState createState() => _FeedTabState();
}

class _FeedTabState extends State<FeedTab> {
  UserProvider _userProvider;
  PostProvider _postProvider;

  bool _loading = false;

  int _increment;

  NetworkImage _nextAvatar;
  NetworkImage _nextImage;

  // rendre générique comme profilefeed
  void postHasLiked(int increment) {
    if (_userProvider.isAuthenticated) {
      _postProvider.listFeedPosts[increment].toggleHasLikes(
        isLiked: _userProvider
            .postHasLiked(_postProvider.listFeedPosts[increment].id),
      );
    }
  }

  @override
  void initState() {
    super.initState();

    setState(() {
      _increment = 0;
      _loading = true;
    });

    _userProvider = Provider.of<UserProvider>(context, listen: false);
    _postProvider = Provider.of<PostProvider>(context, listen: false);

    _postProvider.userProvider = _userProvider;

    _postProvider
        .feed(
      userId: _userProvider.userModel?.uid ?? null,
    )
        .then((_) {
      setState(() => _loading = false);

      _nextAvatar =
          NetworkImage(_postProvider.listFeedPosts[_increment + 1].photoURL);
      _nextImage =
          NetworkImage(_postProvider.listFeedPosts[_increment + 1].imageURL);

      postHasLiked(_increment);

      precacheImage(_nextAvatar, context);
      precacheImage(_nextImage, context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _loading
          ? Container(
              child: Center(
                child: Text('Loading...'),
              ),
            )
          : Stack(
              children: [
                ImageView(
                  onTapDown: (details) async {
                    if (details.globalPosition.dx >
                        MediaQuery.of(context).size.width / 2) {
                      _increment++;

                      if (_increment ==
                          _postProvider.listFeedPosts.length - 1) {
                        await _postProvider.feed(
                          userId: _userProvider.userModel?.uid ?? null,
                        );
                      }

                      if (_increment > _postProvider.listFeedPosts.length - 1) {
                        _increment = 0;
                      }

                      if (_postProvider.listFeedPosts.length > _increment + 1) {
                        _nextAvatar = NetworkImage(_postProvider
                            .listFeedPosts[_increment + 1].photoURL);
                        _nextImage = NetworkImage(_postProvider
                            .listFeedPosts[_increment + 1].imageURL);

                        precacheImage(_nextAvatar, context);
                        precacheImage(_nextImage, context);
                      }

                      postHasLiked(_increment);

                      setState(() => _increment);
                    } else {
                      if (_increment > 0) {
                        _increment--;

                        if (_postProvider.listFeedPosts.length >
                            _increment + 1) {
                          _nextAvatar = NetworkImage(_postProvider
                              .listFeedPosts[_increment + 1].photoURL);
                          _nextImage = NetworkImage(_postProvider
                              .listFeedPosts[_increment + 1].imageURL);
                        }

                        setState(() => _increment);
                      }
                    }
                  },
                  imageURL: _postProvider.listFeedPosts[_increment].imageURL,
                ),
                Positioned(
                  bottom: 50.0,
                  right: 30.0,
                  child: Column(
                    children: [
                      AvatarBtn(
                        tag: _postProvider.listFeedPosts[_increment].userId,
                        onTap: () async {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Profile(
                                userId: _postProvider
                                    .listFeedPosts[_increment].userId,
                                displayName: _postProvider
                                    .listFeedPosts[_increment].displayName,
                                slug: _postProvider
                                    .listFeedPosts[_increment].slug,
                                status: _postProvider
                                    .listFeedPosts[_increment].status,
                                photoURL: _postProvider
                                    .listFeedPosts[_increment].photoURL,
                              ),
                            ),
                          );

                          postHasLiked(_increment);

                          setState(() => print('Refreshing likes...'));
                        },
                        photoURL:
                            _postProvider.listFeedPosts[_increment].photoURL,
                      ),
                      LikeButton(
                        onTap: () async {
                          if (!_userProvider.isAuthenticated) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Auth(),
                              ),
                            );

                            return;
                          }

                          await _postProvider.like(
                            _postProvider.listFeedPosts[_increment].id,
                            _userProvider.userModel.uid,
                          );

                          setState(() => print('Refreshing likes...'));
                        },
                        hasLiked:
                            _postProvider.listFeedPosts[_increment].hasLiked,
                        likes: _postProvider.listFeedPosts[_increment].likes,
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
