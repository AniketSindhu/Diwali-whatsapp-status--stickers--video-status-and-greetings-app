import 'package:festive_app/pages/homepage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // Create the initialization Future outside of `build`:
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      // Initialize FlutterFire:
      future: _initialization,
      builder: (context, snapshot) {
        // Check for errors
       if (snapshot.hasError) {                      
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          home:Scaffold(
            backgroundColor: Colors.white,
            body: Center(
            child:Column(
              children: [
                Text('Error',style: TextStyle(color:Colors.red,fontSize: 24, fontWeight: FontWeight.bold,)),
                SizedBox(height:20),
                Text('Check your internet and try again',style: TextStyle(color:Colors.black,fontSize: 18, fontWeight: FontWeight.w600,)),
              ],
            ),
            ),
          )
        );
       }
     
        // Once complete, show your application
        if (snapshot.connectionState == ConnectionState.done) {
          return MaterialApp(
            home:Homepage(),
            debugShowCheckedModeBanner: false,
          );
        }
        // Otherwise, show something whilst waiting for initialization to complete
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          home:Scaffold(
            body: Center(
            child:CircularProgressIndicator(),
            ),
          )
        );
      },
    );
  }
}

