import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class Conexion{
  static Future<Database> abrirDB() async{
    return openDatabase(join(await getDatabasesPath(), "app.db"),
        onCreate: (db, version){
          return script(db);
        },
        version: 1

    );
  }

  static Future<void> script(Database db) async{
    db.execute("CREATE TABLE MATERIA (IDMATERIA TEXT PRIMARY KEY, NOMBRE TEXT, SEMESTRE TEXT, DOCENTE TEXT)");
    db.execute("CREATE TABLE TAREA (IDTAREA INTEGER PRIMARY KEY AUTOINCREMENT, IDMATERIA TEXT,  F_ENTREGA TEXT, DESCRIPCION TEXT, FOREIGN KEY (IDMATERIA) REFERENCES MATERIA(IDMATERIA))");
  }

}