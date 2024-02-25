import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'my_hobbies.dart';

class SharedPreferencesScene extends StatefulWidget {
  const SharedPreferencesScene({Key? key}) : super(key: key);
  static const String appTitle = 'Persistence: Shared Preferences';

  @override
  State<SharedPreferencesScene> createState() => _SharedPreferencesSceneState();
}

class _SharedPreferencesSceneState extends State<SharedPreferencesScene> {
  String _name = '';
  int _age = 0;
  double _salary = 0.0;
  List<String> _hobbies = ['Reading', 'Swimming', 'Walking', 'Travelling'];

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _salaryController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  void _updateName(String value) {
    _name = value;
  }

  void _updateAge(String age) {
    _age = int.tryParse(age) ?? 0;
  }

  void _updateSalary(String salary) {
    _salary = double.tryParse(salary) ?? 0.0;
  }

  void _updateHobbies(List<String> hobbies) {
    setState(() {
      _hobbies = hobbies;
    });
  }

  void _savePreferences() async {
    print('Saving to preferences...');
    SharedPreferencesManager.save(_nameController.text,
        age: _age, salary: _salary, hobbies: _hobbies);
  }

  void _loadPreferences() async {
    print('Loading from preferences...');
    final name = await SharedPreferencesManager.getName();
    final age = await SharedPreferencesManager.getAge();
    final salary = await SharedPreferencesManager.getSalary();
    final hobbies = await SharedPreferencesManager.getHobbies();

    setState(() {
      _name = name;
      _age = age;
      _salary = salary;
      _hobbies = hobbies;
    });

    _nameController.text = _name;
    _ageController.text = _age.toString();
    _salaryController.text = _salary.toString();
  }

  void _clearAllPreferences() {
    print('All Preferences cleared');
    SharedPreferencesManager.clearAll();

    _loadPreferences();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(SharedPreferencesScene.appTitle)),
      body: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            nameInput(),
            ageInput(),
            salaryInput(),
            showHobbies(),
            buttonHobbie(),
            buttons(),
          ],
        ),
      ),
    );
  }

  Widget nameInput() {
    return TextField(
      onChanged: _updateName,
      controller: _nameController,
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
        labelText: 'Name',
      ),
    );
  }

  Widget ageInput() {
    return TextField(
      onChanged: _updateAge,
      keyboardType: TextInputType.number,
      controller: _ageController,
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
        labelText: 'Age',
      ),
    );
  }

  Widget salaryInput() {
    return TextField(
      onChanged: _updateSalary,
      keyboardType: TextInputType.number,
      controller: _salaryController,
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
        labelText: 'Salary',
      ),
    );
  }

  Widget showHobbies() {
    return Container(
      constraints: BoxConstraints(maxWidth: 300),
      child: Text(
        'Hobbies: ${_hobbies.join(', ')}',
        style: const TextStyle(fontSize: 18.0, color: Colors.purple),
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  Widget buttons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(right: 4.0),
          child: ElevatedButton(
            onPressed: _loadPreferences,
            child: const Text('Load Prefs'),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 4.0),
          child: ElevatedButton(
            onPressed: _savePreferences,
            child: const Text('Save Prefs'),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 4.0, right: 4.0),
          child: ElevatedButton(
            onPressed: _clearAllPreferences,
            child: const Text('Clear All Prefs'),
          ),
        ),
      ],
    );
  }

  Widget buttonHobbie(){
    return Container(
      width: double.infinity, // Ocupa todo el ancho disponible
      child: ElevatedButton(
        onPressed: () async {
          List<String>? updatedHobbies = await Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => HobbiesScreen(_hobbies)),
          );

          if (updatedHobbies != null) {
            _updateHobbies(updatedHobbies);
          }
        },
        child: const Text('Edit Hobbies'),
      ),
    );
  }
}

class SharedPreferencesManager {
  static const name = 'name';
  static const age = 'age';
  static const salary = 'salary';
  static const hobbies = 'hobbies';

  static Future<void> save(String name,
      {int age = 0, double salary = 0.0, List<String> hobbies = const []}) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(SharedPreferencesManager.name, name);
    prefs.setInt(SharedPreferencesManager.age, age);
    prefs.setDouble(SharedPreferencesManager.salary, salary);
    prefs.setStringList(SharedPreferencesManager.hobbies, hobbies);
  }

  static Future<String> getName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(SharedPreferencesManager.name) ?? '';
  }

  static Future<int> getAge() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(SharedPreferencesManager.age) ?? 0;
  }

  static Future<double> getSalary() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getDouble(SharedPreferencesManager.salary) ?? 0.0;
  }

  static Future<List<String>> getHobbies() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(SharedPreferencesManager.hobbies) ??
        ['Reading', 'Swimming', 'Walking', 'Travelling'];
  }

  static Future<bool> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.clear();
  }
}
