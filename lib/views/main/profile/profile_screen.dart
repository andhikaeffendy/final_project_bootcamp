import 'package:final_project_bootcamp/constant/r.dart';
import 'package:final_project_bootcamp/helpers/preference_helper.dart';
import 'package:final_project_bootcamp/helpers/users_email.dart';
import 'package:final_project_bootcamp/models/users_by_email_response.dart';
import 'package:final_project_bootcamp/views/login_page.dart';
import 'package:final_project_bootcamp/views/main/profile/edit_profile_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);
  static String route = "profile_screen";

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  UserData? user;

  getUserData() async {
    final data = await PreferenceHelper().getUserData();
    user = data;
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Akun Saya"),
        elevation: 0,
        centerTitle: true,
        actions: [
          TextButton(
              onPressed: () async {
                final result = await Navigator.of(context)
                    .push(MaterialPageRoute(builder: (BuildContext context) {
                  return EditProfilePage();
                }));
                if (result == true) {
                  getUserData();
                }
              },
              child: Text(
                "Edit",
                style: R.appStyle.buttonWhiteStyle.copyWith(fontSize: 15),
              ))
        ],
      ),
      body: SingleChildScrollView(
        child: user == null
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                        color: R.colors.primary,
                        borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(8),
                            bottomRight: Radius.circular(8))),
                    padding: const EdgeInsets.only(
                        bottom: 60, left: 15, right: 15, top: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              user!.userName!,
                              style: R.appStyle.appbarStyle.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w400),
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            Text(
                              user!.userAsalSekolah!,
                              style: R.appStyle.labelStyle.copyWith(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400),
                            )
                          ],
                        ),
                        Image.asset(
                          R.assets.icAvatar,
                          width: 50,
                          height: 52,
                        )
                      ],
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    margin: const EdgeInsets.symmetric(
                        vertical: 16, horizontal: 16),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 20),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.25),
                            blurRadius: 7,
                          )
                        ]),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Identitas Diri",
                          style: R.appStyle.labelStyle
                              .copyWith(fontWeight: FontWeight.w400),
                        ),
                        const SizedBox(
                          height: 31,
                        ),
                        Text(
                          "Nama Lengkap",
                          style: R.appStyle.hintStyle.copyWith(
                              fontSize: 12, fontWeight: FontWeight.w400),
                        ),
                        Text(
                          user!.userName!,
                          style: R.appStyle.labelStyle.copyWith(
                              fontSize: 13, fontWeight: FontWeight.w400),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Text(
                          "Email",
                          style: R.appStyle.hintStyle.copyWith(
                              fontSize: 12, fontWeight: FontWeight.w400),
                        ),
                        Text(
                          user!.userEmail!,
                          style: R.appStyle.labelStyle.copyWith(
                              fontSize: 13, fontWeight: FontWeight.w400),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Text(
                          "Jenis Kelamin",
                          style: R.appStyle.hintStyle.copyWith(
                              fontSize: 12, fontWeight: FontWeight.w400),
                        ),
                        Text(
                          user!.userGender!,
                          style: R.appStyle.labelStyle.copyWith(
                              fontSize: 13, fontWeight: FontWeight.w400),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Text(
                          "Kelas",
                          style: R.appStyle.hintStyle.copyWith(
                              fontSize: 12, fontWeight: FontWeight.w400),
                        ),
                        Text(
                          user!.jenjang!,
                          style: R.appStyle.labelStyle.copyWith(
                              fontSize: 13, fontWeight: FontWeight.w400),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Text(
                          "Sekolah",
                          style: R.appStyle.hintStyle.copyWith(
                              fontSize: 12, fontWeight: FontWeight.w400),
                        ),
                        Text(
                          user!.userAsalSekolah!,
                          style: R.appStyle.labelStyle.copyWith(
                              fontSize: 13, fontWeight: FontWeight.w400),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                      ],
                    ),
                  ),
                  InkWell(
                    onTap: () async {
                      if (kIsWeb) {
                        await GoogleSignIn(
                                clientId:
                                    "837507298307-vivngoa8sq7gg43nu7o8dlkchspisqn9.apps.googleusercontent.com")
                            .signOut();
                      } else {
                        await GoogleSignIn().signOut();
                      }
                      await FirebaseAuth.instance.signOut();
                      Navigator.of(context).pushNamedAndRemoveUntil(
                          LoginPage.route, (route) => false);
                    },
                    child: Container(
                        padding: const EdgeInsets.all(14),
                        margin: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.25),
                                blurRadius: 7,
                              )
                            ]),
                        child: Row(
                          children: [
                            Image.asset(
                              R.assets.icLogout,
                              width: 20,
                              height: 20,
                            ),
                            SizedBox(
                              width: 7,
                            ),
                            Text(
                              "Keluar",
                              style: R.appStyle.labelStyle.copyWith(
                                  color: Colors.red,
                                  fontWeight: FontWeight.w400),
                            )
                          ],
                        )),
                  )
                ],
              ),
      ),
    );
  }
}
