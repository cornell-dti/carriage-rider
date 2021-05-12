import 'package:carriage_rider/pages/Terms.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class PositionedImage extends StatelessWidget {
  PositionedImage(this.imagePath, {this.top, this.bottom, this.left, this.right});
  final String imagePath;
  final double top;
  final double bottom;
  final double left;
  final double right;

  @override
  Widget build(BuildContext context) {
    return Positioned(
        top: top,
        bottom: bottom,
        left: left,
        right: right,
        child: ExcludeSemantics(
            child: SvgPicture.asset(
                imagePath
            )
        )
    );
  }
}

class OnboardingPage extends StatelessWidget {
  OnboardingPage(this.heading, this.description, this.saySwipeLeft, this.images);
  final String heading;
  final String description;
  final bool saySwipeLeft;
  final List<Widget> images;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        Column(
          children: [
            SizedBox(
              height:
              MediaQuery.of(context).size.height * 0.10,
            ),
            MergeSemantics(
              child: Column(
                children: [
                  Text(
                    heading,
                    semanticsLabel: heading + '.',
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
                      description,
                      semanticsLabel: description + (saySwipeLeft ? '. Swipe left to advance' : ''),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 17.0, color: Color(0xFFA6A6A6)),
                    ),
                  ),
                ]
              ),
            )
          ],
        ),
        SizedBox(height: 15.0),
      ]..addAll(images),
    );
  }
}

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
    String imagesPath = 'assets/images/';
    String bigCloud = imagesPath + 'smallCloud.svg';
    String smallCloud = imagesPath + 'bigCloud.svg';
    String car = imagesPath + 'onboardingCar.svg';
    String clockTower = imagesPath + 'clockTower.svg';
    String trees = imagesPath + 'trees.svg';
    
    List<Widget> pages = [
      OnboardingPage('Welcome to Carriage', 'Paratransit ride app made by Cornell DTI with CULift', true,
          [
            PositionedImage(bigCloud, bottom: 250, left: 50),
            PositionedImage(smallCloud, bottom: 350, right: 100),
            PositionedImage(clockTower, bottom: -10, right: -90),
            PositionedImage(trees, bottom: 0, left: 125),
            PositionedImage(car, bottom: 0, left: -75),
          ]
      ),
      OnboardingPage('Schedule Rides Easily', 'Request and edit rides.', true,
          [
            PositionedImage(bigCloud, bottom: 400, right: 0),
            PositionedImage(smallCloud, bottom: 350, left: 50),
            PositionedImage(trees, bottom: 0, left: 0),
            PositionedImage(car, bottom: 0, left: -5),
            PositionedImage(clockTower, bottom: -10, right: 20)
          ]
      ),
      OnboardingPage('Live Updates', 'Check when your driver is on the way.', true,
          [
            PositionedImage(bigCloud, bottom: 350, left: 75),
            PositionedImage(smallCloud, bottom: 225, right: 0),
            PositionedImage(clockTower, bottom: -10, left: 20),
            PositionedImage(trees, bottom: 0, right: -80),
            PositionedImage(car, bottom: 0, right: 100),
          ]
      ),
      OnboardingPage('With CULift', 'Transportation service provided by CULift', false,
          [
            PositionedImage(smallCloud, bottom: 225, left: 0),
            PositionedImage(trees, bottom: 0, left: 100),
            PositionedImage(car, bottom: 0, right: -50),
          ]
      )
    ];
    
    return Scaffold(
      body: Container(
        child: Padding(
          padding: EdgeInsets.only(top: 5.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                height: MediaQuery.of(context).size.height * 0.85,
                child: PageView(
                    physics: ClampingScrollPhysics(),
                    controller: _pageController,
                    onPageChanged: (int page) {
                      setState(() {
                        _slideIndex = page;
                      });
                    },
                    children: pages
                ),
              ),
              _slideIndex != _numPages - 1
                  ? Expanded(
                child: ExcludeSemantics(
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
                ),
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
    );
  }
}
