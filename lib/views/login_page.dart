import 'package:final_project_bootcamp/constant/r.dart';
import 'package:final_project_bootcamp/helpers/preference_helper.dart';
import 'package:final_project_bootcamp/models/network_response.dart';
import 'package:final_project_bootcamp/repository/auth_api.dart';
import 'package:final_project_bootcamp/helpers/users_email.dart';
import 'package:final_project_bootcamp/models/users_by_email_response.dart';
import 'package:final_project_bootcamp/views/main_page.dart';
import 'package:final_project_bootcamp/views/register_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);
  static const String route = "login_screen";

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  Future<UserCredential> signInWithGoogle() async {
    if (kIsWeb) {
      GoogleAuthProvider googleProvider = GoogleAuthProvider();

      googleProvider
          .addScope('https://www.googleapis.com/auth/contacts.readonly');
      googleProvider.setCustomParameters({'login_hint': 'user@example.com'});

      // Once signed in, return the UserCredential
      return await FirebaseAuth.instance.signInWithPopup(googleProvider);
    } else {
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      // Obtain the auth details from the request
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      // Once signed in, return the UserCredential
      return await FirebaseAuth.instance.signInWithCredential(credential);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: R.colors.grey,
      body: Container(
        padding: const EdgeInsets.all(32),
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                R.strings.login,
                style: R.appStyle.appbarStyle,
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Image.asset(R.assets.imgLogin),
            const SizedBox(
              height: 56,
            ),
            Text(
              R.strings.welcome,
              style: R.appStyle.welcomeStyle,
            ),
            Text(
              R.strings.loginDesc,
              textAlign: TextAlign.center,
              style: R.appStyle.greySubtitleStyle,
            ),
            const Spacer(),
            R.globalWidget.buttonLogin(
              context: context,
              ontap: () async {
                await signInWithGoogle();
                final user = UserEmail.getUserEmail();
                if (user != null) {
                  final dataUser = await AuthApi().getUserByEmail();
                  if (dataUser.status == Status.succes) {
                    final data = UserByEmailResponse.fromJson(dataUser.data!);
                    if (data.status == 1) {
                      await PreferenceHelper().setUserData(data.data!);
                      Navigator.of(context).pushNamed(MainPage.route);
                    } else {
                      Navigator.of(context).pushNamed(RegisterPage.route);
                    }
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text("Gagal Masuk"),
                    duration: Duration(seconds: 2),
                  ));
                }
              },
              borderSide: R.colors.primary,
              primary: Colors.white,
              widget: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(R.assets.icGoogle),
                  const SizedBox(
                    width: 12,
                  ),
                  Text(
                    R.strings.loginWithGoogle,
                    style: R.appStyle.buttonBlackStyle,
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 25,
            ),
            R.globalWidget.buttonLogin(
                context: context,
                ontap: () {},
                borderSide: R.colors.blackButton,
                primary: R.colors.blackButton,
                widget: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(R.assets.icApple),
                    const SizedBox(
                      width: 12,
                    ),
                    Text(
                      R.strings.loginWithApple,
                      style: R.appStyle.buttonWhiteStyle,
                    ),
                  ],
                ))
          ],
        ),
      ),
    );
  }
}
