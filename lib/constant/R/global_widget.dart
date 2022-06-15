import 'package:final_project_bootcamp/constant/r.dart';
import 'package:final_project_bootcamp/models/paket_soal_response.dart';
import 'package:flutter/material.dart';

class GlobalWidget {
  paketSoalWidget(BuildContext context,
      {required PaketSoalData paketSoalData}) {
    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.all(12),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10), color: Colors.white),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: R.colors.grey),
              child: Image.network(
                paketSoalData.icon!,
                width: 15,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    padding: EdgeInsets.all(8),
                    child: Icon(
                      Icons.warning,
                    ),
                  );
                },
              )),
          const SizedBox(
            height: 6,
          ),
          Text(
            paketSoalData.exerciseTitle!,
            style: R.appStyle.labelStyle.copyWith(fontSize: 12),
          ),
          Text(
            "${paketSoalData.jumlahDone}/${paketSoalData.jumlahSoal} Paket Soal",
            style: R.appStyle.progressTextStyle.copyWith(fontSize: 8),
          ),
        ],
      ),
    );
  }

  mapelWidget(
      {required BuildContext context,
      required String imageIcon,
      required String title,
      required String subtitle,
      required double progress,
      required int totalDone,
      required int totalPaket}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 21),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10), color: Colors.white),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            width: 53,
            height: 53,
            decoration: BoxDecoration(
                color: R.colors.grey, borderRadius: BorderRadius.circular(10)),
            child: Image.network(
              imageIcon,
              width: 27,
              height: 28,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  padding: EdgeInsets.all(8),
                  child: Icon(
                    Icons.warning,
                  ),
                );
              },
            ),
          ),
          const SizedBox(
            width: 8,
          ),
          Expanded(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: R.appStyle.titleStyle,
              ),
              Text(
                "$totalDone/$totalPaket $subtitle",
                style: R.appStyle.progressTextStyle,
              ),
              const SizedBox(
                height: 10,
              ),
              Stack(
                children: [
                  Container(
                    width: double.infinity,
                    height: 5,
                    decoration: BoxDecoration(
                        color: R.colors.grey,
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  Container(
                    width: progress,
                    height: 5,
                    decoration: BoxDecoration(
                        color: R.colors.primary,
                        borderRadius: BorderRadius.circular(10)),
                  ),
                ],
              )
            ],
          ))
        ],
      ),
    );
  }

  buttonLogin(
      {required BuildContext context,
      required Color borderSide,
      required Widget widget,
      required Color primary,
      required Function() ontap}) {
    return ElevatedButton(
        onPressed: ontap,
        style: ElevatedButton.styleFrom(
            elevation: 0,
            primary: primary,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
                side: BorderSide(color: borderSide)),
            fixedSize: Size(MediaQuery.of(context).size.width * 0.8, 50)),
        child: widget);
  }

  registerTextField(
      {required String title,
      required String hintText,
      bool enable = true,
      TextEditingController? textEditingController}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: R.appStyle.labelStyle,
        ),
        const SizedBox(
          height: 4,
        ),
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 14,
          ),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Colors.white,
              border: Border.all(width: 1, color: R.colors.borderFieldColor)),
          child: TextField(
            enabled: enable,
            controller: textEditingController,
            decoration: InputDecoration(
                border: InputBorder.none,
                hintText: hintText,
                hintStyle: R.appStyle.hintStyle),
          ),
        )
      ],
    );
  }
}
