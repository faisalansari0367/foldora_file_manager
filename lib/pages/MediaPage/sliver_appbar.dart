import 'package:files/provider/OperationsProvider.dart';
import 'package:files/utilities/MyColors.dart';
import 'package:files/widgets/MediaPageAppbar.dart';
import 'package:files/widgets/MyAppBar.dart';
import 'package:files/widgets/MyDropDown.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:provider/provider.dart';

import '../../sizeConfig.dart';

class MySliverAppBar extends StatefulWidget {
  @override
  _MySliverAppBarState createState() => _MySliverAppBarState();
}

class _MySliverAppBarState extends State<MySliverAppBar> {
  @override
  Widget build(BuildContext context) {
    return CustomConsumer();
  }
}

class CustomConsumer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Selector<Operations, double>(
      selector: (context, value) => value.appbarSize,
      builder: (context, value, child) {
        final bottom = AnimationConfiguration.synchronized(
          duration: Duration(milliseconds: 500),
          child: FadeInAnimation(
            delay: Duration(milliseconds: 500),
            child: SlideAnimation(
              verticalOffset: -50,
              child: MyBottomAppBar(
                backgroundColor: Colors.transparent,
              ),
            ),
          ),
        );
        return SliverAppBar(
          systemOverlayStyle: AppbarUtils.systemUiOverylay(MyColors.darkGrey),
          pinned: true,
          backgroundColor: MyColors.darkGrey,
          leading: AppbarUtils.backIcon(context),
          actions: [AppbarUtils.searchIcon(context), MyDropDown()],
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(value),
            child: value != Responsive.height(6) ? SizedBox() : bottom,
          ),
        );
      },
    );
  }
}
