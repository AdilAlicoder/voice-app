import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_audio_recorder/flutter_audio_recorder.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path_provider/path_provider.dart';

import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:voice_app/helper/helperfunctions.dart';
import 'package:voice_app/services/database.dart';

import 'ExploreScreen.dart';
import 'RecordListView.dart';
import 'RecorderView.dart';
final List<String> imgList = [
  "Assets/Images/1.png",
  "Assets/Images/2.png",
  "Assets/Images/3.png",
  "Assets/Images/4.png",
  "Assets/Images/5.png",
  "Assets/Images/6.png"

  // 'https://images.unsplash.com/photo-1520342868574-5fa3804e551c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=6ff92caffcdd63681a35134a6770ed3b&auto=format&fit=crop&w=1951&q=80',
  // 'https://images.unsplash.com/photo-1522205408450-add114ad53fe?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=368f45b0888aeb0b7b08e3a1084d3ede&auto=format&fit=crop&w=1950&q=80',
  // 'https://images.unsplash.com/photo-1519125323398-675f0ddb6308?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=94a1e718d89ca60a6337a6008341ca50&auto=format&fit=crop&w=1950&q=80',
  // 'https://images.unsplash.com/photo-1523205771623-e0faa4d2813d?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=89719a0d55dd05e2deae4120227e6efc&auto=format&fit=crop&w=1953&q=80',
  // 'https://images.unsplash.com/photo-1508704019882-f9cf40e475b4?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=8c6e5e3aba713b17aa1fe71ab4f0ae5b&auto=format&fit=crop&w=1352&q=80',
  // 'https://images.unsplash.com/photo-1519985176271-adb1088fa94c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=a0c8d632e977f94e5d312d9893258f59&auto=format&fit=crop&w=1355&q=80'
];

class ProfileScreen extends StatefulWidget {
  final String username;
  final String text;
  ProfileScreen(this.username,this.text);

  @override
  _ProfileScreenState createState() => _ProfileScreenState(username);

  void save() {}
}

