import 'dart:io';
import 'package:path/path.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class ScreenHome extends StatefulWidget {
  const ScreenHome({super.key});

  @override
  State<ScreenHome> createState() => ScreenHomeState();
}

class ScreenHomeState extends State<ScreenHome> {
  late Database mydb;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 2.0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(50),
        child: Center(child: _buildBody()),
      ),
    );
  }

  Widget _buildBody() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          'Usando sqflite',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 30),
        Expanded(child: ElevatedButton(onPressed: fntOpenDB, child: const Text('Crear base de datos'))),
        const SizedBox(height: 30),
        Expanded(child: ElevatedButton(onPressed: fntInsert, child: const Text('insertar datos para tabla'))),
        const SizedBox(height: 30),
        Expanded(child: ElevatedButton(onPressed: fntGetTable, child: const Text('Traer datos para tabla'))),
      ],
    );
  }

  fntOpenDB() async {
    mydb = await openDB();
  }

  Future<Database> openDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String dbPath = join(documentsDirectory.path, 'example.db');

    Database database = await openDatabase(dbPath, version: 1, onCreate: (Database db, int version) async {
      await db.execute('''
      CREATE TABLE example_table (
        id INTEGER PRIMARY KEY,
        name TEXT,
        age INTEGER
      )
    ''');
    });
    return database;
  }

  fntInsert() async {
    await mydb.insert('example_table', {'name': 'John', 'age': 30});
  }

  Future<List<Map<String, dynamic>>> selectFromTable(Database dbPath) async {
    List<Map<String, dynamic>> result = await dbPath.query('example_table');
    return result;
  }

  fntGetTable() async {
    var result = await selectFromTable(mydb);
    for (var arrow in result) {
      print(arrow);
    }
  }
}
