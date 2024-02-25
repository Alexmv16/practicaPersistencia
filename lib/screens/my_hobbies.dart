
import 'package:flutter/material.dart';

class HobbiesScreen extends StatefulWidget {
  final List<String> currentHobbies;

  HobbiesScreen(this.currentHobbies);

  @override
  _HobbiesScreenState createState() => _HobbiesScreenState();
}

class _HobbiesScreenState extends State<HobbiesScreen> {
  late List<String> _selectedHobbies;

  @override
  void initState() {
    super.initState();
    _selectedHobbies = List.from(widget.currentHobbies);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Hobbies'),
        actions: [
          IconButton(
            icon: const Icon(Icons.done),
            onPressed: () {
              Navigator.of(context).pop(_selectedHobbies);
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: _selectedHobbies.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(_selectedHobbies[index]),
            trailing: IconButton(
              icon: const Icon(Icons.remove_circle),
              onPressed: () {
                setState(() {
                  _selectedHobbies.removeAt(index);
                });
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          String? newHobby = await _addHobbyDialog(context);
          if (newHobby != null && newHobby.isNotEmpty) {
            setState(() {
              _selectedHobbies.add(newHobby);
            });
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<String?> _addHobbyDialog(BuildContext context) async {
    TextEditingController hobbyController = TextEditingController();

    return showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add Hobby'),
          content: TextField(
            controller: hobbyController,
            decoration: const InputDecoration(labelText: 'Hobby'),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(hobbyController.text.trim());
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }
}
