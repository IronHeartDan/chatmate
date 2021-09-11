import 'package:flutter/material.dart';

void main() {
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
        primarySwatch: Colors.blueGrey,
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
  @override
  void initState() {
    Future.delayed(Duration.zero, () => showAlert(context));
    super.initState();
  }

  showAlert(BuildContext context) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) => AlertDialog(
              title: Text("Enter UserName"),
              content: TextField(
                decoration: InputDecoration(hintText: "Eg : _darknoon"),
              ),
              actions: [
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("GO!"),
                  ),
                )
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("ChatMate"),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(onTap: () {}, child: Icon(Icons.call)),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(onTap: () {}, child: Icon(Icons.videocam)),
          )
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [Expanded(child: MessageCon()), InputChat()],
        ),
      ),
    );
  }
}

// MessageCon Widget
class MessageCon extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => MessageConState();
}

class MessageConState extends State<MessageCon> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: 10,
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
                      content: Text(index.toString()),
                      actions: [],
                    );
                  });
            },
            key: UniqueKey(),
            child: Padding(
              padding: EdgeInsets.only(left: 5, top: 15, bottom: 15),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Icon(Icons.person),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "From",
                        style: TextStyle(fontSize: 10),
                      ),
                      Text(
                        "Message",
                        style: TextStyle(fontSize: 15),
                      )
                    ],
                  )
                ],
              ),
            ),
          );
        });
  }
}

// InputChat Widget

class InputChat extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => InputChatState();
}

class InputChatState extends State<InputChat> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(
            offset: Offset(0, 0), color: Colors.deepOrange, blurRadius: 2),
        BoxShadow(offset: Offset(0, 0), color: Colors.white, blurRadius: 0),
      ]),
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextField(
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
            onTap: () {},
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(Icons.send),
            ),
          ),
        ],
      ),
    );
  }
}
