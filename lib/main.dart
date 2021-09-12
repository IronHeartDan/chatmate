import 'dart:collection';

import 'package:chatmate/privateChat.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import 'classes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.pink,
      ),
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => HomeState();
}

class HomeState extends State<Home> {
  String? userName;
  IO.Socket? socket;
  TextEditingController search = TextEditingController();
  final HashMap<String, User> users = new HashMap();
  late String? token;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    Future.delayed(Duration.zero, () => showAlert(context));
    super.initState();
  }

  void showAlert(BuildContext context) async {
    token = await FirebaseMessaging.instance.getToken();
    await showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) => AlertDialog(
              title: Text("Enter UserName"),
              content: TextField(
                decoration: InputDecoration(hintText: "Eg : _darknoon"),
                onChanged: (value) {
                  setState(() {
                    userName = value;
                  });
                },
              ),
              actions: [
                InkWell(
                  onTap: () {
                    print("Taped!!!.");
                    socket = IO.io(
                        'http://192.168.1.2:3000?username=$userName',
                        IO.OptionBuilder()
                            .setTransports(['websocket']).build());
                    socket?.connect();
                    socket?.onConnect((_) {
                      socket?.emit("token", token);
                      Navigator.of(context).pop();
                    });

                    socket?.on("isOnline", (data) {
                      setState(() {
                        users["${data['who']}"] =
                            new User(data['who'], data['online']);
                      });
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text("GO!"),
                  ),
                )
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text("ChatMate"),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Card(
              elevation: 5.0,
              shadowColor: Colors.deepOrange,
              child: Container(
                padding: EdgeInsets.all(15.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: search,
                        decoration: InputDecoration(hintText: "Search"),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        String friend = search.text.trim().toString();
                        if (friend.isNotEmpty) {
                          socket?.emit("getPresence", friend);
                          search.text = '';
                        } else {
                          final snackBar = SnackBar(
                            content: Text('Enter UserName'),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(Icons.add),
                      ),
                    )
                  ],
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                  itemCount: users.length,
                  itemBuilder: (BuildContext context, int index) {
                    User user = new User(List.of(users.keys)[index],
                        List.of(users.values)[index].isOnline);
                    return Container(
                      padding: EdgeInsets.all(5.0),
                      child: Card(
                        elevation: 5.0,
                        shadowColor: Colors.green,
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        child: InkWell(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (BuildContext context) => PrivateChat(
                                      socket: socket,
                                      user: user,
                                    )));
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5.0)),
                            ),
                            padding: EdgeInsets.only(
                                top: 20.0,
                                bottom: 20.0,
                                left: 10.0,
                                right: 10.0),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.person,
                                  size: 35.0,
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(user.name),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Text(user.isOnline ? "Online" : "Offline")
                                    ])
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
