import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import "package:intl/intl.dart";
import 'dart:convert';

void main() => runApp(MyHomePage());

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var count = 1;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Chat',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Flutter Firestore Demo'),
        ),
        body: createListView(),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            // Firestore 上にデータを追加
            Firestore.instance.collection('speaks').add({
              'name': 'タイトル$count',
              'text': '著者$count',
            });
            count += 1;
          },
          child: Icon(Icons.add),
        ),
      ),
    );
  }

  createListView() {
    Firestore.instance.collection('speaks').snapshots().listen((data) {
      print(data);
    });

    return StreamBuilder(
      stream: Firestore.instance.collection('speaks').snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        // エラーの場合
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }

        // 通信中の場合
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return Text('Loading ...');
          default:
            return ListView(
              children: snapshot.data.documents.map((DocumentSnapshot document) {
                return new ListTile(
                  title: new Text(document['name']),
                  subtitle: new Text(document['text']),
                  trailing: Text(
//                    (DateFormat('yyyy/MM/dd  HH:mm')).format(DateTime.parse(document['timestamp']).toLocal())
                      document['timestamp']
                  ),

                );
              }).toList(),
            );
        }
      },
    );
  }
}