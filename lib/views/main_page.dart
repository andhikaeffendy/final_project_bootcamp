import 'package:final_project_bootcamp/constant/r.dart';
import 'package:final_project_bootcamp/views/main/discussion/chat_screen.dart';
import 'package:final_project_bootcamp/views/main/latihan_soal/home_page.dart';
import 'package:final_project_bootcamp/views/main/profile/profile_screen.dart';
import 'package:flutter/material.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);
  static String route = "main_page";

  @override
  State<MainPage> createState() => _MainPageState();
}

final _pageController = PageController();
int index = 0;

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushNamed(ChatScreen.route);
        },
        child: Image.asset(
          R.assets.icDiskus,
          width: 30,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: _bottomAppBar(),
      body: PageView(
        controller: _pageController,
        physics: NeverScrollableScrollPhysics(),
        children: [HomePage(), ChatScreen(), ProfileScreen()],
      ),
    );
  }

  Container _bottomAppBar() {
    return Container(
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(
            offset: const Offset(0, 4),
            blurRadius: 4.0,
            color: Colors.black.withOpacity(0.86))
      ]),
      child: BottomAppBar(
        color: Colors.white,
        child: SizedBox(
          height: 60,
          child: Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Material(
                    child: InkWell(
                      onTap: () {
                        index = 0;
                        _pageController.animateToPage(index,
                            duration: const Duration(milliseconds: 500),
                            curve: Curves.easeIn);
                        setState(() {});
                      },
                      child: Column(
                        children: [
                          Image.asset(
                            R.assets.icHome,
                            height: 20,
                            width: 20,
                          ),
                          const SizedBox(
                            height: 2,
                          ),
                          Text(
                            R.strings.bottomHomeLabel,
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Material(
                    child: InkWell(
                      onTap: () {
                        index = 1;
                        _pageController.animateToPage(index,
                            duration: const Duration(milliseconds: 500),
                            curve: Curves.easeIn);
                        setState(() {});
                      },
                      child: Column(
                        children: [
                          Image.asset(
                            R.assets.icHome,
                            height: 20,
                            width: 20,
                          ),
                          const SizedBox(
                            height: 2,
                          ),
                          Text(
                            R.strings.bottomDiskusLabel,
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Material(
                    child: InkWell(
                      onTap: () {
                        index = 2;
                        _pageController.animateToPage(index,
                            duration: const Duration(milliseconds: 500),
                            curve: Curves.easeIn);
                        setState(() {});
                      },
                      child: Column(
                        children: [
                          const Icon(
                            Icons.person,
                            size: 20,
                          ),
                          const SizedBox(
                            height: 2,
                          ),
                          Text(
                            R.strings.bottomProfileLabel,
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
