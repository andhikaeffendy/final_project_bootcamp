import 'package:final_project_bootcamp/models/kerjakan_soal_response.dart';
import 'package:final_project_bootcamp/models/network_response.dart';
import 'package:final_project_bootcamp/repository/latihan_soal_api.dart';
import 'package:flutter/material.dart';

class KerjakanLatihanSoalScreen extends StatefulWidget {
  const KerjakanLatihanSoalScreen({Key? key, required this.id})
      : super(key: key);
  final String id;

  @override
  State<KerjakanLatihanSoalScreen> createState() =>
      _KerjakanLatihanSoalScreenState();
}

class _KerjakanLatihanSoalScreenState extends State<KerjakanLatihanSoalScreen> {
  KerjakanSoalResponse? kerjakanSoalResponse;
  getKerjakanSoal() async {
    final result = await LatihanSoalApi().postQuestionList(widget.id);
    if (result.status == Status.succes) {
      kerjakanSoalResponse = KerjakanSoalResponse.fromJson(result.data!);
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    getKerjakanSoal();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Kerjakan Latihan Soal"),
        centerTitle: true,
      ),
      bottomNavigationBar: Container(),
      body: kerjakanSoalResponse == null
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              children: [
                //tabbar
                Container(),
                Expanded(child: Container())
              ],
            ),
    );
  }
}
