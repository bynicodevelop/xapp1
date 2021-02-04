import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:xapp/models/PostModel.dart';
import 'package:xapp/providers/PostProvider.dart';
import 'package:xapp/providers/UserProvider.dart';
import 'package:xapp/widgets/AvatarBtn.dart';
import 'package:xapp/widgets/ImageView.dart';
import 'package:xapp/widgets/LikeButton.dart';

class ProfileFeed extends StatefulWidget {
  final String userId;
  final String photoURL;
  final int index;

  const ProfileFeed({
    Key key,
    this.userId,
    this.photoURL,
    this.index,
  }) : super(key: key);

  @override
  _ProfileFeedState createState() => _ProfileFeedState();
}

class _ProfileFeedState extends State<ProfileFeed> {
  PostProvider _postProvider;
  UserProvider _userProvider;

  int _increment;

  void postHasLiked(
    int increment,
    List<PostModel> list,
    bool isAuthenticated,
  ) {
    if (isAuthenticated) {
      list[increment].toggleHasLikes(
        isLiked: _userProvider.postHasLiked(list[increment].id),
      );
    }
  }

  @override
  void initState() {
    super.initState();

    setState(() => _increment = widget.index);

    _userProvider = Provider.of<UserProvider>(context, listen: false);
    _postProvider = Provider.of<PostProvider>(context, listen: false);

    _postProvider.userProvider = _userProvider;

    postHasLiked(
      _increment,
      _postProvider.listProfilePosts,
      _userProvider.isAuthenticated,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Stack(
        children: [
          ImageView(
            tag: _postProvider.listProfilePosts[_increment].id,
            onTapDown: (details) async {
              if (details.globalPosition.dx >
                  MediaQuery.of(context).size.width / 2) {
                _increment++;

                if (_increment == _postProvider.listProfilePosts.length - 1) {
                  await _postProvider.profileFeed(widget.userId, true);
                }

                if (_increment >= _postProvider.listProfilePosts.length) {
                  Navigator.pop(context);
                  return;
                }

                setState(() => _increment);

                if ((_increment + 1) < _postProvider.listProfilePosts.length) {
                  precacheImage(
                    NetworkImage(
                      _postProvider.listProfilePosts[_increment + 1].imageURL,
                    ),
                    context,
                  );
                }

                postHasLiked(
                  _increment,
                  _postProvider.listProfilePosts,
                  _userProvider.isAuthenticated,
                );
              } else {
                _increment--;

                if (_increment < 0) {
                  Navigator.pop(context);
                  return;
                }

                setState(() => _increment);
              }
            },
            imageURL: _postProvider.listProfilePosts[_increment].imageURL,
          ),
          Positioned(
            bottom: 50.0,
            right: 30.0,
            child: Column(
              children: [
                AvatarBtn(
                  onTap: () => Navigator.pop(context),
                  photoURL: widget.photoURL,
                ),
                LikeButton(
                  onTap: () async {
                    await _postProvider.like(
                      _postProvider.listProfilePosts[_increment].id,
                      _userProvider.userModel.uid,
                      from: 'feedProfile',
                    );

                    setState(() => print('Refreshing likes...'));
                  },
                  hasLiked: _postProvider.listProfilePosts[_increment].hasLiked,
                  likes: _postProvider.listProfilePosts[_increment].likes,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
