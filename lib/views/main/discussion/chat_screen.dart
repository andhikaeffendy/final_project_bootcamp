import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_project_bootcamp/constant/r.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key, this.id}) : super(key: key);
  static String route = "chat_screen";
  final String? id;

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  TextEditingController textEditingController = TextEditingController();

  late CollectionReference chat;
  late QuerySnapshot chatData;

  // late List<QueryDocumentSnapshot>? listChat;
  // getDataFromFirebase() async {
  //   chatData = await FirebaseFirestore.instance
  //       .collection("room")
  //       .doc("kimia")
  //       .collection("chat")
  //       .get();
  //   // listChat = chatData.docs;
  //   setState(() {});
  // }

  @override
  void initState() {
    super.initState();
    // getDataFromFirebase();
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;
    chat = FirebaseFirestore.instance
        .collection("room")
        .doc("kimia")
        .collection("chat");
    return Scaffold(
      appBar: AppBar(
        title: Text("Diskusi Soal"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
              child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: StreamBuilder<QuerySnapshot>(
              stream: chat.orderBy("time").snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot<Object?>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                return ListView.builder(
                    reverse: true,
                    itemCount: snapshot.data!.docs.reversed.length,
                    itemBuilder: (context, index) {
                      final currentChat =
                          snapshot.data!.docs.reversed.toList()[index];
                      final currentDate =
                          (currentChat["time"] as Timestamp?)?.toDate();
                      return Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        width: MediaQuery.of(context).size.width * 0.8,
                        child: Column(
                          crossAxisAlignment: user.uid == currentChat["uid"]
                              ? CrossAxisAlignment.end
                              : CrossAxisAlignment.start,
                          children: [
                            Text(
                              currentChat["nama"],
                              style: user.uid == currentChat["uid"]
                                  ? R.appStyle.nameChatStyle
                                      .copyWith(color: R.colors.chatMeColor)
                                  : R.appStyle.nameChatStyle,
                            ),
                            Container(
                              constraints: BoxConstraints(
                                  maxWidth:
                                      MediaQuery.of(context).size.width * 0.6),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                  color: user.uid == currentChat["uid"]
                                      ? R.colors.primary
                                      : R.colors.chatsColor,
                                  borderRadius: BorderRadius.only(
                                      topLeft: user.uid == currentChat["uid"]
                                          ? const Radius.circular(12)
                                          : Radius.zero,
                                      topRight: const Radius.circular(12),
                                      bottomLeft: const Radius.circular(12),
                                      bottomRight:
                                          user.uid == currentChat["uid"]
                                              ? Radius.zero
                                              : const Radius.circular(12))),
                              child: currentChat["type"] == "file"
                                  ? Image.network(
                                      currentChat["file_url"],
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                        return Container(
                                          padding: EdgeInsets.all(8),
                                          child: Icon(
                                            Icons.warning,
                                          ),
                                        );
                                      },
                                    )
                                  : Text(
                                      currentChat["content"],
                                      style: user.uid == currentChat["uid"]
                                          ? R.appStyle.pesanStyle
                                              .copyWith(color: Colors.white)
                                          : R.appStyle.pesanStyle,
                                    ),
                            ),
                            Container(
                              constraints: BoxConstraints(
                                  maxWidth:
                                      MediaQuery.of(context).size.width * 0.6),
                              child: Text(
                                currentDate == null
                                    ? "waktu kirim"
                                    : DateFormat("dd-MMM-yy HH:mm")
                                        .format(currentDate),
                                textAlign: user.uid == currentChat["uid"]
                                    ? TextAlign.end
                                    : TextAlign.start,
                                style: R.appStyle.minutesChatsStyle,
                              ),
                            )
                          ],
                        ),
                      );
                    });
              },
            ),
          )),
          SafeArea(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(color: Colors.white, boxShadow: [
                BoxShadow(
                    blurRadius: 7,
                    offset: const Offset(4, 0),
                    color: Colors.black.withOpacity(0.25))
              ]),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    iconSize: 20,
                    onPressed: () {},
                    icon: Icon(
                      Icons.add,
                      size: 20,
                      color: R.colors.primary,
                    ),
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: TextField(
                        controller: textEditingController,
                        decoration: InputDecoration(
                            suffixIcon: IconButton(
                              onPressed: () async {
                                final imgResult = await ImagePicker().pickImage(
                                    source: ImageSource.camera,
                                    maxHeight: 500,
                                    maxWidth: 500);
                                if (imgResult != null) {
                                  File file = File(imgResult.path);
                                  final name = imgResult.path.split("/");
                                  String room = widget.id ?? "kimia";
                                  String ref =
                                      "chat/${room}/${user.uid}/${name.last}";

                                  final imgResUpload = await FirebaseStorage
                                      .instance
                                      .ref()
                                      .child(ref)
                                      .putFile(file);

                                  final url =
                                      await imgResUpload.ref.getDownloadURL();

                                  final chatContent = {
                                    "nama": user.displayName,
                                    "uid": user.uid,
                                    "content": textEditingController.text,
                                    "email": user.email,
                                    "ref": ref,
                                    "file_url": url,
                                    "type": "file",
                                    "photo": user.photoURL,
                                    "time": FieldValue.serverTimestamp()
                                  };

                                  chat.add(chatContent).whenComplete(() {
                                    textEditingController.clear();
                                    // getDataFromFirebase();
                                  });
                                }
                              },
                              icon: Icon(
                                Icons.camera_alt,
                                size: 20,
                                color: R.colors.primary,
                              ),
                            ),
                            contentPadding:
                                const EdgeInsets.symmetric(horizontal: 12),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12)),
                            hintText: "Ketuk untuk menulis",
                            hintStyle: R.appStyle.hintStyle),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  IconButton(
                    onPressed: () {
                      if (textEditingController.text.isEmpty) {
                        return print("Text Kosong");
                      }

                      final chatContent = {
                        "nama": user.displayName,
                        "uid": user.uid,
                        "content": textEditingController.text,
                        "email": user.email,
                        "photo": user.photoURL,
                        "ref": null,
                        "file_url": null,
                        "type": "text",
                        "time": FieldValue.serverTimestamp()
                      };

                      chat.add(chatContent).whenComplete(() {
                        textEditingController.clear();
                        // getDataFromFirebase();
                      });
                    },
                    icon: Icon(
                      Icons.send,
                      size: 20,
                      color: R.colors.primary,
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
