  import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'dart:collection';
import 'dart:convert';
import 'package:flutter/material.dart';
class FileUtility{


  static save(String information) async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/score.txt');
     await file.writeAsString(information);
    print('saved');
  }
  Future<bool> checkFile() async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/score.txt');
    return await file.exists();

  }


}