class _ProfileScreenState extends State<ProfileScreen> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  DatabaseMethods databaseMethods = new DatabaseMethods();
  TextEditingController name=new TextEditingController();
  String uid;
  int pge;
  String gender_check;
  String image_s;
  String _uploadedFileURL;
  AssetImage image;
  var files;
  Directory appDirectory;
  Stream<FileSystemEntity> fileStream;
  List<String> records;
  IconData _recordIcon = Icons.mic_none;
  MaterialColor colo = Colors.orange;
  RecordingStatus _currentStatus = RecordingStatus.Unset;
  bool stop = false;
  Recording _current;
  var index=0;
  final controller=PageController(

      initialPage: 0
  );
  // Recorder properties
  FlutterAudioRecorder audioRecorder;
  final String user_nme;
  _ProfileScreenState(this.user_nme);
  @override
  void initState() {
    super.initState();
    currentuser();
    FlutterAudioRecorder.hasPermissions.then((hasPermision) {
      if (hasPermision) {
        _currentStatus = RecordingStatus.Initialized;
        _recordIcon = Icons.mic;
      }
    });
  }
  Future<void> currentuser() async {
    final FirebaseUser user = await auth.currentUser();
    setState(() {
      uid=user.uid;
    });
  }
  @override
  void dispose() {
    _currentStatus = RecordingStatus.Unset;
    audioRecorder = null;
    super.dispose();
  }
  ColorSwatch _tempMainColor;
  Color _tempShadeColor;
  ColorSwatch _mainColor = Colors.blue;
  Color _shadeColor = Colors.blue[800];

  void _openDialog(String title, Widget content) {
    showDialog(
      context: context,
      builder: (_) {
        SizedBox(
          height: 70,
        );
        return Container(
          height: 200,
          width: 300,
          child: Padding(
            padding: const EdgeInsets.only(top: 230.0, bottom: 70),
            child: AlertDialog(
              backgroundColor: Color(0xff80CBCB),
              contentPadding: const EdgeInsets.all(6.0),
              title: Text(title),
              content: content,
              actions: [
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                    setState(() => _mainColor = _tempMainColor);
                    setState(() => _shadeColor = _tempShadeColor);
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 48.0),
                        child: Container(
                          height: 60,
                          width: 110,
                          child: Card(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(23)),
                            color: Color(0xff5199EF),
                            child: Center(
                                child: Text("Done",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold))),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _openColorPicker() async {
    _openDialog(
      "Color picker",
      MaterialColorPicker(
        selectedColor: _shadeColor,
        onColorChange: (color) => setState(() => _tempShadeColor = color),
        onMainColorChange: (color) => setState(() => _tempMainColor = color),
        onBack: () => print("Back button pressed"),
      ),
    );
  }

  void _openMainColorPicker() async {
    _openDialog(
      "Please Choose a color",
      MaterialColorPicker(
        selectedColor: _mainColor,
        allowShades: false,
        onMainColorChange: (color) => setState(() => _tempMainColor = color),
      ),
    );
  }

  void _openAccentColorPicker() async {
    _openDialog(
      "Accent Color picker",
      MaterialColorPicker(
        colors: accentColors,
        selectedColor: _mainColor,
        onMainColorChange: (color) => setState(() => _tempMainColor = color),
        circleSize: 40.0,
        spacing: 10,
      ),
    );
  }

  void _openFullMaterialColorPicker() async {
    _openDialog(
      "Full Material Color picker",
      MaterialColorPicker(
        colors: fullMaterialColors,
        selectedColor: _mainColor,
        onMainColorChange: (color) => setState(() => _tempMainColor = color),
      ),
    );
  }

 /* final List<Widget> imageSliders = imgList
      .map((item) => Container(
    child: Container(
      margin: EdgeInsets.only(top: 70.0, left: 30, right: 30),
      child: ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(5.0)),
          child: Stack(
            children: <Widget>[
              // Image.network(item, fit: BoxFit.cover, width: 800.0),
              Image.asset(
                item,
                fit: BoxFit.cover,
                width: 800,
              ),
              Positioned(
                bottom: 0.0,
                left: 0.0,
                right: 0.0,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(33),
                    gradient: LinearGradient(
                      colors: [
                        Color.fromARGB(200, 0, 0, 0),
                        Color.fromARGB(0, 0, 0, 0)
                      ],
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                    ),
                  ),
                ),
              ),
            ],
          )),
    ),
  ))
      .toList();

  final CarouselController _controller = CarouselController();*/


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
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
        child: SingleChildScrollView(
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
                      "Profile",
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
                height: 620,
                width: MediaQuery.of(context).size.width,
                child: Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(33),
                          topRight: Radius.circular(33))),
                  color: Color(0xffABC9C1),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 40,
                      ),
                      SizedBox(
                        height: 170,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                              icon: Icon(Icons.arrow_back_ios,size: 40,color: Colors.grey),
                              onPressed:() {
                                controller.previousPage(
                                    duration: Duration(milliseconds: 100),
                                    curve: Curves.easeIn
                                );
                              },
                            ),
                            SizedBox(width: 25,),
                            Column(
                              children: [
                                Stack(
                                  children: [
                                    CircleAvatar(
                                      radius: 70,
                                      child: PageView(
                                        onPageChanged:_onPageViewChange,
                                        controller: controller,
                                        children: [
                                          Image.asset("Assets/Images/1.png"),
                                          Image.asset("Assets/Images/2.png"),
                                          Image.asset("Assets/Images/3.png"),
                                          Image.asset("Assets/Images/4.png",),
                                          Image.asset("Assets/Images/5.png",),
                                          Image.asset("Assets/Images/6.png"),
                                        ],
                                      ),
                                      backgroundColor: _mainColor,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 108,left: 95),
                                      child: IconButton(
                                        icon: Icon(
                                          Icons.edit,
                                          color: Colors.grey,
                                          size: 30,
                                        ),
                                        onPressed: (){
                                          _openMainColorPicker();
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(width: 10,),
                            IconButton(
                              icon: Icon(Icons.arrow_forward_ios,size: 40,color: Colors.grey),
                              onPressed: () {
                                controller.nextPage(
                                    duration: Duration(milliseconds: 100),
                                    curve: Curves.easeIn
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                     Padding(
                        padding: const EdgeInsets.only(left: 60.0, top: 30),
                        child: Row(
                          children: [
                            Container(
                              height: 50,
                              width: 200,
                              child: TextFormField(
                                controller: name,
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: "Your Name",
                                    hintStyle: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold
                                    )
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Icon(
                              Icons.edit,
                              color: Colors.grey,
                            )
                          ],
                        ),
                      ),
                      SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Align(
                          alignment: Alignment.bottomLeft,
                            child: Text('Select Your Gender',style: TextStyle(fontSize: 17,color: Colors.black,fontWeight: FontWeight.bold),)),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 20),
                        child: Row(
                          children: [
                            Column(
                              children: [
                                InkWell(
                                  onTap:(){
                                    Fluttertoast.showToast(msg: "Male is selected");
                                    setState(() {
                                      gender_check='Assets/Icons/Icon ionic-md-male.png';
                                    });
                                  },
                                    child: Image.asset('Assets/Icons/Icon ionic-md-male.png')),
                                Text('Male',style: TextStyle(fontSize: 15,color: Colors.black),),
                              ],
                            ),
                            SizedBox(width: 30,),
                            Column(
                              children: [
                                InkWell(
                                    onTap:(){
                                      Fluttertoast.showToast(msg: "FeMale is selected");
                                      setState(() {
                                        gender_check='Assets/Icons/Icon ionic-md-female.png';
                                      });
                                    },
                                    child: Image.asset('Assets/Icons/Icon ionic-md-female.png')),
                                Text('FeMale',style: TextStyle(fontSize: 15,color: Colors.black),),
                              ],
                            ),
                          ],
                        ),
                      ),
                      /*Stack(children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 160.0),
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.white38,
                                borderRadius: BorderRadius.circular(23)),
                            height: 50,
                            width: 130,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                    "assets/Icons/Icon ionic-md-male.png"),
                                SizedBox(
                                  width: 40,
                                ),
                                Image.asset(
                                    "assets/Icons/Icon ionic-md-female.png")
                              ],
                            ),
                          ),
                        ),
                      ]),*/
                  Stack(
                        alignment: Alignment.center,
                        children: [
                          Column(
                            children: [
                              SizedBox(height: 20,),
                              Text(
                                _current?.duration?.toString()?.substring(0, 7) ?? "0:0:0:0",
                                style: TextStyle(color: Colors.black, fontSize: 20),
                              ),
                              SizedBox(height: 20,),
                              stop == false
                                  ? RaisedButton(
                                color: Colors.red,
                                onPressed: () async {
                                  await _onRecordButtonPressed();
                                  setState(() {});
                                },
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Column(
                                  children: [
                                    Container(
                                      child:Image.asset('Assets/Icons/Icon feather-mic.png'),
                                      ),
                                  ],
                                ),
                              )
                                  : Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    RaisedButton(
                                      color: colo,
                                      onPressed: () async {
                                        await _onRecordButtonPressed();
                                        setState(() {});
                                      },
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Container(
                                        width: 40,
                                        height: 40,
                                        child: Icon(
                                          _recordIcon,
                                          color: Colors.white,
                                          size: 40,
                                        ),
                                      ),
                                    ),
                                    RaisedButton(
                                      color: Colors.orange,
                                      onPressed: _currentStatus != RecordingStatus.Unset
                                          ? _stop
                                          : null,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Container(
                                        width: 40,
                                        height: 40,
                                        child: Icon(
                                          Icons.stop,
                                          color: Colors.white,
                                          size: 40,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                            ],
                          ),
                        ],
                      ),
                      Expanded(
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: GestureDetector(
                            onTap: () {
                              inputdata();
                            },
                            child: Container(
                              height: 50,
                              width: 100,
                              child: Card(
                                color: Color(0xff5199EF),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(23)),
                                child: Center(
                                    child: Text("Done",
                                        style: TextStyle(
                                          color: Colors.white,
                                        ))),
                              ),
                            ),
                          ),
                        ),
                      )
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

  Future<void> inputdata() async {
    if(files==null){
      Fluttertoast.showToast(msg: "Please record voice");
    }
    else{
      if(pge==0){
        setState(() {
          image_s="Assets/Images/1.png";
        });
      }
      if(pge==1){
        setState(() {
          image_s="Assets/Images/2.png";
        });
      }
      if(pge==2){
        setState(() {
          image_s="Assets/Images/3.png";
        });
      }
      if(pge==3){
        setState(() {
          image_s="Assets/Images/4.png";
        });
      }
      if(pge==4){
        setState(() {
          image_s="Assets/Images/5.png";
        });
      }
      if(pge==5){
        setState(() {
          image_s="Assets/Images/6.png";
        });
      }
      Map<String,String> userDataMap = {
        "userName" : name.text,
        "userEmail" :widget.text
      };

      databaseMethods.addUserInfo(userDataMap);

      HelperFunctions.saveUserLoggedInSharedPreference(true);
      HelperFunctions.saveUserNameSharedPreference(name.text);
      HelperFunctions.saveUserEmailSharedPreference(widget.text);
      Firestore.instance.collection('accounts').document().setData({
        'usernames':name.text,
        'path':files,
        'image':image_s,
        'gender':gender_check
      });
      Firestore.instance.collection('usersnames').document(uid).setData({
        'username':name.text,
      });
        Route route=MaterialPageRoute(builder: (context)=> ExploreScreen());
        Navigator.push(context, route);
    }
  }
  Future<void> _onRecordButtonPressed() async {
    switch (_currentStatus) {
      case RecordingStatus.Initialized:
        {
          _recordo();
          break;
        }
      case RecordingStatus.Recording:
        {
          _pause();
          break;
        }
      case RecordingStatus.Paused:
        {
          _resume();
          break;
        }
      case RecordingStatus.Stopped:
        {
          _recordo();
          break;
        }
      default:
        break;
    }
  }

  _initial() async {
    Directory appDir = await getExternalStorageDirectory();
    String jrecord = 'Audiorecords';
    String dato = "${DateTime.now()?.millisecondsSinceEpoch?.toString()}.wav";
    Directory appDirec =
    Directory("${appDir.parent.parent.parent.parent.path}/$jrecord/");
    if (await appDirec.exists()) {
      String patho = "${appDirec.path}$dato";
      audioRecorder = FlutterAudioRecorder(patho, audioFormat: AudioFormat.WAV);
      await audioRecorder.initialized;
    } else {
      appDirec.create(recursive: true);
      Fluttertoast.showToast(msg: "Start Recording , Press Start");
      String patho = "${appDirec.path}$dato";
      audioRecorder = FlutterAudioRecorder(patho, audioFormat: AudioFormat.WAV);
      await audioRecorder.initialized;
    }
  }

  _start() async {
    await audioRecorder.start();
    var recording = await audioRecorder.current(channel: 0);
    setState(() {
      _current = recording;
    });

    const tick = const Duration(milliseconds: 50);
    new Timer.periodic(tick, (Timer t) async {
      if (_currentStatus == RecordingStatus.Stopped) {
        t.cancel();
      }

      var current = await audioRecorder.current(channel: 0);
      // print(current.status);
      setState(() {
        _current = current;
        _currentStatus = _current.status;
      });
    });
  }

  _resume() async {
    await audioRecorder.resume();
    Fluttertoast.showToast(msg: "Resume Recording");
    setState(() {
      _recordIcon = Icons.pause;
      colo = Colors.red;
    });
  }

  _pause() async {
    await audioRecorder.pause();
    Fluttertoast.showToast(msg: "Pause Recording");
    setState(() {
      _recordIcon = Icons.mic;
      colo = Colors.green;
    });
  }

  _stop() async {
    var result = await audioRecorder.stop();
    print(result.path);
    setState(() {
      files=result.path;
    });
    Firestore.instance.collection('voices').document(uid).setData({
      'path':result.path
    });
    Fluttertoast.showToast(msg: "Stop Recording , File Saved");
    widget.save();
    setState(() {
      _current = result;
      _currentStatus = _current.status;
      _current.duration = null;
      _recordIcon = Icons.mic;
      stop = false;
    });
  }

  Future<void> _recordo() async {
    if (await FlutterAudioRecorder.hasPermissions) {
      await _initial();
      await _start();
      Fluttertoast.showToast(msg: "Start Recording");
      setState(() {
        _currentStatus = RecordingStatus.Recording;
        _recordIcon = Icons.pause;
        colo = Colors.red;
        stop = true;
      });
    } else {
      Fluttertoast.showToast(msg: "Allow App To Use Mic");
    }
  }

  _onPageViewChange(int page) {
    setState(() {
      pge=page;
      print(page);
    });
  }
}
