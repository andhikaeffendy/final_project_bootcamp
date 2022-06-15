import 'dart:async';
import 'package:final_project_bootcamp/constant/r.dart';
import 'package:final_project_bootcamp/models/network_response.dart';
import 'package:final_project_bootcamp/repository/auth_api.dart';
import 'package:final_project_bootcamp/helpers/users_email.dart';
import 'package:final_project_bootcamp/models/users_by_email_response.dart';
import 'package:final_project_bootcamp/views/login_page.dart';
import 'package:final_project_bootcamp/views/main_page.dart';
import 'package:final_project_bootcamp/views/register_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  static const String route = "/";
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    Timer(const Duration(seconds: 5), () async {
      final user = UserEmail.getUserEmail();

      if (user != null) {
        final dataUser = await AuthApi().getUserByEmail();
        if (dataUser.status == Status.succes) {
          final data = UserByEmailResponse.fromJson(dataUser.data!);
          if (data.status == 1) {
            Navigator.of(context).pushReplacementNamed(MainPage.route);
          } else {
            Navigator.of(context).pushReplacementNamed(RegisterPage.route);
          }
        }
      } else {
        Navigator.of(context).pushReplacementNamed(LoginPage.route);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: R.colors.primary,
      body: Center(
        child: Image.asset(
          R.assets.icSplash,
          width: MediaQuery.of(context).size.width * 0.5,
        ),
      ),
    );
  }
}
