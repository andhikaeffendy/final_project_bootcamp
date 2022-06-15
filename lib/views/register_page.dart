import 'package:final_project_bootcamp/constant/r.dart';
import 'package:final_project_bootcamp/helpers/preference_helper.dart';
import 'package:final_project_bootcamp/helpers/users_email.dart';
import 'package:final_project_bootcamp/models/network_response.dart';
import 'package:final_project_bootcamp/models/users_by_email_response.dart';
import 'package:final_project_bootcamp/repository/auth_api.dart';
import 'package:final_project_bootcamp/views/main_page.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);
  static String route = "register_page";

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

enum Gender { lakilaki, perempuan }

class _RegisterPageState extends State<RegisterPage> {
  List<String> listClass = ["10", "11", "12"];

  String gender = "Laki-laki";
  String _selectedClass = "10";
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _sekolahController = TextEditingController();

  onTapGender(Gender genderInput) {
    if (genderInput == Gender.lakilaki) {
      gender = "laki-laki";
    } else {
      gender = "perempuan";
    }
    setState(() {});
  }

  initDataUser() {
    _emailController.text = UserEmail.getUserEmail()!;
    _nameController.text = UserEmail.getUserDisplayName()!;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    initDataUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F3F5),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight + 20),
        child: AppBar(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(12),
            bottomRight: Radius.circular(12),
          )),
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 0,
          title: Text(
            "Yuk isi data diri",
            style: R.appStyle.appbarStyle,
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: R.globalWidget.buttonLogin(
              context: context,
              borderSide: R.colors.primary,
              widget: Text(
                R.strings.buttonDaftar,
                style: R.appStyle.buttonWhiteStyle,
              ),
              primary: R.colors.primary,
              ontap: () async {
                final json = {
                  "email": _emailController.text,
                  "nama_lengkap": _nameController.text,
                  "nama_sekolah": _sekolahController.text,
                  "kelas": _selectedClass,
                  "gender": gender,
                  "foto": UserEmail.getUserPhotoUrl()
                };
                print(json);
                final result = await AuthApi().postRegister(json);
                if (result.status == Status.succes) {
                  final registerResult =
                      UserByEmailResponse.fromJson(result.data!);
                  if (registerResult.status == 1) {
                    await PreferenceHelper().setUserData(registerResult.data!);
                    Navigator.of(context).pushNamedAndRemoveUntil(
                        MainPage.route, (context) => false);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(registerResult.message!)));
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content:
                          Text("Terjadi kesalahan, silahkan diulang kembali")));
                }
              }),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          color: R.colors.grey,
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              R.globalWidget.registerTextField(
                  textEditingController: _emailController,
                  hintText: "Email",
                  title: R.strings.emailLabel,
                  enable: true),
              const SizedBox(
                height: 24,
              ),
              R.globalWidget.registerTextField(
                textEditingController: _nameController,
                hintText: "contoh: Andhika Effendy",
                title: R.strings.nameLabel,
              ),
              const SizedBox(
                height: 24,
              ),
              Text(
                R.strings.jenisKelaminLabel,
                style: R.appStyle.labelStyle,
              ),
              const SizedBox(
                height: 6,
              ),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            elevation: 0,
                            primary: gender == "perempuan"
                                ? Colors.white
                                : R.colors.primary,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                                side: BorderSide(
                                    color: R.colors.borderSideButtonColor))),
                        onPressed: () {
                          onTapGender(Gender.lakilaki);
                        },
                        child: Text(
                          "Laki-laki",
                          style: gender == "perempuan"
                              ? R.appStyle.buttonBlackStyle
                              : R.appStyle.buttonWhiteStyle,
                        )),
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  Expanded(
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            elevation: 0,
                            primary: gender == "perempuan"
                                ? R.colors.primary
                                : Colors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                                side: BorderSide(
                                    color: R.colors.borderSideButtonColor))),
                        onPressed: () {
                          onTapGender(Gender.perempuan);
                        },
                        child: Text(
                          "Perempuan",
                          style: gender == "perempuan"
                              ? R.appStyle.buttonWhiteStyle
                              : R.appStyle.buttonBlackStyle,
                        )),
                  ),
                ],
              ),
              const SizedBox(
                height: 24,
              ),
              Text(
                R.strings.kelasLabel,
                style: R.appStyle.labelStyle,
              ),
              const SizedBox(
                height: 4,
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.white,
                    border: Border.all(color: R.colors.borderFieldColor)),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                      isExpanded: true,
                      value: _selectedClass,
                      items: listClass
                          .map((e) => DropdownMenuItem<String>(
                                child: Text(e),
                                value: e,
                              ))
                          .toList(),
                      onChanged: (String? val) {
                        _selectedClass = val!;
                        setState(() {});
                      }),
                ),
              ),
              const SizedBox(
                height: 22,
              ),
              R.globalWidget.registerTextField(
                  textEditingController: _sekolahController,
                  title: R.strings.namaSekolahLabel,
                  hintText: "nama sekolah"),
            ],
          ),
        ),
      ),
    );
  }
}
