import 'package:carousel_slider/carousel_controller.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';

import 'bottom_bar.dart';
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

class ProfileScreenNavigation extends StatefulWidget {
  const ProfileScreenNavigation({ Key key }) : super(key: key);

  @override
  _ProfileScreenNavigationState createState() => _ProfileScreenNavigationState();
}

class _ProfileScreenNavigationState extends State<ProfileScreenNavigation> {

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

  final List<Widget> imageSliders = imgList
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

  final CarouselController _controller = CarouselController();
  @override
  void initState() {
    super.initState();
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

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          //
                          GestureDetector(
                            onTap: () => _controller.nextPage(),



                            child: Padding(
                              padding: const EdgeInsets.only(right:20.0),
                              child: Container(
                                  child: Image.asset(
                                      "Assets/Icons/Icon material-navigate-next.png")),
                            ),
                          ),

                          Stack(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                    color: _mainColor,
                                    borderRadius: BorderRadius.circular(90)),
                                height: 170,
                                width: 170,
                                child: CarouselSlider(
                                  items: imageSliders,
                                  options: CarouselOptions(
                                      enlargeCenterPage: true, height: 200),
                                  carouselController: _controller,
                                ),
                              ),
                              Positioned.fill(
                                top: -50,
                                child: Align(
                                  alignment: Alignment.bottomRight,
                                  child: Container(
                                    height: 40,
                                    width: 40,
                                    child: IconButton(
                                      icon: Icon(
                                        Icons.edit,
                                        color: Colors.grey,
                                        size: 19,
                                      ),
                                      onPressed: _openMainColorPicker,
                                    ),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.white54,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          GestureDetector(
                            onTap: () => _controller.previousPage(),
                            child: Padding(
                              padding: const EdgeInsets.only(left:20.0),
                              child: Container(
                                child: Container(
                                    child: Image.asset(
                                        "Assets/Icons/next.png")),
                              ),
                            ),
                          ),

                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 60.0, top: 30),
                        child: Row(
                          children: [
                            Text(
                              "Your Name",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 21),
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
                      SizedBox(
                          height: 20
                      ),
                      Stack(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(right:160.0),
                              child: Container(
                                decoration: BoxDecoration(
                                    color: Colors.white38,
                                    borderRadius: BorderRadius.circular(23)
                                ),

                                height: 50,
                                width: 130,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset("Assets/Icons/Icon ionic-md-male.png"),
                                    SizedBox(
                                      width: 40,
                                    ),
                                    Image.asset("Assets/Icons/Icon ionic-md-female.png")
                                  ],
                                ),

                              ),
                            ),



                          ]
                      ),
                      // Container(
                      //   decoration: BoxDecoration(
                      //       color: Color(0xff8EAFA7),
                      //       border: Border.all(width: 2, color: Colors.white),
                      //       borderRadius: BorderRadius.circular(23)),
                      //   height: 300,
                      //   width: 350,
                      //   child: MaterialColorPicker(
                      //     selectedColor: _mainColor,
                      //     allowShades: false,
                      //     onMainColorChange: (color) =>
                      //         setState(() => _tempMainColor = color),
                      //   ),
                      // ),
                      SizedBox(
                        height: 100,
                      ),
                      Container(
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
}