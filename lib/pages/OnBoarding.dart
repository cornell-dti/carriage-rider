import 'package:carriage_rider/pages/Terms.dart';
import 'package:flutter/material.dart';
import 'package:transformer_page_view/transformer_page_view.dart';

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

  //final GlobalKey<ScaffoldState> _key = new GlobalKey<ScaffoldState>();
  final List<String> images = [
    "assets/images/person.png",
    "assets/images/person.png",
    "assets/images/person.png",
    "assets/images/person.png"
  ];

  final List<Stack> stacks = [
    Stack(
      children: [
        Positioned(child: Image.asset('assets/images/onboard_1/c1.png'))
      ],
    ),
    Stack(
      children: [
        Positioned(child: Image.asset('assets/images/onboard_1/c1.png'))
      ],
    ),
    Stack(
      children: [
        Positioned(child: Image.asset('assets/images/onboard_1/c1.png'))
      ],
    ),
    Stack(
      children: [
        Positioned(child: Image.asset('assets/images/onboard_1/c1.png'))
      ],
    ),
  ];

  List<Color> colors = [Colors.orange];
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

  final IndexController controller = IndexController();

  @override
  Widget build(BuildContext context) {
    TransformerPageView transformerPageView = TransformerPageView(
        pageSnapping: true,
        onPageChanged: (index) {
          setState(() {
            this._slideIndex = index;
          });
        },
        loop: false,
        controller: controller,
        transformer: new PageTransformerBuilder(
            builder: (Widget child, TransformInfo info) {
          return new Material(
            color: Colors.white,
            elevation: 8.0,
            borderRadius: new BorderRadius.circular(12.0),
            child: new Container(
              alignment: Alignment.center,
              color: Colors.white,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.1,
                  ),
                  ParallaxContainer(
                    child: Text(
                      text[info.index],
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold),
                    ),
                    position: info.position,
                    opacityFactor: .8,
                    translationFactor: 400.0,
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  ParallaxContainer(
                    child: Padding(
                      padding: EdgeInsets.only(left: 20.0, right: 20.0),
                      child: Text(
                        subText[info.index],
                        textAlign: TextAlign.center,
                        style:
                            TextStyle(fontSize: 17.0, color: Color(0xFFA6A6A6)),
                      ),
                    ),
                    position: info.position,
                    translationFactor: 300.0,
                  ),
                  SizedBox(
                    height: 75.0,
                  ),
                  ParallaxContainer(
                    child: _slideIndex == 0
                        ? Stack(
                            children: [
                              Container(
                                  child: Image.asset(
                                      'assets/images/onboard_1/c1.png'))
                            ],
                          )
                        : _slideIndex == 1
                            ? Stack(children: [
                                Align(
                                    alignment: Alignment.topRight,
                                    child: Image.asset(
                                        'assets/images/onboard_1/c1.png')),
                              ])
                            : _slideIndex == 2
                                ? Stack(children: [
                                    Container(
                                        child: Image.asset(
                                            'assets/images/onboard_1/c1.png'))
                                  ])
                                : Stack(children: [
                                    Container(
                                        child: Image.asset(
                                            'assets/images/onboard_1/c1.png'))
                                  ]),
                    position: info.position,
                    translationFactor: 300.0,
                  ),
                  _slideIndex <= 2
                      ? Expanded(
                          child: Align(
                              alignment: Alignment.bottomCenter,
                              child: Container(
                                  height:
                                      MediaQuery.of(context).size.height * 0.15,
                                  color: Colors.black,
                                  child: ParallaxContainer(
                                    position: info.position,
                                    translationFactor: 500.0,
                                    child: Dots(
                                      controller: controller,
                                      slideIndex: _slideIndex,
                                      numberOfDots: text.length,
                                    ),
                                  ))))
                      : Expanded(
                          child: Align(
                              alignment: Alignment.bottomCenter,
                              child: Container(
                                  height:
                                      MediaQuery.of(context).size.height * 0.15,
                                  color: Colors.black,
                                  child: ParallaxContainer(
                                      position: info.position,
                                      translationFactor: 500.0,
                                      child: Stack(
                                        children: [
                                          Positioned(
                                            child: Dots(
                                              controller: controller,
                                              slideIndex: _slideIndex,
                                              numberOfDots: text.length,
                                            ),
                                          ),
                                          Align(
                                            alignment: Alignment.center,
                                            child: ButtonTheme(
                                                minWidth: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.8,
                                                height: 50.0,
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10)),
                                                child: RaisedButton(
                                                    onPressed: () {
                                                      _onIntroEnd(context);
                                                    },
                                                    elevation: 2.0,
                                                    color: Colors.white,
                                                    textColor: Colors.black,
                                                    child: Text('Begin Now',
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 17)))),
                                          ),
                                        ],
                                      )))),
                        )
                ],
              ),
            ),
          );
        }),
        itemCount: 4);

    return Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: transformerPageView,
        ));
  }
}

class Dots extends StatelessWidget {
  final IndexController controller;
  final int slideIndex;
  final int numberOfDots;

  Dots({this.controller, this.slideIndex, this.numberOfDots});

  Widget _activeSlide(int index) {
    return GestureDetector(
      onTap: () {
        print('Tapped');
        // controller.move(index);
      },
      child: new Container(
        child: Padding(
          padding: EdgeInsets.only(left: 8.0, right: 8.0),
          child: Container(
            width: 12.0,
            height: 12.0,
            decoration: BoxDecoration(
              color: Colors.grey,
              borderRadius: BorderRadius.circular(50.0),
            ),
          ),
        ),
      ),
    );
  }

  Widget _inactiveSlide(int index) {
    return GestureDetector(
      onTap: () {
        controller.move(index);
      },
      child: new Container(
        child: Padding(
          padding: EdgeInsets.only(left: 5.0, right: 5.0),
          child: Container(
            width: 12.0,
            height: 12.0,
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(50.0)),
          ),
        ),
      ),
    );
  }

  List<Widget> _generateDots() {
    List<Widget> dots = [];
    for (int i = 0; i < numberOfDots; i++) {
      dots.add(i == slideIndex ? _activeSlide(i) : _inactiveSlide(i));
    }
    return dots;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: _generateDots(),
    ));
  }
}
