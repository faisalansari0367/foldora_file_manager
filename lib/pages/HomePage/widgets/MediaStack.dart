import 'package:flutter/material.dart';

import '../../../sizeConfig.dart';

class MediaStack extends StatelessWidget {
  final String image;
  final Color color;
  final String media;
  final String items;
  final String privacy;
  final Color shadow;
  final Icon lock;
  final String size;

  const MediaStack({
    this.image,
    this.color,
    this.media,
    this.items,
    this.privacy,
    this.shadow,
    this.lock,
    this.size,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Opacity(
          opacity: 0.9,
          child: Container(
            height: 40 * Responsive.heightMultiplier,
            width: 55 * Responsive.widthMultiplier,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(32.0),
            ),
          ),
        ),
        Positioned(
          top: 5 * Responsive.heightMultiplier,
          left: 6 * Responsive.widthMultiplier,
          child: Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: shadow,
                  offset: Offset(2.0, 5.0),
                  blurRadius: 10.0,
                ),
              ],
            ),
            child: Opacity(
              opacity: 0.6,
              child: Image.asset(
                image,
                height: 12 * Responsive.imageSizeMultiplier,
              ),
              // child: Icon(
              //   Icons.photo,
              //   color: Colors.teal[300],
              //   size: 12 * Responsive.imageSizeMultiplier,
              // ),
            ),
          ),
        ),
        Positioned(
          top: 22 * Responsive.heightMultiplier,
          left: 6 * Responsive.widthMultiplier,
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                media,
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  color: Colors.grey[800],
                  fontSize: 3.4 * Responsive.textMultiplier,
                ),
              ),
              SizedBox(
                height: 1 * Responsive.heightMultiplier,
              ),
              Text(
                items,
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  color: Colors.grey[700],
                  fontSize: 2.2 * Responsive.textMultiplier,
                ),
              ),
              SizedBox(
                height: 2 * Responsive.heightMultiplier,
              ),
            ],
          ),
        ),
        Positioned(
          top: 32 * Responsive.heightMultiplier,
          left: 2 * Responsive.widthMultiplier,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(left: 4 * Responsive.widthMultiplier),
                child: lock,
              ),
              Padding(
                padding: EdgeInsets.only(left: 15 * Responsive.widthMultiplier),
                child: Text(
                  size,
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    color: Colors.grey[700],
                    fontSize: 2.2 * Responsive.textMultiplier,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
