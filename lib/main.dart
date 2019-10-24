import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

final databaseReference = Firestore.instance;

ThemeData lightTheme = ThemeData(
  // primaryColor: Colors.white,
  unselectedWidgetColor: Colors.white,
  // appBarTheme: AppBarTheme(
  //   color: Colors.white,
  //   textTheme: TextTheme(
  //     title: TextStyle(
  //       color: Colors.black,
  //     ),
  //   ),
  //   actionsIconTheme: IconThemeData(color: Colors.black),
  // ),
);

ThemeData darkTheme = ThemeData(
  appBarTheme: AppBarTheme(
    color: Colors.black,
  ),
  unselectedWidgetColor: Colors.white,
  scaffoldBackgroundColor: Colors.black,
  cursorColor: Colors.white,
  accentColor: Colors.blueAccent,
  //primaryColor: Colors.white,
  primaryTextTheme: TextTheme(
    body1: TextStyle(
      color: Colors.white,
    ),
  ),
);

QuerySnapshot todoList;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  todoList = await databaseReference.collection('todo').getDocuments();
  print(todoList.documents);
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MyAppState();
  }
}

class MyAppState extends State<MyApp> {
  TextEditingController _textController = TextEditingController();

  Widget cardListBuilder() {
    return Expanded(
      child: ListView.builder(
        // reverse: true,
        itemCount: todoList.documents.length,
        itemBuilder: (BuildContext context, int position) {
          return Card(
            color: Colors.blue,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Checkbox(
                  value: todoList.documents[position]['isDone'],
                  checkColor: Colors.black,
                  activeColor: Colors.white,
                  onChanged: (bool newValue) async {
                    var temp;
                    try {
                      databaseReference
                          .collection('todo')
                          .document(todoList.documents[position].documentID)
                          .updateData({'isDone': newValue});
                      temp = await databaseReference
                          .collection('todo')
                          .getDocuments();
                    } catch (e) {
                      print(e.toString());
                    }
                    setState(() {
                      todoList = temp;
                    });
                  },
                ),
                Text(
                  todoList.documents[position]['title'],
                  style: TextStyle(color: Colors.white),
                ),
                IconButton(
                  icon: Icon(Icons.close),
                  color: Colors.white,
                  onPressed: () async {
                    var temp;
                    try {
                      databaseReference
                          .collection('todo')
                          .document(todoList.documents[position].documentID)
                          .delete();
                      temp = await databaseReference
                          .collection('todo')
                          .getDocuments();
                    } catch (e) {
                      print(e.toString());
                    }
                    setState(() {
                      todoList = temp;
                    });
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      darkTheme: darkTheme,
      theme: lightTheme,
      home: Scaffold(
        appBar: AppBar(
          title: Text('Todo App'),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.refresh),
              onPressed: () async {
                var temp =
                    await databaseReference.collection('todo').getDocuments();
                setState(() {
                  todoList = temp;
                });
              },
            )
          ],
          centerTitle: true,
        ),
        body: Container(
          padding: EdgeInsets.only(top: 30.0, left: 30.0, right: 30.0),
          child: Column(
            children: <Widget>[
              TextField(
                style:
                    TextStyle(color: Theme.of(context).textTheme.body1.color),
                controller: _textController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Enter the Todo',
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 20.0, bottom: 20.0),
                child: RaisedButton(
                  color: Colors.blue,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(
                        Icons.add,
                        color: Colors.white,
                      ),
                      Text(
                        'Add',
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                  onPressed: () async {
                    DocumentReference ref =
                        await databaseReference.collection('todo').add({
                      'title': '${_textController.text}',
                      'isDone': false,
                    });
                    var temp = await databaseReference
                        .collection('todo')
                        .getDocuments();
                    setState(() {
                      todoList = temp;
                    });
                    print(ref.documentID);
                  },
                ),
              ),
              cardListBuilder(),
            ],
          ),
        ),
      ),
    );
  }
}
