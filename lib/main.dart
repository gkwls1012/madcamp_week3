import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:untitled/responsive/responsive_layout_screen.dart';
import 'package:untitled/screens/login_screen.dart';
import 'package:untitled/utils/colors.dart';
import 'package:untitled/responsive/mobile_screen_layout.dart';
import 'package:untitled/responsive/web_screen_layout.dart';
import 'package:untitled/screens/signup_screen.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  if(kIsWeb){
    await Firebase.initializeApp(
      options: FirebaseOptions(
        apiKey: 'AIzaSyAKpvAA3qQaVFNWTBXo4_Y11Cd5vWqK9kw',
        appId: '1:1009302793012:web:ebd9e1fad59aac16e39361',
        messagingSenderId: '1009302793012',
        projectId: 'chatapp-404f3',
        storageBucket: "chatapp-404f3.appspot.com",)
    );
  } else{
    await Firebase.initializeApp();
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Instagram Clone',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: mobileBackgroundColor,
      ),

      home: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot){
          if(snapshot.connectionState == ConnectionState.active){
            if(snapshot.hasData){
              return const ResponsiveLayout(
                    mobileScreenLayout: MobileScreenLayout(),
                    webScreenLayout: WebScreenLayout(),
              );
            }else if (snapshot.hasError){
              return Center(child: Text('${snapshot.error}'));
            }
          }
          if(snapshot.connectionState == ConnectionState.waiting){
            return Center(
              child: CircularProgressIndicator(
                color: primaryColor,
              )
            );
          }

          return const LoginScreen();

        },
      )
    );
  }
}
