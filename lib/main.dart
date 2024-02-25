import 'dart:io';
import 'package:persistencia/screens/file_persistence.dart';
import 'package:persistencia/screens/my_products.dart';
import 'package:persistencia/screens/shared_preferences_persistence.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  static const _title = 'Persistencia de datos';

  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: _title,
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: MyHomePage(),
    );
  }
}
//,
class MyHomePage extends StatelessWidget {
  static const String fileName = 'myFile.txt';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(MyApp._title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                // Navegar a la escena 1
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => FileScene(fileManager: FileManager(fileName: fileName),)),
                );
              },
              child: Text('File persitence'),
            ),
            ElevatedButton(
              onPressed: () {
                // Navegar a la escena 2
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SharedPreferencesScene()),
                );
              },
              child: Text('Shared preferences'),
            ),
            ElevatedButton(
              onPressed: () {
                // Navegar a la escena 3
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const MyProducts()),
                );
              },
              child: Text('BD persistence'),
            ),
          ],
        ),
      ),
    );
  }
}


class FileManager {
  String fileName;

  FileManager({required this.fileName});

  Future<File> get _localFile async {
    final directory = await getApplicationDocumentsDirectory(); // get app docs path
    return File('${directory.path}/$fileName');  // reference to fileName
  }

  Future<String> read()  async {
    final file = await _localFile;
    final sentence = await file.readAsString();  // reads all the file content

    return sentence;
  }

  Future<void> write(String sentence) async {
    final file = await _localFile;
    await file.writeAsString(sentence);  // write sentence to file, truncates the file if it already exists
  }
}



