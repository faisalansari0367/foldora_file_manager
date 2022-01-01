class ImageModel {
  List<String> files;
  String folderName;
  int folderSize;

  ImageModel({this.files, this.folderName});

  ImageModel.fromJson(Map<String, dynamic> json) {
    files = json['files'].cast<String>();
    folderName = json['folderName'];
    folderSize = json['folderSize'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['files'] = files;
    data['folderName'] = folderName;
    return data;
  }
}
