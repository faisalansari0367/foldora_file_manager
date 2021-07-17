// import 'dart:io';

// abstract class Operation {
//   Future<void> delete(List<FileSystemEntity> list);

//   Future<void> rename(FileSystemEntity file);

//   Future<void> copy(FileSystemEntity file);

//   Future<void> paste(FileSystemEntity file);

//   Future<void> move(FileSystemEntity file);

//   Future<void> addToList(List<FileSystemEntity> list, FileSystemEntity file);

//   Future<void> removeFromList(List<FileSystemEntity> list, FileSystemEntity file);
//   void selectItem(List<FileSystemEntity> list, FileSystemEntity file);
// }

// class Operations extends Operation {
//   @override
//   Future<void> addToList(List<FileSystemEntity> list, FileSystemEntity file) {
//     throw UnimplementedError();
//   }

//   @override
//   Future<void> copy(FileSystemEntity file) {
//     // TODO: implement copy
//     throw UnimplementedError();
//   }

//   @override
//   Future<void> delete(List<FileSystemEntity> list) async {
//     if (list.isEmpty) return;
//     try {
//       for (var item in list) {
//         await item.delete(recursive: true);
//       }
//       list.clear();
//     } on FileSystemException catch (e) {
//       print(e.toString());
//     }
//   }

//   @override
//   Future<void> move(FileSystemEntity file) {
//     // TODO: implement move
//     throw UnimplementedError();
//   }

//   @override
//   Future<void> paste(FileSystemEntity file) {
//     // TODO: implement paste
//     throw UnimplementedError();
//   }

//   @override
//   Future<void> removeFromList(List<FileSystemEntity> list, FileSystemEntity file) {
//     // TODO: implement removeFromList
//     throw UnimplementedError();
//   }

//   @override
//   Future<void> rename(FileSystemEntity file) {
//     // TODO: implement rename
//     throw UnimplementedError();
//   }

//   @override
//   void selectItem(List<FileSystemEntity> list, FileSystemEntity file) {
//     list.contains(file) ? list.remove(file) : list.add(file);
//   }
// }
