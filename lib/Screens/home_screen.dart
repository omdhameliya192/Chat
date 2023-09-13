import 'package:chat_app_af_12/Components/Helpers/firebase_auth_helper.dart';
import 'package:chat_app_af_12/Components/Helpers/firebase_cloud_firestore_helper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

import '../Components/Globals/globals.dart';

class Home_Screen extends StatefulWidget {
  const Home_Screen({super.key});

  @override
  State<Home_Screen> createState() => _Home_ScreenState();
}

class _Home_ScreenState extends State<Home_Screen> {
  GlobalKey<ScaffoldState> ScaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text("Are You Sure.."),
            content: Text("Do you Want to Exit..."),
            actions: [
              ElevatedButton(onPressed: () {}, child: Text("Yes")),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text("No"),
              ),
            ],
          ),
        );
      },
      child: Scaffold(
        key: ScaffoldKey,
        drawer: Drawer(
          width: 300,
          child: Column(
            children: [
              SizedBox(
                height: 50,
              ),
              CircleAvatar(
                radius: 80,
                foregroundImage: NetworkImage(
                    "${Auth_Helper.auth_helper.firebaseAuth.currentUser?.photoURL}"),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                  "${Auth_Helper.auth_helper.firebaseAuth.currentUser?.email?.split("@")[0]}"),
              SizedBox(
                height: 10,
              ),
              Divider(),
              Text(
                  "${Auth_Helper.auth_helper.firebaseAuth.currentUser?.email}"),
              Divider(),
            ],
          ),
        ),
        appBar: AppBar(
          title: Text(
              "Welcome ${Auth_Helper.auth_helper.firebaseAuth.currentUser?.email?.split("@")[0]}"),
          leading: GestureDetector(
            onTap: () {
              ScaffoldKey.currentState?.openDrawer();
            },
            child: CircleAvatar(
              foregroundImage: NetworkImage(
                  "${Auth_Helper.auth_helper.firebaseAuth.currentUser?.photoURL}"),
            ),
          ),
          actions: [
            IconButton(
                onPressed: () {
                  Auth_Helper.auth_helper.SignOut();
                  Navigator.pushReplacementNamed(context, "/");
                },
                icon: Icon(Icons.power_settings_new))
          ],
        ),
        body: StreamBuilder(
          stream: FireStore_Helper.fireStore_Helper.fetchUsers(),
          builder: (BuildContext ctx, AsyncSnapshot snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: Text("${snapshot.error}"),
              );
            } else if (snapshot.hasData) {
              QuerySnapshot<Map<String, dynamic>> my_data = snapshot.data;
              List<QueryDocumentSnapshot<Map<String, dynamic>>> data =
                  (my_data == null) ? [] : my_data.docs;

              return ListView.builder(
                  itemCount: data.length,
                  itemBuilder: (ctx, i) {
                    return Card(
                      child: ListTile(
                        onTap: () async {
                          Navigator.pushNamed(context, "chat",
                              arguments: <String>[
                                Auth_Helper
                                    .auth_helper.firebaseAuth.currentUser!.uid,
                                data[i]['uid'],
                                data[i]['email']
                              ]);
                          all_stream_messages = await FireStore_Helper
                              .fireStore_Helper
                              .DisplayMessage(
                                  uid1: Auth_Helper.auth_helper.firebaseAuth
                                      .currentUser!.uid,
                                  uid2: data[i]['uid']);
                        },
                        title: Text("${data[i]['email']}"),
                        subtitle: Text("${data[i]['uid']}"),
                        trailing: IconButton(
                          onPressed: () async {
                            await FireStore_Helper.fireStore_Helper
                                .deleteUser(uid: data[i]['uid']);
                          },
                          icon: Icon(Icons.delete),
                        ),
                      ),
                    );
                  });
            }
            return Center(
              child: LinearProgressIndicator(),
            );
          },
        ),
      ),
    );
  }
}
