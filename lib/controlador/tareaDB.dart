
import 'package:sqflite/sqflite.dart';
import 'conexion.dart';
import '../modelo/materia.dart';
import '../modelo/tarea.dart';
import '../modelo/MateriaTarea.dart';

class DBCancion{
  static Future<int> insertar (Tarea t) async{
    Database base = await Conexion.abrirDB();
    return base.insert("TAREA", t.toJSON(),
        conflictAlgorithm: ConflictAlgorithm.fail);
  }

  static Future<int> eliminar (String idtarea) async{
    Database base = await Conexion.abrirDB();
    return base.delete("TAREA", where: "IDTAREA=?", whereArgs: [idtarea]);
  }

  static Future<List<MateriaTarea>> mostrarConArtista() async{
    Database base = await Conexion.abrirDB();
    //List <Map<String, dynamic>> resultado = await base.query("CANCION");
    List<Map<String, dynamic>> resultado = await base.rawQuery('''
      SELECT CANCION.IDCANCION, CANCION.NOMBRECANCION, CANCION.ALBUM, ARTISTA.NOMBRE AS NOMBRE_ARTISTA
      FROM CANCION
      INNER JOIN ARTISTA ON CANCION.ARTISTAID = ARTISTA.ARTISTAID
    ''');

    return List.generate(resultado.length, (index){
      return MateriaTarea(
        idmateria: resultado[index]['IDMATERIA'],
        nombre: resultado[index]['NOMBRE'],
        semestre: resultado[index]['SEMESTRE'],
        docente: resultado[index]['DOCENTE'],
        idtarea: resultado[index]['IDTAREA'],
        f_entrega: resultado[index]['F_ENTREGA'],
        descripcion: resultado[index]['DESCRIPCION'],

        //RECUPERAR TODO


      );
    });
  }

  static Future<List<Tarea>> mostrar() async{
    Database base = await Conexion.abrirDB();
    List <Map<String, dynamic>> resultado = await base.query("CANCION");

    return List.generate(resultado.length, (index){
      return Tarea(
        idtarea: resultado[index]['IDTAREA'],
        idmateria: resultado[index]['IDMATERIA'],
        f_entrega: resultado[index]['F_ENTREGA'],
        descripcion: resultado[index]['DESCRIPCION'],
        //RECUPERAR TODO


      );
    });
  }


}