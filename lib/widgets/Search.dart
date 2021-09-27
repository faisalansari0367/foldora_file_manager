import 'dart:io';

import 'package:files/provider/MyProvider.dart';
import 'package:files/services/storage_service.dart';
import 'package:files/utilities/SearchUtils.dart';
import 'package:files/widgets/14_no_result_found.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'ListBuilder.dart';

class Search extends SearchDelegate {
  static final double _splashRadius = 25.0;
  // final storage = StorageService();

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
    SearchUtils.addSuggestions(StorageService.prefs, query);
    return StreamBuilder(
      stream: SearchUtils.searchDelegate(
        path: provider.data[provider.currentPage].path,
        query: query,
      ),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        final List<FileSystemEntity> data = snapshot.data;
        if (snapshot.hasData) {
          return snapshot.data.isNotEmpty ? DirectoryListItem(data: data) : NoResultFoundScreen();
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
    final suggestions = StorageService.prefs.getStringList('suggestions') ?? [];
    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (context, int index) {
        return ListTile(
          onTap: () async {
            await showSearch(
                context: context, delegate: Search(), query: query = suggestions[index]);
          },
          leading: Icon(Icons.history),
          title: Text(suggestions[index]),
        );
      },
    );
  }
}
