import 'dart:io';

import 'package:files/provider/MyProvider.dart';
import 'package:files/utilities/SearchUtils.dart';
import 'package:files/widgets/14_no_result_found.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'ListBuilder.dart';

class Search extends SearchDelegate {
  static double _splashRadius = 25.0;

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        splashRadius: _splashRadius,
        icon: Icon(Icons.clear),
        onPressed: () => query.isNotEmpty ? query = '' : close(context, null),
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      splashRadius: _splashRadius,
      icon: Icon(Icons.arrow_back),
      onPressed: () => Navigator.pop(context),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final provider = Provider.of<MyProvider>(context, listen: false);
    SearchUtils.addSuggestions(provider.prefs, query);
    return StreamBuilder(
      stream: SearchUtils.searchDelegate(
        path: provider.getDirPath,
        query: query,
      ),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        final List<FileSystemEntity> data = snapshot.data;
        if (snapshot.hasData) {
          return snapshot.data.isNotEmpty
              ? DirectoryListItem(data: data)
              : NoResultFoundScreen();
        } else if (snapshot.hasError) {
          return Center(child: Text(snapshot.error));
        } else {
          return LinearProgressIndicator();
        }
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final provider = Provider.of<MyProvider>(context, listen: false);
    var suggestions = provider.prefs.getStringList('suggestions') ?? [];
    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (context, int index) {
        return ListTile(
          onTap: () async {
            await showSearch(
                context: context,
                delegate: Search(),
                query: query = suggestions[index]);
          },
          leading: Icon(Icons.history),
          title: Text(suggestions[index]),
        );
      },
    );
  }
}
