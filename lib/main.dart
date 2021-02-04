import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:xapp/providers/AuthProvider.dart';
import 'package:xapp/providers/FeedProvider.dart';
import 'package:xapp/providers/PostProvider.dart';
import 'package:xapp/providers/ProfileProvider.dart';
import 'package:xapp/providers/StorageProvider.dart';
import 'package:xapp/providers/UserProvider.dart';
import 'package:xapp/screens/CameraTab.dart';
import 'package:xapp/screens/FeedTab.dart';
import 'package:xapp/widgets/Error.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(App());
}

class App extends StatelessWidget {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initialization,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              primarySwatch: Colors.blue,
              visualDensity: VisualDensity.adaptivePlatformDensity,
            ),
            home: Scaffold(
              body: Container(
                child: Center(
                  child: Text('Loading...'),
                ),
              ),
            ),
          );
        }

        if (snapshot.hasError) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              primarySwatch: Colors.blue,
              visualDensity: VisualDensity.adaptivePlatformDensity,
            ),
            home: Error(),
          );
        }

        FirebaseFunctions.instance.useFunctionsEmulator(
          origin: 'http://localhost:5001',
        );

        return MultiProvider(
          providers: [
            Provider<AuthProvider>(
              create: (_) => AuthProvider(),
            ),
            Provider<StorageProvider>(
              create: (_) => StorageProvider(),
            ),
            Provider<UserProvider>(
              create: (_) => UserProvider(),
            ),
            Provider<FeedProvider>(
              create: (_) => FeedProvider(),
            ),
            Provider<PostProvider>(
              create: (_) => PostProvider(),
            ),
            Provider<ProfileProvider>(
              create: (_) => ProfileProvider(),
            )
          ],
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              primarySwatch: Colors.blue,
              visualDensity: VisualDensity.adaptivePlatformDensity,
            ),
            home: Builder(
              builder: (context) => StreamBuilder(
                stream: Provider.of<AuthProvider>(context).user,
                builder: (context, snapshot) {
                  if (snapshot.connectionState != ConnectionState.active) {
                    return Scaffold(
                      body: Container(
                        child: Center(
                          child: Text('Loading...'),
                        ),
                      ),
                    );
                  }

                  // Provider.of<AuthProvider>(context).logout();

                  // Pour le dev
                  if (snapshot.data != null) {
                    snapshot.data['uid'] = 'hJIs8VQXb39B8GAQBd2TFvYlnyyk';
                  }

                  return FutureBuilder(
                      future: Provider.of<UserProvider>(context)
                          .init(snapshot.data),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState != ConnectionState.done) {
                          return Scaffold(
                            body: Container(
                              child: Center(
                                child: Text('Loading...'),
                              ),
                            ),
                          );
                        }

                        return DefaultTabController(
                          length: 2,
                          initialIndex: 1,
                          child: TabBarView(
                            children: [
                              CameraTab(),
                              FeedTab(),
                            ],
                          ),
                        );
                      });
                },
              ),
            ),
          ),
        );
      },
    );
  }
}
