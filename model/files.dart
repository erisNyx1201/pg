import 'package:firebase_storage/firebase_storage.dart';

class Files{
  final Reference ref;
  final String name;
  final String url;

  const Files({
    required this.ref,
    required this.name,
    required this.url,
  });
}