//if the name is not existing it will show a raised button so u can clcik on that to
//go to a COMPANY ADDING PAGE,otherwise it will only show a **CARD** so that you
//can't go to the next page to add your company


//code:

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';


const blue = 0xFF3b78e7;
String filter = '';
StreamSubscription<DocumentSnapshot> subscription;

final TextEditingController _usercontroller = new TextEditingController();

class CheckAvail extends StatefulWidget {
  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<CheckAvail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
// CHILD1
          new Flexible(
            child: StreamBuilder(
              stream: Firestore.instance
                  .collection('users')
                  .where('name', isGreaterThanOrEqualTo: filter.toLowerCase())
                  .limit(1)
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) {
                  return new Column(
                    children: <Widget>[
                      new Card(
                        elevation: 5.0,
                        child: new Image.asset('assets/progress.gif'),
                      )
                    ],
                  );
                } else {
                  return FirestoreListView1(documents: snapshot.data.documents);
                }
              },
            ),
          ),

          new Card(
            elevation: 0.0,
            color: Colors.white,
            shape: new RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(60.0)),
            child: Container(
              padding: new EdgeInsets.only(left: 8.0),
              child: new TextField(
                controller: _usercontroller,
                onChanged: (String z) {
                  setState(() {
                    filter = z;
                  });
                },
                decoration: const InputDecoration(
                  hintText: "Search...",
                  hintStyle: TextStyle(
                      fontFamily: 'roboto',
                      color: Colors.black38,
                      fontSize: 16.0,
                      letterSpacing: -0.500),
                  fillColor: Colors.white,
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
        ],
      ),
      backgroundColor: Color(blue),
    );
  }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////
class FirestoreListView1 extends StatelessWidget {
  final List<DocumentSnapshot> documents;
  FirestoreListView1({this.documents});
  @override
  Widget build(BuildContext context1) {
    return ListView.builder(
        itemCount: documents.length,
        padding: new EdgeInsets.all(1.0),
        itemBuilder: (BuildContext context1, int index) {
          String name = documents[index].data['name'];
          if (name.contains(filter.toLowerCase()) &&
              name.length == filter.length) {
            return new Container(
              padding: new EdgeInsets.only(top: 45.0),
              child: new Card(
                  child: new Text(
                      "Error:Already a Company Exists with this name\nTry another name")),
            );
          } else {
            return (filter.length >= 1)
                ? new Container(
              padding: new EdgeInsets.only(top: 15.0),
              child: new RaisedButton(
                onPressed: () => Navigator.push(
                    context1,
                    new MaterialPageRoute(
//                        builder: (context1) => new NextPage(
//                          value1: name,
//                        )
//
                    )),
                disabledColor: Colors.white,
                child: new Text(
                  "Good!You can use this company name",
                ),
              ),
            )
                : new Container(padding: new EdgeInsets.only(top: 250.0),
              child: new Card(child: new Text("CHECK IF YOUR COMPANY NAME \n           AVAILABLE OR NOT",style: new TextStyle(fontSize: 20.0),)),
            );
          }
        });
  }
}