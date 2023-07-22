import 'package:files/provider/MyProvider.dart';
import 'package:files/sizeConfig.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FileNotFoundScreen extends StatelessWidget {
  final String? message;
  // final Exception exception;

  const FileNotFoundScreen({
    this.message,
  });

  // @override
  @override
  Widget build(BuildContext context) {
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
              'assets/5_Something Wrong.png',
              fit: BoxFit.cover,
            ),
            if (message != null)
              AnimatedPositioned(
                duration: Duration(milliseconds: 500),
                bottom: bottom,
                left: leftRight,
                right: leftRight,
                child: Container(
                  padding: EdgeInsets.all(8 * Responsive.widthMultiplier),
                  color: Colors.white,
                  child: Text(
                    message!,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.subtitle2!.copyWith(
                          fontSize: 13,
                          height: 1.5,
                        ),
                    // style: TextStyle(
                    //   fontWeight: FontWeight.bold,
                    //   backgroundColor: Colors.white,
                    // ),
                  ),
                ),
              ),
            Positioned(
              bottom: Responsive.height(12),
              left: MediaQuery.of(context).size.width * .37,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: StadiumBorder(),
                ),
                onPressed: () => provider.onGoBack(context),
                child: Text(
                  'Go Back'.toUpperCase(),
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
