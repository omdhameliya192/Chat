import 'dart:developer';

import 'package:chat_app_af_12/Components/Helpers/firebase_auth_helper.dart';
import 'package:chat_app_af_12/Components/Helpers/firebase_cloud_firestore_helper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:searchbar_animation/searchbar_animation.dart';

import '../Components/Globals/globals.dart';

class Chat_Screen extends StatefulWidget {
  const Chat_Screen({super.key});

  @override
  State<Chat_Screen> createState() => _Chat_ScreenState();
}

class _Chat_ScreenState extends State<Chat_Screen> {
  TextEditingController message_controller = TextEditingController();
  // late Stream<QuerySnapshot<Map<String, dynamic>>> allMessages;
  // @override
  // void initState() {
  //   super.initState();
  //   allMessages = FireStore_Helper.fireStore_Helper
  //       .DisplayMessage(uid1: Global.u1, uid2: Global.u2);
  // }

  @override
  Widget build(BuildContext context) {
    List<String> data =
        ModalRoute.of(context)!.settings.arguments as List<String>;
    return Scaffold(
      appBar: AppBar(
        title: Text("${data[2].split("@")[0]}"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
              flex: 10,
              child: StreamBuilder(
                stream: all_stream_messages,
                builder: (ctx, snapshot) {
                  if (snapshot.hasError) {
                    return Center(
                      child: Text("${snapshot.error}"),
                    );
                  } else if (snapshot.hasData) {
                    QuerySnapshot<Map<String, dynamic>>? snapshot_data =
                        snapshot.data;
                    List<QueryDocumentSnapshot<Map<String, dynamic>>>? data =
                        snapshot_data?.docs;

                    return (data!.isEmpty)
                        ? Center(
                            child: Text("No Message Yet"),
                          )
                        : ListView.builder(
                            reverse: true,
                            itemCount: data.length,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () {
                                  FireStore_Helper.fireStore_Helper.DeleteChat(
                                      uid: data[index].id,
                                      uid1: data[index]['sentby'],
                                      uid2: data[index]['receivedby']);
                                },
                                child: Row(
                                  mainAxisAlignment: (data[index]['sentby'] ==
                                          Auth_Helper.auth_helper.firebaseAuth
                                              .currentUser?.uid)
                                      ? MainAxisAlignment.end
                                      : MainAxisAlignment.start,
                                  children: [
                                    Column(
                                      children: [
                                        Chip(
                                            label:
                                                Text("${data[index]['msg']}")),
                                        Text(
                                          "${data[index]['timestamp'].toDate().toString().split(" ")[1].split(":")[0]}"
                                          ":${data[index]['timestamp'].toDate().toString().split(" ")[1].split(":")[1]}",
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                  }
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                },
              )),
          SearchBarAnimation(
            hintText: "send message....",
            buttonWidget: Icon(Icons.send),
            textEditingController: message_controller,
            isOriginalAnimation: true,
            trailingWidget: GestureDetector(
                onTap: () {
                  FireStore_Helper.fireStore_Helper.sendMessage(
                    uid1: data[0],
                    uid2: data[1],
                    msg: message_controller.text,
                  );

                  message_controller.clear();
                },
                child: Icon(Icons.send)),
            secondaryButtonWidget: Icon(Icons.close),
          )
        ],
      ),
    );
  }
}
