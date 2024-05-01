import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:u3_practica2_control_tareas/controlador/materiaDB.dart';
import 'package:u3_practica2_control_tareas/modelo/materia.dart';
import 'controlador/conexion.dart';
import 'modelo/MateriaTarea.dart';
void main() {
  runApp(MaterialApp(
    home: MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int _indice = 0;
  List<Materia> listaMateria = [];
  List<MateriaTarea> listaMateriaTarea = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Control de tarea"),
      ),
      body: dinamico(_indice),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.update), label: "Actualizar"),
          BottomNavigationBarItem(icon: Icon(Icons.today), label: "Hoy"),
          BottomNavigationBarItem(icon: Icon(Icons.add), label: "Agregar")
        ],
        currentIndex: _indice,
        onTap: (index) {
          setState(() {
            _indice = index;
          });
        },
        selectedItemColor: Colors.red,
        unselectedItemColor: Colors.blue,
      ),
    );
  }

  Widget dinamico(int indice) {
    return indice == 0 ? actualizar() : indice == 1 ? agenda() : agregar();
  }

  Widget actualizar() {
    return ListView(
      children: [
        SizedBox(height: 10,),

      ],
    );
  }

  Widget agregar() {
    return ListView(
      children: [
        SizedBox(height: 10,),
        Text("Agregar Tareas"),
        SizedBox(height: 20,),
        TextButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AgregarTareaForm()),
            );
          },
          child: Text("Agregar Tarea"),
        ),

        SizedBox(height: 20,),
        TextButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AgregarMateriaForm()),
            );
          },
          child: Text("Agregar Materia"),
        ),
      ],
    );
  }

  Widget agenda() {
    return ListView(
      children: [
        SizedBox(height: 10,),
        Text("Tareas para hoy"),
      ],
    );
  }
}

class AgregarTareaForm extends StatelessWidget {
  final TextEditingController tareaNombre = TextEditingController();
  final TextEditingController tareaFecha = TextEditingController();
  final TextEditingController tareaDescripcion = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Agregar Tarea'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: tareaNombre,
              decoration: InputDecoration(
                labelText: "Nombre de la tarea",
                icon: Icon(Icons.assignment),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: tareaFecha,
              decoration: InputDecoration(
                labelText: "Fecha",
                icon: Icon(Icons.calendar_today),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: tareaDescripcion,
              decoration: InputDecoration(
                labelText: "Descripción",
                icon: Icon(Icons.description),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Agregar lógica para guardar la tarea en la base de datos
              },
              child: Text("Guardar"),
            ),
          ],
        ),
      ),
    );
  }
}



class AgregarMateriaForm extends StatelessWidget {
  final TextEditingController materiaNombre = TextEditingController();
  final TextEditingController idMateria = TextEditingController();
  final TextEditingController semestreMateria = TextEditingController();
  final TextEditingController docenteMateria = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Agregar Materia'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            SizedBox(height: 20,),
            TextField(
              controller: materiaNombre,
              decoration: InputDecoration(
                labelText: "Nombre de la materia",
                icon: Icon(Icons.book),
              ),
            ),
            SizedBox(height: 10,),
            TextField(
              controller: idMateria,
              decoration: InputDecoration(
                labelText: "ID de la materia",
                icon: Icon(Icons.confirmation_number),
              ),
            ),
            SizedBox(height: 10,),
            TextField(
              controller: semestreMateria,
              decoration: InputDecoration(
                labelText: "Semestre (Formato: AGO-DIC202x o ENE-JUN202x)",
                icon: Icon(Icons.date_range),
              ),
              keyboardType: TextInputType.text,
              onChanged: (value) {
                // Validar el formato del semestre aquí
                if (!RegExp(r'^(AGO-DIC|ENE-JUN)\d{4}$').hasMatch(value)) {
                  Text("ERROR");
                }
              },
            ),
            SizedBox(height: 10,),
            TextField(
              controller: docenteMateria,
              decoration: InputDecoration(
                labelText: "Nombre del docente",
                icon: Icon(Icons.person),
              ),
            ),
            SizedBox(height: 20,),
            ElevatedButton(
              onPressed: () {
               Materia m = Materia (
                   idmateria: idMateria.text,
                   nombre: materiaNombre.text,
                   semestre: semestreMateria.text,
                   docente: docenteMateria.text
               );

              DBMateria.insertar(m).then((value)  {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Se insertó")));
                idMateria.clear();
                materiaNombre.clear();
                semestreMateria.clear();
                docenteMateria.clear();
              });
              },
              child: Text("Guardar"),
            ),
          ],
        ),
      ),
    );
  }
}


