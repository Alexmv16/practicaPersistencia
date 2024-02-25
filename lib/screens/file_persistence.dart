
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

import '../main.dart';

class FileScene extends StatefulWidget {
  final FileManager fileManager;
  static const String appTitle = 'Persistence: Using Files';


  const FileScene({Key? key, required this.fileManager}) : super(key: key);

  @override
  State<FileScene> createState() => _FileSceneState();
}

class _FileSceneState extends State<FileScene> {
  String _sentence = "";

  void _updateField(String value) {
    _sentence = value;
  }

  void _saveToFile() async {
    print('Saving sentence: $_sentence');

    await widget.fileManager.write(_sentence);

    print('saved!!!');
  }

  void _loadFromFile()  async {
    print('Loading from file...');

    try {
      final String fileContent = await widget.fileManager.read();
      setState(() => _sentence = fileContent);
    } catch(e) {
      print('File does not exist');
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text( FileScene.appTitle)),
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text("Sentence:"),
            TextField(
              maxLines: 2,
              onChanged: _updateField,
              controller: TextEditingController(text: _sentence),
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(child: const Text('LOAD'), onPressed: _loadFromFile,),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(child: const Text('SAVE'), onPressed: _saveToFile,),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

