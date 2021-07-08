import 'package:flutter/material.dart';

class EditPassword extends StatefulWidget {
  const EditPassword({ Key key }) : super(key: key);

  @override
  _EditPasswordState createState() => _EditPasswordState();
}

class _EditPasswordState extends State<EditPassword> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(

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
            )
        ),
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
                      color: Color(0xffABC9C1),


                      borderRadius: BorderRadius.circular(23),
                      border: Border.all(width: 1,color: Colors.white)

                  ),
                  height: 450,
                  width: 330,
                  child: Column(
                    children: [
                      SizedBox(
                        height: 30,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(width: 1,color: Colors.black),
                          borderRadius: BorderRadius.circular(33),
                          color: Colors.white,
                        ),

                        height: 60,
                        width: 90,
                        child: Center(child: Text("Logo",style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 18
                        ),)),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text("Edit Password",style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 23
                      ),),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        decoration: BoxDecoration(
                            color: Colors.white70,

                            borderRadius: BorderRadius.circular(13)
                        ),
                        child: TextFormField(

                          decoration: InputDecoration(
                            border: InputBorder.none,
                            prefixIcon: Icon(
                              Icons.verified_user,
                              color: Colors.black,
                            ),
                            contentPadding: EdgeInsets.only(left: 10,top: 5),
                            hintText: "Verfication code",
                            hintStyle:  TextStyle(
                              color: Colors.grey,
                              fontWeight: FontWeight.bold,
                              fontSize: 17,
                            ),
                          ),
                        ),
                        height: 40,
                        width: 250,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        decoration: BoxDecoration(
                            color: Colors.white70,

                            borderRadius: BorderRadius.circular(13)
                        ),
                        child: TextFormField(

                          decoration: InputDecoration(
                            border: InputBorder.none,
                            prefixIcon: Icon(
                              Icons.lock,
                              color: Colors.black,
                            ),
                            contentPadding: EdgeInsets.only(left: 10,top: 5),
                            hintText: "Enter new password",
                            hintStyle:  TextStyle(
                              color: Colors.grey,
                              fontWeight: FontWeight.bold,
                              fontSize: 17,
                            ),
                          ),
                        ),
                        height: 40,
                        width: 250,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        decoration: BoxDecoration(
                            color: Colors.white70,

                            borderRadius: BorderRadius.circular(13)
                        ),
                        child: TextFormField(

                          decoration: InputDecoration(
                            border: InputBorder.none,
                            prefixIcon: Icon(
                              Icons.lock,
                              color: Colors.black,
                            ),
                            contentPadding: EdgeInsets.only(left: 10,top: 5),
                            hintText: "Password Again",
                            hintStyle:  TextStyle(
                              color: Colors.grey,
                              fontWeight: FontWeight.bold,
                              fontSize: 17,
                            ),
                          ),
                        ),
                        height: 40,
                        width: 250,
                      ),
                      SizedBox(
                        height: 40,
                      ),
                      Container(
                        height: 50,
                        width: 150,
                        decoration: BoxDecoration(
                            color: Color(0xff3E96ED),
                            borderRadius: BorderRadius.circular(13)

                        ),
                        child: Center(
                          child: Text("Confirm",style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 21
                          ),),
                        ),
                      ),

                      SizedBox(
                        height: 5,
                      ),

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


    );
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

