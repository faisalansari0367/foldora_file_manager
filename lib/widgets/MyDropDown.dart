import 'package:files/provider/MyProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyDropDown extends StatelessWidget {
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
                  color: Theme.of(context).canvasColor,
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
                            onChanged: (bool value) => storage.toggleHidden(),
                          );
                        },
                      ),
                      title: Text('Show Hidden'),
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
