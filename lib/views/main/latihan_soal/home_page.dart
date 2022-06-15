import 'package:final_project_bootcamp/constant/r.dart';
import 'package:final_project_bootcamp/main.dart';
import 'package:final_project_bootcamp/models/banner_response.dart';
import 'package:final_project_bootcamp/models/mapel_response.dart';
import 'package:final_project_bootcamp/models/network_response.dart';
import 'package:final_project_bootcamp/repository/latihan_soal_api.dart';
import 'package:final_project_bootcamp/views/main/latihan_soal/mapel_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);
  static String route = "home_page";

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  MapelResponse? _mapelResponse;
  BannerResponse? _bannerResponse;

  getMapel() async {
    final mapelResult = await LatihanSoalApi().getMapel();
    if (mapelResult.status == Status.succes) {
      _mapelResponse = MapelResponse.fromJson(mapelResult.data!);
      setState(() {});
    }
  }

  getBanner() async {
    final bannerResult = await LatihanSoalApi().getBanner();
    if (bannerResult.status == Status.succes) {
      _bannerResponse = BannerResponse.fromJson(bannerResult.data!);
      setState(() {});
    }
  }

  setupFcm() async {
    // Get any messages which caused the application to open from
    // a terminated state.
    final tokenFcm = await FirebaseMessaging.instance.getToken();
    print("token FCM: $tokenFcm");
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();

    // If the message also contains a data property with a "type" of "chat",
    // navigate to a chat screen
    // if (initialMessage != null) {
    //   _handleMessage(initialMessage);
    // }
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    print('User granted permission: ${settings.authorizationStatus}');
    // Also handle any interaction when the app is in the background via a
    // Stream listener
    FirebaseMessaging.onMessageOpenedApp.listen((event) {});
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Got a message whilst in the foreground!');
      print('Message data: ${message.data}');

      if (message.notification != null) {
        print('Message also contained a notification: ${message.notification}');
      }
    });
  }

  @override
  void initState() {
    super.initState();
    getMapel();
    getBanner();
    setupFcm();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: R.colors.grey,
      body: SafeArea(
        child: ListView(
          children: [
            Column(
              children: [
                _buildHomeUser(),
                _buildHomeBanner(context),
                _buildHomeListMapel(context, _mapelResponse),
                _buildHomeTerbaru()
              ],
            ),
          ],
        ),
      ),
    );
  }

  Column _buildHomeTerbaru() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            "Terbaru",
            style: R.appStyle.labelStyle,
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        _bannerResponse == null
            ? Container(
                height: 70,
                width: double.infinity,
                child: const Center(child: CircularProgressIndicator()),
              )
            : SizedBox(
                height: 150,
                child: ListView.builder(
                    itemCount: _bannerResponse!.data!.length,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      final currentBanner = _bannerResponse!.data![index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.network(
                              currentBanner.eventImage!,
                            )),
                      );
                    }),
              ),
        const SizedBox(
          height: 32,
        )
      ],
    );
  }

  Container _buildHomeListMapel(
      BuildContext context, MapelResponse? listMapel) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                "Pilih Pelajaran",
                style: R.appStyle.appbarStyle,
              ),
              const Spacer(),
              TextButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => MapelPage(mapel: _mapelResponse!),
                    ));
                  },
                  child: Text(
                    "Lihat Semua",
                    style: R.appStyle.hintStyle
                        .copyWith(color: const Color(0XFF3A7FD5), fontSize: 10),
                  ))
            ],
          ),
          listMapel == null
              ? Container(
                  height: 70,
                  width: double.infinity,
                  child: const Center(child: CircularProgressIndicator()),
                )
              : ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount:
                      listMapel.data!.length > 3 ? 3 : listMapel.data!.length,
                  itemBuilder: (context, index) {
                    final currentMapel = listMapel.data![index];
                    return R.globalWidget.mapelWidget(
                      context: context,
                      imageIcon: currentMapel.urlCover!,
                      title: currentMapel.majorName!,
                      subtitle: "Paket latihan soal",
                      progress: MediaQuery.of(context).size.width *
                          ((currentMapel.jumlahDone! /
                                  currentMapel.jumlahMateri!) *
                              100),
                      totalDone: currentMapel.jumlahDone!,
                      totalPaket: currentMapel.jumlahMateri!,
                    );
                  })

          // R.globalWidget.mapelWidget(
          //     context,
          //     R.assets.icAtom,
          //     "Matematika",
          //     "0/50 Paket latihan soal",
          //     MediaQuery.of(context).size.width * 0.4),
          // R.globalWidget.mapelWidget(
          //     context,
          //     R.assets.icAtom,
          //     "Matematika",
          //     "0/50 Paket latihan soal",
          //     MediaQuery.of(context).size.width * 0.4),
          // R.globalWidget.mapelWidget(
          //     context,
          //     R.assets.icAtom,
          //     "Matematika",
          //     "0/50 Paket latihan soal",
          //     MediaQuery.of(context).size.width * 0.4),
        ],
      ),
    );
  }

  Padding _buildHomeUser() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Hi, Andhika",
                    style: R.appStyle.subtitleStyle
                        .copyWith(fontWeight: FontWeight.w600)),
                Text(
                  "Selamat Datang",
                  style: R.appStyle.subtitleStyle,
                )
              ],
            ),
          ),
          Image.asset(
            R.assets.icAvatar,
            width: 35,
            height: 35,
          )
        ],
      ),
    );
  }

  Container _buildHomeBanner(BuildContext context) {
    return Container(
      height: 147,
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20), color: R.colors.primary),
      child: Stack(
        children: [
          Positioned(
            left: 0,
            bottom: 0,
            top: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              width: MediaQuery.of(context).size.width * 0.45,
              child: Text(
                R.strings.latihanSoal,
                style: R.appStyle.bannerStyle,
              ),
            ),
          ),
          Positioned(
            right: 0,
            bottom: 0,
            child: Image.asset(
              R.assets.imgHome,
              width: MediaQuery.of(context).size.width * 0.5,
            ),
          ),
        ],
      ),
    );
  }
}
