import 'package:flutter/material.dart';

class RideHistory extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return Column(
      children: <Widget>[
        RideHistoryCard(timeDateWidget: TimeDateHeader(timeDate: 'OCT 18th 12:00 PM'),
            infoRowWidget: InformationRow(start: 'Upson Hall', end: 'Uris Hall'),),
        RideHistoryCard(timeDateWidget: TimeDateHeader(timeDate: 'FEB 29th 12:00 PM'),
          infoRowWidget: InformationRow(start: 'Balch Hall', end: 'Gates Hall'),)
      ],
    );
  }
}

class TimeDateHeader extends StatelessWidget{

  const TimeDateHeader({Key key, this.timeDate}) : super(key: key);

  final String timeDate;


  @override
  Widget build(BuildContext context) {

    final timeDateStyle = TextStyle(
      color: Colors.black,
      fontWeight: FontWeight.bold,
      fontFamily: 'SFPro',
      fontSize: 22,
    );

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(left: 25),
          child: Text(timeDate, style: timeDateStyle),
        )
      ],
    );
  }

}

class InformationRow extends StatelessWidget {

  const InformationRow({Key key, this.start, this.end}) : super(key: key);

  final start;
  final end;

  @override
  Widget build(BuildContext context) {
    final fromToStyle = TextStyle(
        color: Colors.grey[500],
        fontWeight: FontWeight.w500,
        fontSize: 12,
    );

    final infoStyle = TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.w400,
        fontSize: 18,
    );
    return Container(
      margin: EdgeInsets.only(left: 25, right: 25),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Text('From', style: fromToStyle)
                  ],
                ),
                SizedBox(height: 2),
                Row(
                  children: <Widget>[
                    Text(start, style: infoStyle)
                  ],
                )
              ],
            ),
          ),
          Container(
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Icon(Icons.arrow_forward)
                  ],
                )
              ],
            ),
          ),
          Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Text('To', style: fromToStyle)
                  ],
                ),
                SizedBox(height: 5),
                Row(
                  children: <Widget>[
                    Text(end, style: infoStyle)
                  ],
                )
              ],
            ),
          )
        ],

      ),
    );
  }
}

class RideHistoryCard extends StatelessWidget {

  const RideHistoryCard({Key key, this.timeDateWidget, this.infoRowWidget}) : super(key: key);

  final Widget timeDateWidget;
  final Widget infoRowWidget;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 17.0, right: 17.0, bottom: 15.0),
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * .18,
      child: Card(
        elevation: 3.0,
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              timeDateWidget,
              infoRowWidget
            ],
          ),
        ),
      ),
    );
  }
}


