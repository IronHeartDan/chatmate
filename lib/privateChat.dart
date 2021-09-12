
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import 'calling.dart';
import 'classes.dart';

class PrivateChat extends StatefulWidget {
  final IO.Socket? socket;
  final User user;

  const PrivateChat({Key? key, required this.socket, required this.user})
      : super(key: key);

  @override
  _PrivateChatState createState() => _PrivateChatState();
}

class _PrivateChatState extends State<PrivateChat> {
  TextEditingController msg = TextEditingController();
  final List<Msg> msgs = [];

  @override
  void initState() {
    widget.socket?.on("msg", (data) {
      setState(() {
        msgs.add(Msg(1, data));
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    widget.socket?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.user.name),
        actions: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: GestureDetector(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (BuildContext context) => Calling()));
                },
                child: Icon(Icons.call)),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: GestureDetector(onTap: () {}, child: Icon(Icons.videocam)),
          )
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
                child: ListView.builder(
                    itemCount: msgs.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Dismissible(
                        background: Container(
                          color: Colors.red,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Icon(
                                  Icons.delete,
                                  color: Colors.white,
                                ),
                              )
                            ],
                          ),
                        ),
                        direction: DismissDirection.endToStart,
                        confirmDismiss: (DismissDirection direction) {
                          return showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text(
                                    "Confirm Delete?",
                                    style: TextStyle(color: Colors.red),
                                  ),
                                  content: Text(msgs[index].msg),
                                  actions: [],
                                );
                              });
                        },
                        key: UniqueKey(),
                        child: msgs[index].type == 1
                            ? Container(
                                margin: EdgeInsets.all(10),
                                padding: EdgeInsets.all(10.0),
                                decoration: BoxDecoration(
                                  color: Colors.orange,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                ),
                                child: Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: Icon(Icons.person),
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "From",
                                          style: TextStyle(fontSize: 10),
                                        ),
                                        Text(
                                          msgs[index].msg,
                                          style: TextStyle(fontSize: 15),
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              )
                            : msgs[index].type == 0
                                ? Container(
                                    margin: EdgeInsets.all(10),
                                    padding: EdgeInsets.all(10.0),
                                    decoration: BoxDecoration(
                                      color: Colors.black,
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(10)),
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            Text(
                                              "From",
                                              style: TextStyle(
                                                  fontSize: 10,
                                                  color: Colors.white),
                                            ),
                                            Text(
                                              msgs[index].msg,
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  color: Colors.white),
                                            )
                                          ],
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(5.0),
                                          child: Icon(
                                            Icons.person,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                : Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text("${msgs[index].msg} Connected...")
                                      ],
                                    ),
                                  ),
                      );
                    })),
            Container(
              decoration: BoxDecoration(boxShadow: [
                BoxShadow(
                    offset: Offset(0, 0),
                    color: Colors.deepOrange,
                    blurRadius: 2),
                BoxShadow(
                    offset: Offset(0, 0), color: Colors.white, blurRadius: 0),
              ]),
              child: Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: TextField(
                        controller: msg,
                        decoration: InputDecoration(
                          hintText: "Enter Message",
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {},
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(Icons.person),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      String message =
                          '{"whome":"${widget.user.name.toString()}" , "msg":"${msg.text.trim().toString()}"}';
                      widget.socket?.emit("privateMsg", message);
                      setState(() {
                        msgs.add(Msg(0, msg.text.trim().toString()));
                        msg.text = "";
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(Icons.send),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
