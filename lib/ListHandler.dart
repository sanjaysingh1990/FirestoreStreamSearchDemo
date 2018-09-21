import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ListHandler extends StatefulWidget {
  @override
  State createState() => new ListHandlerState();
}

class ListHandlerState extends State<ListHandler> {
  bool _loading = false;
  String _searchTxt = "sanjay";
  Stream _stream1;

  Stream getData() {
    Stream stream1 = Firestore.instance
        .collection("users")
        .where('name', isEqualTo: _searchTxt)
        .snapshots();


    return stream1; //Observable.merge(([stream2, stream1]));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Firestore with stream'),
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: new TextField(
              decoration: new InputDecoration(
                  border: new OutlineInputBorder(
                    borderRadius: const BorderRadius.all(
                      const Radius.circular(10.0),
                    ),
                  ),
                  filled: true,
                  hintStyle: new TextStyle(color: Colors.grey[800]),
                  hintText: "Type keyword .........",
                  fillColor: Colors.white70),
              onChanged: (text) {
                print("First text field: $text");
                _searchTxt=text;
                _stream1=Firestore.instance
                    .collection("users")
                    .where('name', isEqualTo: _searchTxt)
                    .snapshots();
//                setState(() {
//                  _searchTxt = text;
//                  _loading = true;
//                });
              },
            ),
          ),
          _loading
              ? new Text(
                  "Loading.....",
                  style: new TextStyle(
                      fontSize: 14.0,
                      color: const Color(0xFF000000),
                      fontWeight: FontWeight.w400,
                      fontFamily: "Roboto"),
                )
              : new Container(),
          Flexible(
            child: new StreamBuilder(
                stream: _stream1=getData(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    print(snapshot);
                    return Padding(
                      padding: const EdgeInsets.only(top:32.0),
                      child: new Text("loading"),
                    );
                  }

                  return new ListView.builder(
                      itemCount: snapshot.data.documents.length,
                      padding: const EdgeInsets.only(top: 2.0),
                      itemBuilder: (context, index) {

                        DocumentSnapshot ds = snapshot.data.documents[index];
                        print(ds.data.toString());
                        return _getListItem(ds.data['name']);
                      });
                }),
          ),
        ],
      ),
    );
  }

  Widget _getListItem(String name) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 8.0),
      child: new Container(
        height: 60.0,
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: new Text(
              "$name",
              style: new TextStyle(
                  fontSize: 16.0,
                  color: const Color(0xFF000000),
                  fontWeight: FontWeight.w400,
                  fontFamily: "Roboto"),
            ),
          ),
        ),
      ),
    );
  }
}
