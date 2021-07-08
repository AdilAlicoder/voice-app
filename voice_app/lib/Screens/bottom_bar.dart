import 'package:flutter/material.dart';
import 'package:voice_app/Screens/ChatMessages.dart';
import 'package:voice_app/Screens/ChatRoomScreen.dart';
import 'package:voice_app/Screens/ExploreScreen.dart';
import 'package:voice_app/Screens/ProfileScreennavigation.dart';

class bottomappbar extends StatefulWidget {
  @override
  _bottomappbarState createState() => _bottomappbarState();
}

class _bottomappbarState extends State<bottomappbar> {
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(33.0),
      child: BottomAppBar(
         color: Color(0xff80CBCB),
        child: Container(
          height: 50,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              InkWell(
                onTap: (){
                  Route route=MaterialPageRoute(builder: (context)=> ExploreScreen());
                  Navigator.push(context, route);
                },
                  child: Image.asset("Assets/Icons/Icon awesome-user-friends.png",height: 35,width: 35,)),
              InkWell(
                  onTap: (){
                    Route route=MaterialPageRoute(builder: (context)=> ChatRoomScreen());
                    Navigator.push(context, route);
                  },
                  child: Image.asset("Assets/Icons/Icon ionic-ios-chatboxes.png",height: 35,width: 35,)),
              InkWell(
                  onTap: (){
                    Route route=MaterialPageRoute(builder: (context)=> ProfileScreenNavigation());
                    Navigator.push(context, route);
                  },
                  child: Image.asset("Assets/Icons/Icon awesome-user-edit.png",height: 35,width: 35,)),
            ],
          ),
        ),
    ),
    );
  }
}