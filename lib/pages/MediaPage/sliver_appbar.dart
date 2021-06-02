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
    // return SliverAppBar(
    //   systemOverlayStyle: AppbarUtils.systemUiOverylay(MyColors.darkGrey),
    //   pinned: true,
    //   backgroundColor: MyColors.darkGrey,
    //   leading: AppbarUtils.backIcon(context),
    //   actions: [AppbarUtils.searchIcon(context), MyDropDown()],
    //   bottom: PreferredSize(
    //     preferredSize: Size.fromHeight(6 * Responsive.heightMultiplier),
    //     child: MyBottomAppBar(backgroundColor: Colors.transparent),
    //   ),
    // );
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
            child: value != Responsive.height(6)
                ? TestAnim(
                    height: Responsive.height(6),
                  )
                : TestAnim(
                    child: bottom,
                    start: 0.0,
                    end: value,
                  ),
          ),
        );
      },
    );
  }
}

class TestAnim extends StatefulWidget {
  final double height, start, end;
  final Widget child;
  const TestAnim({Key key, this.height, this.child, this.start, this.end})
      : super(key: key);

  @override
  _TestAnimState createState() => _TestAnimState();
}

class _TestAnimState extends State<TestAnim>
    with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation<double> animation;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 2000),
    );
    animation = Tween<double>(
      begin: Responsive.height(widget.start),
      end: Responsive.height(widget.end),
    ).animate(controller);
    controller.forward(); // automatically animation will be started
  }

  @override
  void dispose() {
    controller.dispose();
    animation = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizeTransition(
      axis: Axis.vertical,
      sizeFactor: animation,
      child: widget.child,
    );
  }
}
