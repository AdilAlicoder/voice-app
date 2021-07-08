import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:voice_app/helper/constants.dart';
import 'package:voice_app/services/database.dart';
import 'package:voice_app/views/search.dart';

import 'ChatMessages.dart';
import 'bottom_bar.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({Key key}) : super(key: key);

  @override
  _ExploreScreenState createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  DatabaseMethods databaseMethods = new DatabaseMethods();
  String uid;
  int i=1;
  String imgs;
  String usersname;
  AudioPlayerState audioPlayerState = AudioPlayerState.PAUSED;
  bool _isPlaying = false;
  AudioPlayer audioPlayer;
  final FirebaseAuth auth = FirebaseAuth.instance;
  Future<void> currentuser() async {
    final FirebaseUser user = await auth.currentUser();
    setState(() {
      uid=user.uid;
      Firestore.instance.collection('usersnames').document(uid).get().then((DocumentSnapshot snap){
          usersname=snap['username'];
      });
      });
  }
  Widget slider() {
    return Container(
      width: 170.0,
      child: Slider.adaptive(
          value: 0,
          max: 100,
          onChanged: (value) {
          }),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    currentuser();
    audioPlayer = AudioPlayer();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar:bottomappbar(),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
              color: Colors.green,
              gradient: LinearGradient(
                colors: [
                  Color(0xffE4E4C9),
                  //   Color(0xff80CBCB),
                  Color(0xff80CBCB)
                ],
                begin: FractionalOffset.topLeft,
                end: FractionalOffset.bottomRight,
                // begin: new Alignment(0.10, 0.5),
                // end: new Alignment(0.30, 0.10,),

                // #ff5f6d → #ffc371

                //      Color(0xffde6262)
                //    Color(0xffffb88c)
              )),
          child: Column(
            children: [
              SizedBox(
                height: 90,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 35.0),
                child: Row(
                  children: [
                    Text(
                      "Explore",
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 30),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Container(
                decoration: BoxDecoration(
                  //   border: Border.all(width: 2,color: Colors.white),
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(50),
                        topRight: Radius.circular(50))),
                height: MediaQuery.of(context).size.height/1.4,
                width: MediaQuery.of(context).size.width,
                child: Card(
                  elevation: 4,
                  color: Color(0xffABC9C1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(50),
                        topRight: Radius.circular(50)),
                  ),
                  child: Column(
                    children: [
                      StreamBuilder<QuerySnapshot>(
                        stream: Firestore.instance.collection('accounts').snapshots(),
                        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                          if (snapshot.data == null) {
                            return CircularProgressIndicator();
                          }
                          return Expanded(
                            child: ListView(
                              shrinkWrap: true,
                              children: snapshot.data.documents
                                  .map<Widget>((DocumentSnapshot document) {
                                return ui(
                                    name: document['usernames'],
                                    path: document['path'],
                                    img:document['image'],
                                    gender:document['gender']);
                              }).toList(),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget ui({name, path, img, gender}) {
    if(gender=='male'){setState(() {

    });}
    return Column(
      children: [
        SizedBox(height: 20,),
        GestureDetector(
          onTap: () {
            showDialog<void>(
                context: context,
                barrierDismissible: false,
                // false = user must tap button, true = tap outside dialog
                builder: (BuildContext dialogContext) {
                  return Container(
                    decoration: BoxDecoration(
                      //  border: Border.all(width: 2,color: Colors.white)
                        borderRadius: BorderRadius.circular(23)
                    ),
                    //height: 300,
                    // width: 300,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 130,top: 150),
                      child: AlertDialog(

                        backgroundColor: Colors.white70,

                        // title: Text('ALert!'),
                        content: SingleChildScrollView(

                          child: Column(
                            children: [
                              Stack(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left:60.0),
                                    child: Container(
                                      height: 110,
                                      width: 110,
                                      decoration: BoxDecoration(
                                        color: Color(0xff8AF3D8),
                                        shape: BoxShape.circle,

                                      ),
                                      child: Image.asset(img),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top:75.0,right: 65),
                                    child: Positioned.fill(
                                      // top: -50,
                                      child: Align(
                                          alignment: Alignment.bottomRight,
                                          child: Image.asset("Assets/Icons/Icon ionic-md-female.png")
                                        //  onPressed: getFile,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Text("$name",style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize:   19
                              ),),
                              SizedBox(height: 10,),
                              Container(
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.all(Radius.circular(20))
                                ),
                                width: 230,
                                height: 50,
                                child: Row(
                                  children: [
                                    SizedBox(width: 10,),
                                    InkWell(
                                      onTap: (){
                                        recivedata(path);
                                      },
                                      child: Icon(
                                        Icons.play_arrow,
                                        size: 30,
                                      ),
                                    ),
                                    slider(),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 5,
                              ),

                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    height: 70,
                                    width: 70,
                                    child: GestureDetector(
                                      onTap: (){
                                        Navigator.of(dialogContext)
                                            .pop();
                                      },
                                      child: Card(
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(50)
                                        ),
                                        child: Image.asset("Assets/Icons/Icon metro-cross.png"),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 50,
                                  ),
                                  Container(
                                    height: 70,
                                    width: 70,
                                    child: Card(
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(50)
                                      ),
                                      child: GestureDetector(
                                        onTap: (){
                                          Navigator.of(dialogContext)
                                              .pop();
                                          if(name==usersname){
                                            Fluttertoast.showToast(msg: "This user is login");
                                          }
                                          else {
                                            sendMessage(name,img);
                                          }
                                        },
                                          child: Image.asset("Assets/Icons/Icon awesome-heart.png")),

                                    ),
                                  ),
                                ],
                              )

                            ],
                          ),
                        ),
                        actions: <Widget>[

                        ],
                      ),
                    ),
                  );
                });
          },
          child: ListTile(
            title: Text(
              "$name",
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 18),
            ),
            leading: CircleAvatar(
              backgroundImage:
              AssetImage(img),
              backgroundColor: Color(0xff8AF3D8),
              radius: 30,
            ),
            trailing: Image.asset(gender),
          ),
        ),
      ],
    );
  }
  sendMessage(String userName, img){
    List<String> users = [Constants.myName,userName];

    String chatRoomId = getChatRoomId(Constants.myName,userName);

    Map<String, dynamic> chatRoom = {
      "users": users,
      "chatRoomId" : chatRoomId,
    };
    databaseMethods.addChatRoom(chatRoom, chatRoomId);
    Route route=MaterialPageRoute(builder: (context)=>ChatMessges(userName,chatRoomId,img));
    Navigator.push(context, route);
  }
  getChatRoomId(String a, String b) {
    if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
      return "$b\_$a";
    } else {
      return "$a\_$b";
    }
  }
  void recivedata(path) {
      setState(() {
        _isPlaying = true;
      });
      playAudioFromLocalStorage(path);
  }
  playAudioFromLocalStorage(path) async {
    int response = await audioPlayer.play(path, isLocal: true);
    if (response == 1) {
      setState(() {
        i=0;
      });
    } else {
      print('Some error occured in playing from storage!');
    }
  }
  pauseAudio() async {
    int response = await audioPlayer.pause();
    if (response == 1) {
      setState(() {
        i=1;
      });

    } else {
      print('Some error occured in pausing');
    }
  }
}