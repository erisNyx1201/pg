// ignore_for_file: file_names, camel_case_types

import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:pgsupervisor/model/files.dart';

class retrieveFile {
  static Future<List<String>> _getDownloadLinks(List<Reference> refs) =>
      Future.wait(refs.map((ref) => ref.getDownloadURL()).toList());

  static Future<List<Files>> listAll(String path) async {
    final ref = FirebaseStorage.instance.ref(path);
    final result = await ref.listAll();

    final urls = await _getDownloadLinks(result.items);

    return urls
        .asMap()
        .map((index, url) {
          final ref = result.items[index];
          final name = ref.name;
          final file = Files(ref: ref, name: name, url: url);

          return MapEntry(index, file);
        })
        .values
        .toList();
  }


}