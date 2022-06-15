import 'package:final_project_bootcamp/constant/r.dart';
import 'package:final_project_bootcamp/models/mapel_response.dart';
import 'package:final_project_bootcamp/views/main/latihan_soal/paket_soal_page.dart';
import 'package:flutter/material.dart';

class MapelPage extends StatefulWidget {
  const MapelPage({Key? key, required this.mapel}) : super(key: key);
  static String route = "mapel_page";

  final MapelResponse mapel;

  @override
  State<MapelPage> createState() => _MapelPageState();
}

class _MapelPageState extends State<MapelPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: R.colors.grey,
      appBar: AppBar(
        title: const Text("Pilih Mata Pelajaran"),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: ListView.builder(
            itemCount: widget.mapel.data!.length,
            itemBuilder: (context, index) {
              final currentMapel = widget.mapel.data![index];
              return InkWell(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) =>
                        PaketSoalPage(id: currentMapel.courseId!),
                  ));
                },
                child: R.globalWidget.mapelWidget(
                  context: context,
                  imageIcon: currentMapel.urlCover!,
                  title: currentMapel.majorName!,
                  subtitle: "Paket latihan soal",
                  progress: MediaQuery.of(context).size.width *
                      ((currentMapel.jumlahDone! / currentMapel.jumlahMateri!) *
                          100),
                  totalDone: currentMapel.jumlahDone!,
                  totalPaket: currentMapel.jumlahMateri!,
                ),
              );
            }),
      ),
    );
  }
}
