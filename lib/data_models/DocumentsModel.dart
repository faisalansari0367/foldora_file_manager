import 'dart:io';

class Document {
  final String mimeType;
  final int size;
  final String title;
  final File file;
  Document({this.mimeType, this.size, this.title, this.file});
}

class DocumentsModel {
  final String folderName;
  final List<Document> document;

  DocumentsModel({this.folderName, this.document});

  static List<DocumentsModel> jsonToDocument(List json) {
    return List.generate(json.length, (index) {
      final data = json[index];
      return DocumentsModel(
        document: _listOfDocument(data['files']),
        folderName: data['folderName'],
      );
    });
  }

  static List<Document> _listOfDocument(List files) {
    return List.generate(files.length, (index) {
      final document = files[index];
      return Document(
        file: File(document['path']),
        mimeType: document['mimeType'],
        size: int.parse(document['size']),
        title: document['title'],
      );
    });
  }
}
