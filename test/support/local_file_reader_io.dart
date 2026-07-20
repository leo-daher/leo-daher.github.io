import 'dart:io';

const canReadLocalFiles = true;

String readLocalTextFile(String path) => File(path).readAsStringSync();
