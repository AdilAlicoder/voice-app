import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:voice_app/Screens/ProfileScreen.dart';
import 'package:voice_app/helper/helperfunctions.dart';
import 'package:voice_app/services/auth.dart';
import 'package:voice_app/services/database.dart';

import 'LoginScreen.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({Key key}) : super(key: key);

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController username = TextEditingController();
  TextEditingController password_again = TextEditingController();
  AuthService authService = new AuthService();
  DatabaseMethods databaseMethods = new DatabaseMethods();
   String uid;
  final FirebaseAuth auth = FirebaseAuth.instance;
  final _key = GlobalKey<FormState>();
  bool _obsuretext = true;
  bool _obsuretext_again = true;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
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
                    height: 490,
                    width: 330,
                    child: SingleChildScrollView(
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
                            "Registration",
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
                              validator: (String value) {
                                if (value.isEmpty) {
                                  return 'Please Enter Email';
                                } else if (value.length <= 1)
                                  return 'Email to short';
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
                                border: OutlineInputBorder(
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
                            width: 250,
                            child: TextFormField(
                              obscureText: _obsuretext,
                              validator: (String value) {
                                if (value.isEmpty) {
                                  return 'Please Enter Password';
                                } else if (value.length <= 4)
                                  return 'Password to short';
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
                                  onPressed: () {
                                    setState(() {
                                      _obsuretext = !_obsuretext;
                                    });
                                  },
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.grey),
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                border: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.red),
                                    borderRadius: BorderRadius.circular(8.0)),
                                filled: true,
                                fillColor: Colors.white70,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Container(
                            width: 250,
                            child: TextFormField(
                              obscureText: _obsuretext_again,
                              validator: (String value) {
                                if (value.isEmpty) {
                                  return 'Please Enter Password';
                                } else if (password.text != password_again.text)
                                  return 'Password is not match';
                                return null;
                              },
                              controller: password_again,
                              decoration: InputDecoration(
                                hintText: "Password Again",
                                labelText: 'Password Again',
                                prefixIcon: Icon(
                                  Icons.lock,
                                  color: Colors.black,
                                ),
                                suffixIcon: IconButton(
                                  icon: Icon(Icons.visibility),
                                  onPressed: () {
                                    setState(() {
                                      _obsuretext_again = !_obsuretext_again;
                                    });
                                  },
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.grey),
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                border: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.red),
                                    borderRadius: BorderRadius.circular(8.0)),
                                filled: true,
                                fillColor: Colors.white70,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          InkWell(
                            onTap: () {
                              signupclick();
                            },
                            child: Container(
                              height: 50,
                              width: 150,
                              decoration: BoxDecoration(
                                  color: Color(0xff3E96ED),
                                  borderRadius: BorderRadius.circular(13)),
                              child: Center(
                                child: Text(
                                  "Register",
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
                                      builder: (context) => LoginScreen()));
                            },
                            child: Text(
                              "Already have an account",
                              style: TextStyle(
                                  color: Colors.blue,
                                  decoration: TextDecoration.underline,
                                  // fontWeight: FontWeight.bold,
                                  fontSize: 18),
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                        ],
                      ),
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

  Future<void> signupclick() async {
    if(_key.currentState.validate()){
      await authService.signUpWithEmailAndPassword(email.text,
          password.text).then((result){
        if(result != null){
          Navigator.pushReplacement(context, MaterialPageRoute(
              builder: (context) => ProfileScreen(username.text,email.text),
          ));
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
