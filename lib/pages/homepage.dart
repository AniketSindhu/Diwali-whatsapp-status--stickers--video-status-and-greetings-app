import 'dart:async';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:clipboard/clipboard.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_downloader/image_downloader.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:random_color/random_color.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share/share.dart';

MobileAdTargetingInfo targetingInfo = MobileAdTargetingInfo(
    keywords: <String>['Deepwali', 'Diwali'],
    childDirected: false,
    testDevices: <String>[], // Android emulators are considered test devices
);

InterstitialAd interstitialAd;
BannerAd bannerAd;

InterstitialAd myInterstitial() {
    return InterstitialAd(
      adUnitId: 'ca-app-pub-8295782880270632/8126404478',
      targetingInfo: targetingInfo,
      listener: (MobileAdEvent event) {
        if (event == MobileAdEvent.failedToLoad) {
          interstitialAd..load();
        } else if (event == MobileAdEvent.closed) {
          interstitialAd = myInterstitial()..load();
        }
      },
    );
}

BannerAd myBannerAd() {
    return BannerAd(
      adUnitId: 'ca-app-pub-8295782880270632/7164854204',
      size: AdSize.smartBanner,
      listener: (MobileAdEvent event) {
        print('$event');
    },
  );
}

class Homepage extends StatefulWidget {
  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  int index=0;
  String aarti="ॐ जय लक्ष्मी माता, मैया जय लक्ष्मी माता\n\nतुमको निशदिन सेवत, मैया जी को निशदिन * सेवत हरि विष्णु विधात\n\nॐ जय लक्ष्मी माता-\n\nउमा, रमा, ब्रह्माणी, तुम ही जग-मात\n\nसूर्य-चन्द्रमा ध्यावत, नारद ऋषि गात\n\nॐ जय लक्ष्मी माता-\n\nदुर्गा रूप निरंजनी, सुख सम्पत्ति दात\n\nजो कोई तुमको ध्यावत, ऋद्धि-सिद्धि धन पात\n\nॐ जय लक्ष्मी माता-\n\nतुम पाताल-निवासिनि, तुम ही शुभदात\n\nकर्म-प्रभाव-प्रकाशिनी, भवनिधि की त्रात\n\nॐ जय लक्ष्मी माता-\n\nजिस घर में तुम रहतीं, सब सद्गुण आत\n\nसब सम्भव हो जाता, मन नहीं घबरात\n\nॐ जय लक्ष्मी माता-\n\nतुम बिन यज्ञ न होते, वस्त्र न कोई पात\n\nखान-पान का वैभव, सब तुमसे आत\n\nॐ जय लक्ष्मी माता-\n\nशुभ-गुण मन्दिर सुन्दर, क्षीरोदधि-जात\n\nरत्न चतुर्दश तुम बिन, कोई नहीं पात\n\nॐ जय लक्ष्मी माता-\n\nमहालक्ष्मीजी की आरती, जो कोई नर गात\n\nउर आनन्द समाता, पाप उतर जात\n\nॐ जय लक्ष्मी माता-\n\nॐ जय लक्ष्मी माता, मैया जय लक्ष्मी मात\n\nतुमको निशदिन सेवत\n\nमैया जी को निशदिन सेवत हरि विष्णु विधात\n\nॐ जय लक्ष्मी माता-2";
  
  Timer timer;

  @override
  void initState(){
    super.initState();
    FirebaseAdMob.instance.initialize(appId: 'ca-app-pub-8295782880270632~5628750562');
    interstitialAd = myInterstitial()..load();
    bannerAd=myBannerAd()..load();
    timer=Timer.periodic(Duration(seconds: 25), (timer) {interstitialAd..load()..show();});       //intersetital ad every 25 seconds
  }
@override
  void dispose(){
    interstitialAd?.dispose();
    timer?.cancel();
    bannerAd.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bannerAd..load()..show(
      anchorOffset: 30,
      anchorType: AnchorType.top
    );
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
          BottomNavigationBarItem(icon: Icon(Icons.music_note),label:'Aarti',),
          BottomNavigationBarItem(icon: Icon(Icons.design_services_rounded),label:'Rangoli',),
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
            else if(index==2||index==4){
              return ListView.builder(
                itemCount:snapshot.data.documents[0].data()[index==2?'images':'rangoli'].length,
                itemBuilder: (context,ind){
                  return ImageWidget(url: snapshot.data.documents[0].data()[index==2?'images':'rangoli'][ind],);
                },
              );
            }
            else if(index==3){
              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Center(
                    child: Column(
                      children: [
                        Image.asset('assets/aarti.jpg'),
                        SizedBox(height:15),
                        Card(
                          color: Colors.red,
                          elevation: 12,
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Text(aarti,style: TextStyle(fontWeight: FontWeight.w600,fontSize: 22,color: Colors.white),textAlign: TextAlign.center,),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
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
  
  ImageWidget({
    this.url
  });
  
  final ScreenshotController screenshotController = ScreenshotController(); 
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:EdgeInsets.all(10),
      child:SizedBox(
        height:350,
        child: Column(
          children: [
            Expanded(
              child: Screenshot(
                controller: screenshotController,
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
                          child: Text('Downloaded From Diwali greetings',style: TextStyle(color: Colors.black,fontSize: 18,fontWeight: FontWeight.w600),),
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
            ),
            Container(
              height: 60,
              color: Colors.purple,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  RaisedButton(
                    child: Text('Download',style: TextStyle(color:Colors.white,)),
                    onPressed: (){
                      screenshotController
                          .capture()
                          .then((File image) async {
                            final result =
                              await ImageGallerySaver.saveImage(image.readAsBytesSync()); 
                          Fluttertoast.showToast(msg: 'Image saved',gravity:ToastGravity.TOP,textColor:Colors.white,backgroundColor:Colors.green);
                        });
                    },
                    color: Colors.amber,
                  ),
                  SizedBox(width:20),
                  RaisedButton(
                    child: Text('Download without watermark',style: TextStyle(color:Colors.white,)),
                    onPressed: ()async{
                      // FIRST SHOW REWARD AD
                      RewardedVideoAd.instance.listener= (RewardedVideoAdEvent event,{String rewardType, int rewardAmount}) async{
                        if(event==RewardedVideoAdEvent.rewarded)
                        await ImageDownloader.downloadImage("$url").then((value){
                        Fluttertoast.showToast(msg: 'Image saved',gravity:ToastGravity.BOTTOM,textColor:Colors.white,backgroundColor:Colors.green);
                      });
                      };
                      RewardedVideoAd.instance.load(adUnitId: 'ca-app-pub-8295782880270632/4119054313').then((value) => RewardedVideoAd.instance.show());
                      
                    },
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

