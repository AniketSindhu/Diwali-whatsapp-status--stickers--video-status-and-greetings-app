import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:random_color/random_color.dart';


class Homepage extends StatefulWidget {
  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:Text('Diwali app',style: TextStyle(color: Colors.red,fontWeight: FontWeight.bold),),
        centerTitle: true,
        backgroundColor: Colors.amber[500],  
      ),
      body: FutureBuilder(
        future: FirebaseFirestore.instance.collection('status').get(),
        builder:(context,snapshot){
          if(snapshot.connectionState==ConnectionState.waiting){
            return Center(
              child:CircularProgressIndicator(),
            );
          }
          else if(snapshot.hasError){
            return Center(
              child:Column(
                children: [
                  Text('Error',style: TextStyle(color:Colors.red,fontSize: 24, fontWeight: FontWeight.bold,)),
                  SizedBox(height:20),
                  Text('Check your internet and try again',style: TextStyle(color:Colors.black,fontSize: 18, fontWeight: FontWeight.w600,)),
                ],
              ),
            );
          }
          else
            return ListView.builder(
              itemCount: snapshot.data.documents[0].data()['english'].length,
              itemBuilder:(context,index){
                return TextStatus(status: snapshot.data.documents[0].data()['english'][index],);
              }
            );
        } ,
      ),
    );
  }
}

class TextStatus extends StatelessWidget {
  final String status;
  final RandomColor _randomColor = RandomColor();
  TextStatus({this.status});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(25, 10, 20, 25),
      child: Card(
        color: _randomColor.randomColor(
          colorBrightness: ColorBrightness.dark),
        elevation: 20,
        child: Container(
          height:200,
          width:double.infinity,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('status',style: TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.w600,),textAlign: TextAlign.center,),
            )
          ),
        ),
      ),
    );
  }
}