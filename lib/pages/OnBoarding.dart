import 'package:carriage_rider/pages/Terms.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class OnBoarding extends StatefulWidget {
  @override
  _OnBoardingState createState() => _OnBoardingState();
}

class _OnBoardingState extends State<OnBoarding> {
  void _onIntroEnd(context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => TermsOfService()),
    );
  }

  final List<String> text = [
    'Welcome to Carriage',
    'Schedule Rides Easily',
    'Live Updates',
    'With CULift'
  ];

  final List<String> subText = [
    'Paratransit ride app made by Cornell DTI with CULift',
    'Request and edit rides',
    'Check your driver’s location and your ETA from the app',
    'Transportation service provided by CULift'
  ];

  int _slideIndex = 0;
  final int _numPages = 4;
  final PageController _pageController = PageController(initialPage: 0);

  List<Widget> _buildPageIndicator() {
    List<Widget> list = [];
    for (int i = 0; i < _numPages; i++) {
      list.add(i == _slideIndex ? _indicator(true) : _indicator(false));
    }
    return list;
  }

  Widget _indicator(bool isActive) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 150),
      margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 16.0),
      height: 10.0,
      width: isActive ? 10.0 : 10.0,
      decoration: BoxDecoration(
        color: isActive ? Colors.grey : Colors.white,
        borderRadius: BorderRadius.circular(15.0),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
          decoration: BoxDecoration(),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 5.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  height: 600.0,
                  child: PageView(
                    physics: ClampingScrollPhysics(),
                    controller: _pageController,
                    onPageChanged: (int page) {
                      setState(() {
                        _slideIndex = page;
                      });
                    },
                    children: <Widget>[
                      Stack(
                        alignment: Alignment.topCenter,
                        children: [
                          Column(
                            children: [
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.10,
                              ),
                              Text(
                                text[_slideIndex],
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                height: 20.0,
                              ),
                              Padding(
                                padding:
                                    EdgeInsets.only(left: 20.0, right: 20.0),
                                child: Text(
                                  subText[_slideIndex],
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 17.0, color: Color(0xFFA6A6A6)),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 15.0),
                          Positioned(
                              bottom: 350,
                              right: 100,
                              child: SvgPicture.asset(
                                  'assets/images/onboard_1/c2.svg')),
                          Positioned(
                              bottom: 250,
                              left: 50,
                              child: SvgPicture.asset(
                                  'assets/images/onboard_1/c1.svg')),
                          Positioned(
                              bottom: 0,
                              left: 0,
                              child: SvgPicture.asset(
                                  'assets/images/onboard_1/Group 4 Copy.svg')),
                          Positioned(
                              bottom: 0,
                              left: 125,
                              child: SvgPicture.asset(
                                  'assets/images/onboard_1/t1.svg')),
                          Positioned(
                              bottom: 0,
                              right: 0,
                              child: Image.asset(
                                  'assets/images/onboard_1/cornell 1.png')),
                        ],
                      ),
                      Stack(
                        alignment: Alignment.topCenter,
                        children: [
                          Column(
                            children: [
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.10,
                              ),
                              Text(
                                text[_slideIndex],
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                height: 20.0,
                              ),
                              Padding(
                                padding:
                                    EdgeInsets.only(left: 20.0, right: 20.0),
                                child: Text(
                                  subText[_slideIndex],
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 17.0, color: Color(0xFFA6A6A6)),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 15.0),
                          Positioned(
                              bottom: 350,
                              left: 50,
                              child: SvgPicture.asset(
                                'assets/images/onboard_2/c2.svg',
                              )),
                          Positioned(
                              bottom: 400,
                              right: 0,
                              child: SvgPicture.asset(
                                  'assets/images/onboard_2/c3.svg')),
                          Positioned(
                              bottom: 0,
                              left: 20,
                              child: SvgPicture.asset(
                                  'assets/images/onboard_2/t1.svg')),
                          Positioned(
                              bottom: 0,
                              left: 5,
                              child: SvgPicture.asset(
                                  'assets/images/onboard_2/Group 4 Copy.svg')),
                          Positioned(
                              bottom: 0,
                              right: 30,
                              child: Image.asset(
                                  'assets/images/onboard_2/cornell 1.png')),
                        ],
                      ),
                      Stack(
                        alignment: Alignment.topCenter,
                        children: [
                          Column(
                            children: [
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.10,
                              ),
                              Text(
                                text[_slideIndex],
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                height: 20.0,
                              ),
                              Padding(
                                padding:
                                    EdgeInsets.only(left: 20.0, right: 20.0),
                                child: Text(
                                  subText[_slideIndex],
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 17.0, color: Color(0xFFA6A6A6)),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 15.0),
                          Positioned(
                              bottom: 400,
                              left: 75,
                              child: SvgPicture.asset(
                                  'assets/images/onboard_3/c3.svg')),
                          Positioned(
                              bottom: 225,
                              right: 0,
                              child: SvgPicture.asset(
                                  'assets/images/onboard_3/c4.svg')),
                          Positioned(
                              bottom: 0,
                              right: 0,
                              child: SvgPicture.asset(
                                  'assets/images/onboard_3/tree2.svg')),
                          Positioned(
                              bottom: 0,
                              left: 20,
                              child: Image.asset(
                                  'assets/images/onboard_3/cornell 1.png')),
                          Positioned(
                              bottom: 0,
                              left: 125,
                              child: SvgPicture.asset(
                                  'assets/images/onboard_3/Group 4 Copy.svg')),
                        ],
                      ),
                      Stack(
                        alignment: Alignment.topCenter,
                        children: [
                          Column(
                            children: [
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.10,
                              ),
                              Text(
                                text[_slideIndex],
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                height: 20.0,
                              ),
                              Padding(
                                padding:
                                    EdgeInsets.only(left: 20.0, right: 20.0),
                                child: Text(
                                  subText[_slideIndex],
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 17.0, color: Color(0xFFA6A6A6)),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 15.0),
                          Positioned(
                              bottom: 225,
                              left: 0,
                              child: SvgPicture.asset(
                                  'assets/images/onboard_4/c4.svg')),
                          Positioned(
                              bottom: 0,
                              left: 100,
                              child: SvgPicture.asset(
                                  'assets/images/onboard_4/tree2.svg')),
                          Positioned(
                              bottom: 0,
                              right: 0,
                              child: SvgPicture.asset(
                                  'assets/images/onboard_4/Group 4 Copy.svg')),
                        ],
                      ),
                    ],
                  ),
                ),
                _slideIndex != _numPages - 1
                    ? Expanded(
                        child: Align(
                            alignment: Alignment.bottomCenter,
                            child: Container(
                              height: MediaQuery.of(context).size.height,
                              color: Colors.black,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: _buildPageIndicator(),
                              ),
                            )),
                      )
                    : Expanded(
                        child: Align(
                            child: Container(
                        height: MediaQuery.of(context).size.height * 0.20,
                        color: Colors.black,
                        child: Align(
                            alignment: Alignment.center,
                            child: ButtonTheme(
                                minWidth:
                                    MediaQuery.of(context).size.width * 0.8,
                                height: 50.0,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                child: RaisedButton(
                                    onPressed: () {
                                      _onIntroEnd(context);
                                    },
                                    elevation: 2.0,
                                    color: Colors.white,
                                    textColor: Colors.black,
                                    child: Text('Begin Now',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 17))))),
                      )))
              ],
            ),
          ),
        ),
        bottomSheet: Container(
            height: 5.0,
            width: double.infinity,
            color: Colors.black,
            child: Container(
              color: Colors.black,
            )));
  }
}
