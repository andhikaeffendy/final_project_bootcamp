import 'package:final_project_bootcamp/constant/r.dart';
import 'package:final_project_bootcamp/models/network_response.dart';
import 'package:final_project_bootcamp/models/paket_soal_response.dart';
import 'package:final_project_bootcamp/repository/latihan_soal_api.dart';
import 'package:final_project_bootcamp/views/main/latihan_soal/kerjakan_latihan_soal_screen.dart';
import 'package:flutter/material.dart';

class PaketSoalPage extends StatefulWidget {
  const PaketSoalPage({Key? key, required this.id}) : super(key: key);
  static String route = "pake_soal_page";
  final String id;

  @override
  State<PaketSoalPage> createState() => _PaketSoalPageState();
}

class _PaketSoalPageState extends State<PaketSoalPage> {
  PaketSoalResponse? paketSoalResponse;
  getPaketSoal() async {
    final paketResult = await LatihanSoalApi().getPaketSoal(widget.id);
    if (paketResult.status == Status.succes) {
      paketSoalResponse = PaketSoalResponse.fromJson(paketResult.data!);
      setState(() {});
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPaketSoal();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: R.colors.grey,
      appBar: AppBar(
        title: Text("Paket Soal"),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Text(
              "Pilih Paket Soal",
              style: R.appStyle.labelStyle,
            ),
          ),
          Expanded(
              child: paketSoalResponse == null
                  ? Center(
                      child: const CircularProgressIndicator(),
                    )
                  : SingleChildScrollView(
                      child: Wrap(
                        children: List.generate(paketSoalResponse!.data!.length,
                            (index) {
                          final currentPaketSoal =
                              paketSoalResponse!.data![index];
                          return InkWell(
                            onTap: () =>
                                Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => KerjakanLatihanSoalScreen(
                                  id: currentPaketSoal.exerciseId!),
                            )),
                            child: Container(
                              constraints: BoxConstraints(
                                  minWidth:
                                      MediaQuery.of(context).size.width * 0.5,
                                  maxWidth:
                                      MediaQuery.of(context).size.width * 0.5,
                                  maxHeight:
                                      MediaQuery.of(context).size.height * 0.2),
                              child: R.globalWidget.paketSoalWidget(context,
                                  paketSoalData: currentPaketSoal),
                            ),
                          );
                        }),
                      ),
                    )

              // GridView.count(
              //     mainAxisSpacing: 10,
              //     crossAxisSpacing: 10,
              //     crossAxisCount: 2,
              //     childAspectRatio: 4 / 3,
              //     children:
              //         List.generate(paketSoalResponse!.data!.length, (index) {
              //       final currentPaketSoal = paketSoalResponse!.data![index];
              //       return R.globalWidget.paketSoalWidget(context,
              //           paketSoalData: currentPaketSoal);
              //     })
              //     //  [
              //     //   R.globalWidget.paketSoalWidget(context,
              //     //       title: "Trigonometri", subtitle: "0/10 Soal"),
              //     //   R.globalWidget.paketSoalWidget(context,
              //     //       title: "Trigonometri", subtitle: "0/10 Soal"),
              //     //   R.globalWidget.paketSoalWidget(context,
              //     //       title: "Trigonometri", subtitle: "0/10 Soal"),
              //     //   R.globalWidget.paketSoalWidget(context,
              //     //       title: "Trigonometri", subtitle: "0/10 Soal"),
              //     // ],
              //     ),
              ),
        ],
      ),
    );
  }
}
