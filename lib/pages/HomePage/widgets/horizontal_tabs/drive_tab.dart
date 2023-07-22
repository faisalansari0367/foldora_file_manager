import 'package:files/decoration/my_decoration.dart';
import 'package:files/helpers/provider_helpers.dart';
import 'package:files/pages/Drive/drive_screen.dart';
import 'package:files/provider/drive_provider/drive_provider.dart';
import 'package:files/provider/local_auth_provider.dart';
import 'package:files/sizeConfig.dart';
import 'package:files/utilities/MediaListItemUtils.dart';
import 'package:files/utilities/MyColors.dart';
import 'package:files/utilities/Utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../MediaStack.dart';

class DriveTab extends StatefulWidget {
  @override
  State<DriveTab> createState() => _DriveTabState();
}

class _DriveTabState extends State<DriveTab> {
  static int items = 0;
  static String usedBytes = '0';
  @override
  void initState() {
    if (items != 0) return;
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      final provider = Provider.of<DriveProvider>(context, listen: false);
      await provider.init();
      await provider.isReady;
      final list = (await provider.getDriveFiles())!;
      usedBytes = provider.driveQuota?.usageInDrive ?? '0';
      items = list.length;
      if (!mounted) return;
      setState(() {});
    });
    super.initState();
  }

  bool isFirst = true;
  static final color = Color(0xff00ae45);

  void onStateChange() {
    if (isFirst) {}
    setState(() => isFirst = !isFirst);
  }

  void onTapFirstChild() async {
    final lockAuth = getProvider<LocalAuth>(context);
    if (lockAuth.isAuthenticated) {
      MediaUtils.redirectToPage(
        context,
        page: DriveScreen(),
      );
    } else {
      onStateChange();
      await Future.delayed(MyDecoration.duration);
      authenticate();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedCrossFade(
      duration: MyDecoration.duration,
      crossFadeState: !isFirst ? CrossFadeState.showSecond : CrossFadeState.showFirst,
      secondChild: secondChild(),
      firstChild: MediaStack(
        onTap: onTapFirstChild,
        image: 'assets/drive.png',
        color: color.withOpacity(0.2),
        media: 'Drive',
        items: '$items Items',
        privacy: 'Private Folder',
        shadow: Colors.green.shade200,
        lock: Icon(
          Icons.lock_outline,
          color: color,
        ),
        size: FileUtils.formatBytes(int.parse(usedBytes), 2),
        // size: '0.0 GB',
      ),
    );
  }

  void authenticate() async {
    final lockAuth = getProvider<LocalAuth>(context);
    if (lockAuth.isAuthenticated) return;
    final result = await lockAuth.authenticate();
    if (result) {
      MediaUtils.redirectToPage(
        context,
        page: DriveScreen(),
      );
      onStateChange();
    }
  }

  Widget secondChild() {
    return InkWell(
      onTap: authenticate,
      child: AnimatedContainer(
        duration: MyDecoration.duration,
        // decoration: BoxDecoration(
        // color: MyColors.teal,
        // borderRadius: MyDecoration.decoration()

        // ),
        decoration: MyDecoration.decoration(color: MyColors.darkGrey.withOpacity(0.8)),
        height: 40.height,
        width: 55.width,
        padding: EdgeInsets.all(5.padding),
        child: Center(
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.spaceAround,
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.fingerprint,
                size: 20.image,
                color: MyColors.white,
              ),
              SizedBox(
                height: 5.height,
              ),
              Text(
                'Use fingerprint or Enter pin',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.subtitle2!.copyWith(color: Colors.white),
                // style: TextStyle(
                //   color: MyColors.white,
                //   fontSize: 20,
                // ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DriveAuthenticator extends StatefulWidget {
  final Widget? child;
  const DriveAuthenticator({Key? key, this.child}) : super(key: key);

  @override
  _DriveAuthenticatorState createState() => _DriveAuthenticatorState();
}

class _DriveAuthenticatorState extends State<DriveAuthenticator> {
  var state = CrossFadeState.showFirst;

  void onStateChange() {
    setState(() {
      final isFirst = CrossFadeState.showFirst == state;
      state = isFirst ? CrossFadeState.showSecond : CrossFadeState.showFirst;
    });
  }

  Widget secondChild() {
    return AnimatedContainer(
      duration: MyDecoration.duration,
      child: Column(
        children: [
          Icon(Icons.fingerprint),
          Text('User fingerprint or Enter pin'),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onStateChange,
      child: AnimatedCrossFade(
        duration: MyDecoration.duration,
        crossFadeState: state,
        firstChild: widget.child!,
        secondChild: secondChild(),
      ),
    );
  }
}
