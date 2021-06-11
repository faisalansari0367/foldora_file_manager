import 'package:files/provider/MyProvider.dart';
import 'package:files/sizeConfig.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FileNotFoundScreen extends StatelessWidget {
  final String message;
  // final Exception exception;

  FileNotFoundScreen({
    this.message,
  });

  // @override
  Widget build(BuildContext context) {
    final buttonColor = MaterialStateProperty.all(Color(0xFF70DAAD));
    final provider = Provider.of<MyProvider>(context, listen: false);
    final bottom = 22 * Responsive.heightMultiplier;
    final leftRight = 10 * Responsive.widthMultiplier;
    return Center(
      child: Container(
        color: Colors.white,
        height: 100 * Responsive.heightMultiplier,
        child: Stack(
          children: [
            Image.asset(
              "assets/5_Something Wrong.png",
              fit: BoxFit.cover,
            ),
            message != null
                ? AnimatedPositioned(
                    duration: Duration(milliseconds: 500),
                    bottom: bottom,
                    left: leftRight,
                    right: leftRight,
                    child: Container(
                      padding: EdgeInsets.all(8 * Responsive.widthMultiplier),
                      color: Colors.white,
                      child: Text(
                        message,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          backgroundColor: Colors.white,
                        ),
                      ),
                    ),
                  )
                : Container(),
            Positioned(
              bottom: Responsive.height(12),
              left: MediaQuery.of(context).size.width * .37,
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: buttonColor,
                  shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                  ),
                ),

                // color: Color(0xFF70DAAD),
                // color: Color(0xFF7070DA),
                // shape: RoundedRectangleBorder(
                //   borderRadius: BorderRadius.circular(50),
                // ),
                onPressed: () => provider.onGoBack(context),
                child: Text(
                  "Go Back".toUpperCase(),
                  style: TextStyle(color: Colors.white),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
