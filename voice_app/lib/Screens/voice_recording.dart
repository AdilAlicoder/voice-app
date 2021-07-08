import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_audio_recorder/flutter_audio_recorder.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path_provider/path_provider.dart';

class voice_recording extends StatefulWidget {
  final Function save;
  const voice_recording({Key key, @required this.save}) : super(key: key);
  @override
  _voice_recordingState createState() => _voice_recordingState();
}

class _voice_recordingState extends State<voice_recording> {
  IconData _recordIcon = Icons.mic_none;
  MaterialColor colo = Colors.orange;
  RecordingStatus _currentStatus = RecordingStatus.Unset;
  bool stop = false;
  final FirebaseAuth auth = FirebaseAuth.instance;
  String uid;
  Recording _current;
  // Recorder properties
  FlutterAudioRecorder audioRecorder;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            SizedBox(height: MediaQuery.of(context).size.height/1.4,),
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
                      color: Colors.orange,
                      onPressed: () async {
                        await _onRecordButtonPressed();
                        setState(() {});
                      },
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        children: [
                          Container(
                            width: 80,
                            height: 80,
                            child: Icon(
                              _recordIcon,
                              color: Colors.white,
                              size: 80,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text("Write Dailry",style: TextStyle(color: Colors.white),),
                          )
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
                              width: 80,
                              height: 80,
                              child: Icon(
                                _recordIcon,
                                color: Colors.white,
                                size: 50,
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
                              width: 80,
                              height: 80,
                              child: Icon(
                                Icons.stop,
                                color: Colors.white,
                                size: 50,
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
          ],
        ),
      ),
    );
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
}