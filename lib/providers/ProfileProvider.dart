import 'package:cloud_functions/cloud_functions.dart';

class ProfileProvider {
  HttpsCallable _profile = FirebaseFunctions.instance.httpsCallable('profile');

  Future<dynamic> load(String userId) {
    return _profile.call({
      'userId': userId,
    });
  }
}
