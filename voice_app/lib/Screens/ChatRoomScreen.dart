import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:voice_app/helper/constants.dart';
import 'package:voice_app/helper/helperfunctions.dart';
import 'package:voice_app/helper/theme.dart';
import 'package:voice_app/services/database.dart';
import 'ChatMessages.dart';
import 'ChatMessages.dart';
import 'bottom_bar.dart';


class ChatRoomScreen extends StatefulWidget {
  const ChatRoomScreen({ Key key }) : super(key: key);

  @override
  _ChatRoomScreenState createState() => _ChatRoomScreenState();
}

class _ChatRoomScreenState extends State<ChatRoomScreen> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  String user_pess;
  Stream chatRooms;
  String name;
  @override
  void initState() {
    getUserInfogetChats();
    currentuser();
    super.initState();
  }
  Widget chatRoomsList() {
    return StreamBuilder(
      stream: chatRooms,
      builder: (context, snapshot) {
        return snapshot.hasData
            ? ListView.builder(
            itemCount: snapshot.data.documents.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return ChatRoomsTile(
                userName: snapshot.data.documents[index].data['chatRoomId']
                    .toString()
                    .replaceAll("_", "")
                    .replaceAll(Constants.myName, ""),
                chatRoomId: snapshot.data.documents[index].data["chatRoomId"],
              );
            })
            : Container();
      },
    );
  }
  getUserInfogetChats() async {
    Constants.myName = await HelperFunctions.getUserNameSharedPreference();
    DatabaseMethods().getUserChats(Constants.myName).then((snapshots) {
      setState(() {
        chatRooms = snapshots;
        print(
            "we got the data + ${chatRooms.toString()} this is name  ${Constants.myName}");
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar:bottomappbar(),
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

              // #ff5f6d ? #ffc371

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
                      "ChatRooms",
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
                height: 600,
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 28.0),
                            child: IconButton(
                              icon: Image.asset(
                                  "Assets/Icons/Icon awesome-filter.png"),
                            ),
                          )
                        ],
                      ),
                      chatRoomsList(),
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

  Future<void> currentuser() async {
    final FirebaseUser user = await auth.currentUser();
    final uid = user.uid;
    Firestore.instance.collection('user_nme').document(uid).get().then((DocumentSnapshot snap){
      setState(() {
        name=snap['username'];
      });
    });
  }
}
class ChatRoomsTile extends StatelessWidget {
  final String userName;
  final String chatRoomId;

  ChatRoomsTile({this.userName,@required this.chatRoomId});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        print(chatRoomId);
        Route route=MaterialPageRoute(builder: (context)=> ChatMessges(userName,chatRoomId,"Assets/Images/6.png"));
        Navigator.push(context, route);
      },
      child: Column(
        children: [
          SizedBox(height: 13,),
          ListTile(
            title: Text(
              "$userName",
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 18),
            ),
            leading: CircleAvatar(
              backgroundImage: AssetImage("Assets/Images/1.png"),
              backgroundColor: Color(0xff8AF3D8),
              radius: 30,
            ),
            trailing: Image.asset(
                "Assets/Icons/Icon ionic-md-female.png"),
          ),
        ],
      ),
    );
  }
}