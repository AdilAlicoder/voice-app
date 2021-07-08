import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:voice_app/helper/constants.dart';
import 'package:voice_app/services/database.dart';
import 'package:voice_app/widget/widget.dart';
import 'ChatRoomScreen.dart';
import 'bottom_bar.dart';

class ChatMessges extends StatefulWidget {
  final String chatRoomId;
  final String userName;
  final String img;
  ChatMessges(this.userName,this.chatRoomId, this.img);

  @override
  _ChatMessgesState createState() => _ChatMessgesState();
}

class _ChatMessgesState extends State<ChatMessges> {
  _ChatMessgesState();
  Stream<QuerySnapshot> chats;
  ScrollController _scrollController=ScrollController();
  _scrollToBottom() {
    _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
  }
  TextEditingController messageEditingController = new TextEditingController();

  Widget chatMessages() {
    return StreamBuilder(
      stream: chats,
      builder: (context, snapshot) {
        return snapshot.hasData
            ? SizedBox(
          height: MediaQuery.of(context).size.height/1.3,
              child: ListView.builder(
                controller: _scrollController,
                  itemCount: snapshot.data.documents.length,
                  itemBuilder: (context, index) {
                    return MessageTile(
                      message: snapshot.data.documents[index].data["message"],
                      sendByMe: Constants.myName ==
                          snapshot.data.documents[index].data["sendBy"],
                    );
                  }),
            )
            : Container();
      },
    );
  }

  addMessage() {
    print(widget.chatRoomId);
    if (messageEditingController.text.isNotEmpty) {
      Map<String, dynamic> chatMessageMap = {
        "sendBy": Constants.myName,
        "message": messageEditingController.text,
        'image':widget.img,
        'time': DateTime.now().millisecondsSinceEpoch,
      };

      DatabaseMethods().addMessage(widget.chatRoomId, chatMessageMap);

      setState(() {
        messageEditingController.text = "";
      });
    }
  }

  @override
  void initState() {
    DatabaseMethods().getChats(widget.chatRoomId).then((val) {
      setState(() {
        chats = val;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor:Color(0xffE4E4C9),
        leading:InkWell(
          onTap: (){
            pushNewScreen(context, withNavBar: true, screen: ChatRoomScreen());
          },
            child: Image.asset('Assets/Icons/Polygon 1.png')),
        title: Row(
          children: [
            CircleAvatar(backgroundColor: Color(0xff8AF3D8),backgroundImage: AssetImage(widget.img),radius: 25,),
            SizedBox(width: 15,),
            Text(widget.userName,style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 15
            ),),
          ],
        ),
      ),
      body: Container(
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
              )),
          child: Stack(
            children: [
              chatMessages(),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  color: Color(0xffD9F1E8),
                  height: 65,
                  width: MediaQuery.of(context).size.width,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left:15.0,right: 20),
                        child: Container(
                          height: 50,
                          width: 250,
                          child: Card(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(13)
                            ),
                            child: TextFormField(
                              controller: messageEditingController,
                              decoration: InputDecoration(
                                  contentPadding: EdgeInsets.only(bottom: 10,left: 10),
                                  border: InputBorder.none,
                                  hintText: "Type Here",
                                  hintStyle: TextStyle(
                                    fontWeight: FontWeight.w700,


                                  )),
                            ),
                          ),
                        ),
                      ),
                      Image.asset("Assets/Icons/Icon awesome-microphone.png"),
                      SizedBox(
                        width: 10,
                      ),
                      InkWell(
                          onTap: (){
                            addMessage();
                          },
                          child: Image.asset("Assets/Icons/Path 18.png"))
                    ],),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MessageTile extends StatelessWidget {
  final String message;
  final bool sendByMe;

  MessageTile({@required this.message, @required this.sendByMe});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
          top: 8, bottom: 8, left: sendByMe ? 0 : 24, right: sendByMe ? 24 : 0),
      alignment: sendByMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin:
            sendByMe ? EdgeInsets.only(left: 30) : EdgeInsets.only(right: 30),
        padding: EdgeInsets.only(top: 17, bottom: 17, left: 20, right: 20),
        decoration: BoxDecoration(
            borderRadius: sendByMe
                ? BorderRadius.only(
                    topLeft: Radius.circular(23),
                    topRight: Radius.circular(23),
                    bottomLeft: Radius.circular(23))
                : BorderRadius.only(
                    topLeft: Radius.circular(23),
                    topRight: Radius.circular(23),
                    bottomRight: Radius.circular(23)),
            gradient: LinearGradient(
              colors: sendByMe
                  ? [const Color(0xff007EF4), const Color(0xff2A75BC)]
                  : [Colors.white,Colors.white],
            )),
        child: InkWell(
          onTap: (){
            print('message');
          },
          child: Text(message,
              textAlign: TextAlign.start,
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 17,
                  fontFamily: 'OverpassRegular',
                  fontWeight: FontWeight.w400)),
        ),
      ),
    );
  }
}
