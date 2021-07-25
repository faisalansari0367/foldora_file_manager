import 'package:files/provider/MyProvider.dart';
import 'package:files/utilities/MyColors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyDropDown extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final storage = Provider.of<MyProvider>(context, listen: false);
    return Container(
      height: 45,
      width: 45,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
      ),
      child: IconButton(
        splashRadius: 25,
        icon: Icon(Icons.more_vert),
        color: Colors.grey[500],
        onPressed: () => showModalBottomSheet(
          context: context,
          builder: (BuildContext context) {
            return Container(
              color: Color(0xFF737373),
              child: Container(
                decoration: BoxDecoration(
                  // color: Theme.of(context).canvasColor,
                  color: MyColors.darkGrey,
                  borderRadius: BorderRadius.only(
                    topLeft: const Radius.circular(10),
                    topRight: const Radius.circular(10),
                  ),
                ),
                // height: 150,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    ListTile(
                      onTap: () => storage.toggleHidden(),
                      leading: Selector<MyProvider, bool>(
                        selector: (context, provider) => provider.showHidden,
                        builder: (_, value, __) {
                          return Checkbox(
                            value: value,
                            checkColor: MyColors.dropdownText,
                            fillColor: MaterialStateProperty.all(Colors.transparent),
                            onChanged: (bool value) => storage.toggleHidden(),
                          );
                        },
                      ),
                      title: Text(
                        'Show Hidden',
                        style: TextStyle(color: Colors.grey[300]),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
