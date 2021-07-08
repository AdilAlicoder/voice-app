import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:voice_app/Screens/ChatRoomScreen.dart';
import 'package:voice_app/Screens/ExploreScreen.dart';
import 'package:voice_app/helper/helperfunctions.dart';
import 'package:voice_app/record/sound.dart';
import 'package:voice_app/record/sound.dart';
import 'package:voice_app/services/auth.dart';
import 'package:voice_app/services/database.dart';
import 'package:voice_app/views/chatrooms.dart';
import 'ForgotPasswordScreen.dart';
import 'ProfileScreen.dart';
import 'RegistrationScreen.dart';

import 'ChatMessages.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _obsuretext=true;
  final _key=GlobalKey<FormState>();
  AuthService authService = new AuthService();
  final  FirebaseAuth auth=FirebaseAuth.instance;
  TextEditingController email=new TextEditingController();
  TextEditingController password=new TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _key,
        child: Container(
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
          height: 850,
          width: 550,
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: 150,
                ),
                Opacity(
                  opacity: 0.9,
                  child: Container(
                    decoration: BoxDecoration(
                        color: Color(0xff9DDFD5),
                        borderRadius: BorderRadius.circular(23),
                        border: Border.all(width: 1, color: Colors.white)),
                    height: 450,
                    width: 330,
                    child: Column(
                      children: [
                        SizedBox(
                          height: 30,
                        ),
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(width: 1, color: Colors.black),
                            borderRadius: BorderRadius.circular(33),
                            color: Colors.white,
                          ),
                          height: 60,
                          width: 90,
                          child: Center(
                              child: Text(
                            "Logo",
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 18),
                          )),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          "Login",
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 23),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          width: 250,
                          child: TextFormField(
                            controller: email,
                            validator: (String value){
                              if(value.isEmpty){
                                return 'Please Enter Email';
                              };
                              return null;
                            },
                            decoration: InputDecoration(
                              hintText: "Email",
                              labelText: 'Email',
                              prefixIcon: Icon(Icons.email),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              border:  OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.red),
                                  borderRadius: BorderRadius.circular(13)),
                              filled: true,
                              fillColor: Colors.white70,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          width:250,
                          child: TextFormField(
                            obscureText: _obsuretext,
                            validator: (String value){
                              if(value.isEmpty){
                                return 'Please Enter Password';
                              };
                              return null;
                            },
                            controller: password,
                            decoration: InputDecoration(
                              hintText: "Password",
                              labelText: 'Password',
                              prefixIcon: Icon(
                                Icons.lock,
                                color: Colors.black,
                              ),
                              suffixIcon: IconButton(
                                icon: Icon(Icons.visibility),
                                onPressed: (){
                                  setState(() {
                                    _obsuretext=!_obsuretext;
                                  });
                                },
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              border:  OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.red),
                                  borderRadius: BorderRadius.circular(8.0)),
                              filled: true,
                              fillColor: Colors.white70,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        GestureDetector(
                          onTap: (){
                            loginuser();
                          },
                          child: Container(
                            height: 50,
                            width: 150,
                            decoration: BoxDecoration(
                                color: Color(0xff3E96ED),
                                borderRadius: BorderRadius.circular(13)),
                            child: Center(
                              child: Text(
                                "Login",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 21),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => RegistrationScreen()));
                          },
                          child: Text(
                            "Create a new account",
                            style: TextStyle(
                                color: Colors.blue,
                                decoration: TextDecoration.underline,
                                // fontWeight: FontWeight.bold,
                                fontSize: 18),
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ForgotPassword()));
                          },
                          child: Text(
                            "Forgot Password",
                            style: TextStyle(
                                color: Colors.blue,
                                decoration: TextDecoration.underline,
                                //fontWeight: FontWeight.bold,
                                fontSize: 18),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> loginuser() async {
    if (_key.currentState.validate()) {
      await authService
          .signInWithEmailAndPassword(
          email.text, password.text)
          .then((result) async {
        if (result != null)  {
          QuerySnapshot userInfoSnapshot =
          await DatabaseMethods().getUserInfo(email.text);
          HelperFunctions.saveUserLoggedInSharedPreference(true);
          HelperFunctions.saveUserNameSharedPreference(
              userInfoSnapshot.documents[0].data["userName"]);
          HelperFunctions.saveUserEmailSharedPreference(
              userInfoSnapshot.documents[0].data["userEmail"]);
          Route route=MaterialPageRoute(builder: (context)=>ExploreScreen());
          Navigator.push(context, route);
        } else {
          print('null');
        }
      });
    }
  }
  }

class MyClip extends CustomClipper<Rect> {
  Rect getClip(Size size) {
    return Rect.fromLTWH(0, 0, 100, 100);
  }

  bool shouldReclip(oldClipper) {
    return false;
  }
}
