import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:xapp/providers/PostProvider.dart';
import 'package:xapp/providers/UserProvider.dart';
import 'package:xapp/screens/Auth.dart';
import 'package:xapp/screens/ProfileFeed.dart';
import 'package:xapp/widgets/AuthCTA.dart';

class Profile extends StatefulWidget {
  final String userId;
  final String photoURL;
  final String displayName;
  final String status;
  final String slug;

  const Profile({
    Key key,
    this.userId,
    this.displayName,
    this.status,
    this.slug,
    this.photoURL,
  }) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final ScrollController _scrollController = new ScrollController();

  bool _loading = false;

  UserProvider _userProvider;
  PostProvider _postProvider;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      double maxScroll = _scrollController.position.maxScrollExtent;
      double currentScroll = _scrollController.position.pixels;
      double delta = 50.0;

      if (maxScroll - currentScroll <= delta && !_loading) {
        setState(() => _loading = true);

        _postProvider.profileFeed(widget.userId, true).then((posts) {
          setState(() => _loading = false);
        });
      }
    });

    _userProvider = Provider.of<UserProvider>(context, listen: false);
    _postProvider = Provider.of<PostProvider>(context, listen: false);

    if (_userProvider.isAuthenticated) {
      setState(() => _loading = true);

      _postProvider
          .profileFeed(widget.userId, _userProvider.isAuthenticated)
          .then(
            (posts) => setState(() => _loading = false),
          );
    }
  }

  @override
  void dispose() {
    _postProvider.disposeProfileFeed();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            controller: _scrollController,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                        bottom: 10.0,
                      ),
                      child: Hero(
                        tag: widget.userId,
                        child: CircleAvatar(
                          backgroundImage: NetworkImage(widget.photoURL),
                          radius: 70,
                        ),
                      ),
                    ),
                    Text(
                      widget.displayName,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headline3,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        bottom: 15.0,
                      ),
                      child: Text(
                        '@${widget.slug}',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.headline6.copyWith(
                              fontStyle: FontStyle.italic,
                            ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20.0,
                      ),
                      child: Text(
                        (widget.status ?? '').toUpperCase(),
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                    ),
                  ],
                ),
                Visibility(
                  visible: !_userProvider.isAuthenticated,
                  child: Padding(
                    padding: const EdgeInsets.only(
                      top: 50.0,
                    ),
                    child: AuthCTA(
                      onPressed: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Auth(),
                          ),
                        );

                        setState(() => print('Refreshing view...'));
                      },
                    ),
                  ),
                ),
                Visibility(
                  visible: _userProvider.isAuthenticated,
                  child: Padding(
                    padding: const EdgeInsets.only(
                      top: 50.0,
                      left: 5.0,
                      right: 5.0,
                      bottom: 5.0,
                    ),
                    child: GridView(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 2,
                        mainAxisSpacing: 2,
                        childAspectRatio: .7,
                      ),
                      children: _postProvider.listProfilePosts
                          .asMap()
                          .entries
                          .map<Widget>(
                        (post) {
                          return GestureDetector(
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ProfileFeed(
                                  userId: widget.userId,
                                  index: post.key,
                                  photoURL: widget.photoURL,
                                ),
                              ),
                            ),
                            child: Hero(
                              tag: post.value.id,
                              child: Image(
                                image: NetworkImage(post.value.imageURL),
                                fit: BoxFit.cover,
                              ),
                            ),
                          );
                        },
                      ).toList(),
                    ),
                  ),
                ),
                Visibility(
                  visible: _loading,
                  child: Padding(
                    padding: const EdgeInsets.all(30.0),
                    child: Container(
                      child: Center(
                        child: Text('Loading..'),
                      ),
                    ),
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
