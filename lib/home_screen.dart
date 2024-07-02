import 'package:flutter/material.dart';
import 'services/db_service.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final DBService _dbService = DBService();
  List<Map<String, dynamic>> _entries = [];

  @override
  void initState() {
    super.initState();
    _loadEntries();
  }

  void _loadEntries() async {
    final data = await _dbService.getEntries();
    setState(() {
      _entries = data;
    });
  }

  void _addEntry(String type) async {
    await _dbService.insertEntry(type);
    _loadEntries();
  }

  void _deleteEntry(int id) async {
    await _dbService.deleteEntry(id);
    _loadEntries();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Home')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed: ()=> _addEntry('Entrada'),
                  child: Text('Registrar Entrada')
                  ),
                ElevatedButton(
                  onPressed: () => _addEntry('Salida'),
                  child: Text('Salida'),
                  ),
              ],
            ),
          ),
          
          Expanded(
            child: ListView.builder(
              itemCount: _entries.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text('${_entries[index]['type']}: ${_entries[index]['timestamp']}'),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () => _deleteEntry(_entries[index]['id']),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
