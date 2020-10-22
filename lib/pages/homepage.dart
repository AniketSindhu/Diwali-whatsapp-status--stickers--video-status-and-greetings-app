import 'package:cached_network_image/cached_network_image.dart';
import 'package:clipboard/clipboard.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:random_color/random_color.dart';
import 'package:share/share.dart';


class Homepage extends StatefulWidget {
  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  int index=0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.amber,
      bottomNavigationBar: BottomNavigationBar(
        unselectedItemColor: Colors.white,
        selectedItemColor: Colors.blueAccent,
        currentIndex: index,
        backgroundColor: Colors.red[900],
        type: BottomNavigationBarType.fixed,
        onTap: (val){
          setState(() {
            index=val;
            print(index);
          });
        },
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.textsms),label:'English Status',),
          BottomNavigationBarItem(icon: Icon(Icons.language),label:'Hindi Status',),
          BottomNavigationBarItem(icon: Icon(Icons.image),label:'Images',),
          BottomNavigationBarItem(icon: Icon(Icons.emoji_emotions),label:'Stickers',),
          BottomNavigationBarItem(icon: Icon(Icons.card_giftcard_rounded),label:'Wishes',),
        ],
      ),
      appBar: AppBar(
        title:Text('Diwali App',style: TextStyle(fontWeight: FontWeight.bold),),
        centerTitle: true,
        backgroundColor: Colors.red[900],  
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
          else {
            if(index==0||index==1){
              return ListView.builder(
                itemCount: snapshot.data.documents[0].data()['${index==0?'english':'hindi'}'].length,
                itemBuilder:(context,ind){
                  return
                    index==0? 
                      TextStatus(status: snapshot.data.documents[0].data()['english'][ind],):
                      TextStatus(status: snapshot.data.documents[0].data()['hindi'][ind],);
                }
              );
            }
            else if(index==2){
              return ListView.builder(
                itemCount:snapshot.data.documents[0].data()['images'].length,
                itemBuilder: (context,ind){
                  return ImageWidget(url: snapshot.data.documents[0].data()['images'][ind],);
                },
              );
            }
            else
              return Container(child: Text('to be done'),);
          }
        } ,
      ),
    );
  }
}

class ImageWidget extends StatelessWidget {
  final String url;
  const ImageWidget({
    Key key,this.url
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:EdgeInsets.all(10),
      child:SizedBox(
        height:350,
        child: Column(
          children: [
            Expanded(
              child: CachedNetworkImage(
                imageUrl: url,
                imageBuilder: (context, imageProvider) => Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                            image: imageProvider,
                            fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Align(
                      alignment:Alignment.bottomRight,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('Downloaded From Diwali bonanza',style: TextStyle(color: Colors.black,fontSize: 18,fontWeight: FontWeight.w600),),
                      )
                    )
                  ],
                ),
                placeholder:(context,s){
                  return Card(
                    color:Colors.purple,
                    child: Container(height: 300,child: Center(child:CircularProgressIndicator()),),
                  );
                },
              ),
            ),
            Container(
              height: 60,
              color: Colors.purple,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  RaisedButton(
                    child: Text('Download',style: TextStyle(color:Colors.white,)),
                    onPressed: (){},
                    color: Colors.amber,
                  ),
                  SizedBox(width:20),
                  RaisedButton(
                    child: Text('Download without watermark',style: TextStyle(color:Colors.white,)),
                    onPressed: (){},
                    color: Colors.red,
                  ),
                ],
              ),
            )
          ],
        ),
      )
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
          height:225,
          width:double.infinity,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    child: Center(child: Text('$status',style: TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.w600,),textAlign: TextAlign.center,))
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children:[
                      GestureDetector(
                        child: Image.asset('assets/whatsapp.png',width: 40,),
                        onTap: (){
                          Share.share('$status');
                        },                      
                      ),
                      SizedBox(width:10),
                      IconButton(
                        icon:Icon(Icons.copy),
                        color: Colors.deepOrange,
                        onPressed: (){
                           FlutterClipboard.copy('$status').then(( value ){
                             Fluttertoast.showToast(msg: 'Copied!',textColor:Colors.white,backgroundColor:Colors.green,gravity:ToastGravity.TOP);
                           });
                        },                    
                      ),
                    ]
                  )
                ],
              ),
            )
          ),
        ),
      ),
    );
  }
}

