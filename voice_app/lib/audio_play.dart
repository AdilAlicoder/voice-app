import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool _isPlaying = false;
  AudioPlayer audioPlayer;
  var path;
  final FirebaseAuth auth = FirebaseAuth.instance;
  String uid;
  @override
  void initState() {
    super.initState();
    getpath();
    audioPlayer = AudioPlayer();
  }
  playAudioFromLocalStorage(path) async {
    int response = await audioPlayer.play(path, isLocal: true);
    if (response == 1) {
      // success

    } else {
      print('Some error occured in playing from storage!');
    }
  }
  pauseAudio() async {
    int response = await audioPlayer.pause();
    if (response == 1) {
      // success

    } else {
      print('Some error occured in pausing');
    }
  }
  stopAudio() async {
    int response = await audioPlayer.stop();
    if (response == 1) {
      // success

    } else {
      print('Some error occured in stopping');
    }
  }
  resumeAudio() async {
    int response = await audioPlayer.resume();
    if (response == 1) {
      // success

    } else {
      print('Some error occured in resuming');
    }
  }
  @override

  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      RaisedButton(
                        onPressed: () {
                          if (_isPlaying == true) {
                            pauseAudio();
                            setState(() {
                              _isPlaying = false;
                            });
                          } else {
                            resumeAudio();
                            setState(() {
                              _isPlaying = true;
                            });
                          }
                        },
                        child:
                        Icon(_isPlaying ? Icons.pause : Icons.play_arrow),
                        color: Colors.blue,
                      ),
                      RaisedButton(
                        onPressed: () {
                          stopAudio();
                          setState(() {
                            _isPlaying = false;
                          });
                        },
                        child: Icon(Icons.stop),
                        color: Colors.blue,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                RaisedButton(
                  onPressed: () async {
                    await FilePicker.getFilePath(type: FileType.audio);
                    setState(() {
                      _isPlaying = true;
                    });
                    playAudioFromLocalStorage(path);
                  },
                  child: Text(
                    'Load Audio File',
                    style: TextStyle(color: Colors.white),
                  ),
                  color: Colors.blueAccent,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> getpath() async {
    final FirebaseUser user = await auth.currentUser();
    setState(() {
      uid=user.uid;
      Firestore.instance.collection('voices').document(uid).get().then((DocumentSnapshot snap){
        path=snap['path'];
      });
    });
  }
}
