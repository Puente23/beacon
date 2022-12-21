// ignore: duplicate_ignore
// ignore_for_file: depend_on_referenced_packages, duplicate_ignore

import 'dart:io';
// ignore: depend_on_referenced_packages
import 'package:app_puente2/src/presentation/models/actividades.dart';
import 'package:app_puente2/src/presentation/models/beacon.dart';
import 'package:app_puente2/src/presentation/models/estados.dart';
import 'package:app_puente2/src/presentation/models/ubicaciones.dart';
import 'package:app_puente2/src/presentation/models/usuario.dart';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class DBProvider {
  late final Database _database;
  static final DBProvider db = DBProvider._();
  DBProvider._();
  Future<Database> get database async {
    return _database;
  }

  Future<Database> initDB() async {
    // Path de donde almacenaremos la base de datos
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, 'ScansDB.db');
    if (kDebugMode) {
      print(path);
    }
    // Crear base de datos
    return await openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (Database db, int version) async {
      await db.execute('''
          CREATE TABLE estados(
            id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
            tipo TEXT,
          ),
          CREATE TABLE actividad(
            id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
            nombre TEXT,
            tiempoini TEXT,
            tiempofin TEXT,
            estado TEXT,
            FOREIGN KEY(estado) REFERENCES estados(id)
          ),
          CREATE TABLE ubicaciones(
            id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
            ubicacion TEXT,
            nombre TEXT,
            gps TEXT
          ),
          CREATE TABLE beacons(
            id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
            nombre TEXT,
            ubicacion TEXT,
            FOREIGN KEY(ubicacion) REFERENCES beacons(id)
          ),
          CREATE TABLE usuarios(
            id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
            nombre TEXT,
            tipo TEXT,
            apellido_M TEXT,
            apellido_P TEXT,
            actividad TEXT,
            id_dispositivo INTEGER,
            FOREIGN KEY(id_dispositivo) REFERENCES beacons(id),
            FOREIGN KEY(actividad) REFERENCES actividad(id)
          )
        ''');
    });
  }

  //INSERT EN BASE DE DATOS LOCAL

  insertestados(Estados todo) async {
    final db = await database;
    var res = await db.insert(Estados.TABLENAME, todo.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
    return res;
  }

  insertactividades(Actividades todo) async {
    final db = await database;
    var res = await db.insert(Actividades.TABLENAME, todo.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
    return res;
  }

  insertubicacion(Ubicaciones todo) async {
    final db = await database;
    var res = await db.insert(Ubicaciones.TABLENAME, todo.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
    return res;
  }

  insertbeaon(Beacon todo) async {
    final db = await database;
    var res = await db.insert(Beacon.TABLENAME, todo.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
    return res;
  }

  insertusuario(Usuario todo) async {
    final db = await database;
    var res = await db.insert(Usuario.TABLENAME, todo.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
    return res;
  }

  //update
  updateusuario(Usuario todo) async {
    final db = await database;
    var res = await db.update(Usuario.TABLENAME, todo.toMap(),
        where: "id = ?", whereArgs: [todo.id]);
    return res;
  }

  updateestados(Estados todo) async {
    final db = await database;
    var res = await db.update(Estados.TABLENAME, todo.toMap(),
        where: "id = ?", whereArgs: [todo.id]);
    return res;
  }

  updateactividades(Actividades todo) async {
    final db = await database;
    var res = await db.update(Actividades.TABLENAME, todo.toMap(),
        where: "id = ?", whereArgs: [todo.id]);
    return res;
  }

  updateubicacion(Ubicaciones todo) async {
    final db = await database;
    var res = await db.update(Ubicaciones.TABLENAME, todo.toMap(),
        where: "id = ?", whereArgs: [todo.id]);
    return res;
  }

  updatebeaon(Beacon todo) async {
    final db = await database;
    var res = await db.update(Beacon.TABLENAME, todo.toMap(),
        where: "id = ?", whereArgs: [todo.id]);
    return res;
  }

  //delete
  deltebeacon(Beacon todo) async {
    final db = await database;
    var res = await db
        .delete(Beacon.TABLENAME, where: "id = ?", whereArgs: [todo.id]);
    return res;
  }

  delteusuario(Usuario todo) async {
    final db = await database;
    var res = await db
        .delete(Usuario.TABLENAME, where: "id = ?", whereArgs: [todo.id]);
    return res;
  }

  delteestados(Estados todo) async {
    final db = await database;
    var res = await db
        .delete(Estados.TABLENAME, where: "id = ?", whereArgs: [todo.id]);
    return res;
  }

  delteactividades(Actividades todo) async {
    final db = await database;
    var res = await db
        .delete(Actividades.TABLENAME, where: "id = ?", whereArgs: [todo.id]);
    return res;
  }

  delteubicacion(Ubicaciones todo) async {
    final db = await database;
    var res = await db
        .delete(Ubicaciones.TABLENAME, where: "id = ?", whereArgs: [todo.id]);
    return res;
  }

  //consultas
  Future<List<Ubicaciones>> consultaubicacion() async {
    final db = await database;
    final List<Map<String, dynamic>> maps =
        await db.query(Ubicaciones.TABLENAME);
    return List.generate(maps.length, (i) {
      return Ubicaciones(
        id: maps[i]['id'],
        ubicacion: maps[i]['ubicacion'],
        nombre: maps[i]['nombre'],
        gps: maps[i]['gps'],
      );
    });
  }

  Future<List<Usuario>> consultausuarios() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(Usuario.TABLENAME);
    return List.generate(maps.length, (i) {
      return Usuario(
        id: maps[i]['id'],
        nombre: maps[i]['nombre'],
        tipo: maps[i]['tipo'],
        apellido_P: maps[i]['apellido_P'],
        apellido_M: maps[i]['apellido_M'],
        id_dispositivo: maps[i]['id_dispositivo'],
      );
    });
  }

  Future<List<Beacon>> consultabeacon() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(Beacon.TABLENAME);
    return List.generate(maps.length, (i) {
      return Beacon(
        id: maps[i]['id'],
        nombre: maps[i]['nombre'],
        ubicacion: maps[i]['ubicacion'],
      );
    });
  }
}
