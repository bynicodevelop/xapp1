import 'package:flutter/material.dart';
import 'package:flutter_mobile_camera/flutter_mobile_camera.dart';
import 'package:provider/provider.dart';
import 'package:xapp/providers/PostProvider.dart';
import 'package:xapp/providers/StorageProvider.dart';
import 'package:xapp/providers/UserProvider.dart';

class CameraTab extends StatefulWidget {
  const CameraTab({Key key}) : super(key: key);

  @override
  _CameraTabState createState() => _CameraTabState();
}

class _CameraTabState extends State<CameraTab> {
  StorageProvider _storageProvider;
  PostProvider _postProvider;
  UserProvider _userProvider;

  @override
  void initState() {
    super.initState();

    _userProvider = Provider.of<UserProvider>(context, listen: false);
    _postProvider = Provider.of<PostProvider>(context, listen: false);
    _storageProvider = Provider.of<StorageProvider>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return Camera(
      backToLeft: true,
      // Lets go back !
      onBack: () => DefaultTabController.of(context).animateTo(1),
      // When you want to recover the photo to send it to the cloud
      onSend: (imagePath) async {
        String imageURL = '';
        try {
          imageURL = await _storageProvider.uploadToFeed(
              imagePath, _userProvider.userModel.uid);
        } catch (e) {
          // TODO: Gestion du message d'erreur (snackbar ?)
          print(e);
        }

        try {
          if (imageURL != '') {
            await _postProvider.createPost(
              imageURL,
              _userProvider.userModel.uid,
            );

            DefaultTabController.of(context).animateTo(1);
          }
        } catch (e) {
          // TODO: Gestion du message d'erreur (snackbar ?)
          print(e);
        }
      },
      // Capture the photo taking event
      onTakePhoto: (imagePath) => print(imagePath),
    );
  }
}
