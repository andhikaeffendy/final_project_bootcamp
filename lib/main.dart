import 'package:final_project_bootcamp/constant/r.dart';
import 'package:final_project_bootcamp/views/login_page.dart';
import 'package:final_project_bootcamp/views/main/discussion/chat_screen.dart';
import 'package:final_project_bootcamp/views/main/latihan_soal/home_page.dart';
import 'package:final_project_bootcamp/views/main/latihan_soal/mapel_page.dart';
import 'package:final_project_bootcamp/views/main/latihan_soal/paket_soal_page.dart';
import 'package:final_project_bootcamp/views/main/profile/profile_screen.dart';
import 'package:final_project_bootcamp/views/main_page.dart';
import 'package:final_project_bootcamp/views/register_page.dart';
import 'package:final_project_bootcamp/views/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();
  print('Handling a background message ${message.messageId}');
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  await Firebase.initializeApp(
      // options: DefaultFirebaseOptions.currentPlatform,
      );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Latihan Soal',
      theme: ThemeData(
        appBarTheme: AppBarTheme(backgroundColor: R.colors.primary),
        textTheme: GoogleFonts.poppinsTextTheme(),
        primarySwatch: Colors.blue,
      ),
      // home: const SplashScreen(),
      initialRoute: "/",
      routes: {
        "/": (context) => const SplashScreen(),
        LoginPage.route: (context) => const LoginPage(),
        RegisterPage.route: (context) => const RegisterPage(),
        MainPage.route: (context) => const MainPage(),
        HomePage.route: (context) => const HomePage(),
        ProfileScreen.route: (context) => const ProfileScreen(),
        ChatScreen.route: (context) => const ChatScreen(),
        // MapelPage.route: (context) => const MapelPage(),
        // PaketSoalPage.route: (context) => const PaketSoalPage(),
      },
    );
  }
}
