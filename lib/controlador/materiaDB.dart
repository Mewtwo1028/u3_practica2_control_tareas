import 'package:sqflite/sqflite.dart';
import 'conexion.dart';
import '../modelo/materia.dart';
import '../modelo/tarea.dart';
import 'tareaDB.dart';
import 'package:u3_practica2_control_tareas/controlador/materiaDB.dart';

class DBMateria{
  static Future<int> insertar(Materia m) async {
    Database base = await Conexion.abrirDB();
    return base.insert("MATERIA", m.toJSON(),
        conflictAlgorithm: ConflictAlgorithm.fail);
  }

  static Future<int> eliminar (String idmateria) async {
    Database base = await Conexion.abrirDB();
    return base.delete("MATERIA",
        where: "IDMATERIA=?", whereArgs: [idmateria]);
  }

  static Future<List<Materia>> mostrar() async{
    Database base = await Conexion.abrirDB();
    List<Map<String,dynamic>> resultado = await base.query("MATERIA");

    return List.generate(resultado.length, (index) {
      return Materia(
        idmateria: resultado[index]["IDMATERIA"],
        nombre: resultado[index]['NOMBRE'],
        semestre: resultado[index]['SEMESTRE'],
        docente: resultado[index]['DOCENTE'],
      );
    });
  }
}