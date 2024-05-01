import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:u3_practica2_control_tareas/controlador/materiaDB.dart';
import 'package:u3_practica2_control_tareas/modelo/materia.dart';
import 'controlador/conexion.dart';
import 'modelo/MateriaTarea.dart';

void main() {
  runApp(MaterialApp(
    home: MyApp(),
    debugShowCheckedModeBanner: false,
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
  void initState() {
    // TODO: implement initState
    super.initState();
    cargarListas();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(0, 53, 104, 1),
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
    return ListView.builder(
      itemCount: listaMateria.length,
      itemBuilder: (context, index) {
        return Card(
          elevation: 2,
          margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16), // Margen de la tarjeta
          child: ListTile(
            title: Text(
              listaMateria[index].nombre,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              listaMateria[index].docente,
              style: TextStyle(color: Colors.grey),
            ),
            leading: IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ActualizarMateriaForm(materia: listaMateria[index], cargarListas: cargarListas)),
                );
              },
              icon: Icon(Icons.update, color: Colors.deepOrange), // Color del icono
            ),
            trailing: IconButton(
              onPressed: () {
                vistaEliminar(listaMateria[index].idmateria);
              },
              icon: Icon(Icons.delete, color: Colors.red), // Color del icono
            ),
          ),
        );
      },
    );
  }

  Widget agregar() {
    return ListView(
      children: [
        SizedBox(height: 40,),
        Text("Agregar Tareas", style: TextStyle(color: Colors.deepOrange)),
        SizedBox(height: 20,),
        ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AgregarTareaForm()),
            );
          },
          child: Text("Agregar Tarea", style: TextStyle(color: Colors.deepOrange)),
        ),

        SizedBox(height: 20,),
        ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AgregarMateriaForm(cargarListas: cargarListas)),
            );
          },
          child: Text("Agregar Materia", style: TextStyle(color: Colors.deepOrange)),
        ),
        SizedBox(height: 70,),
        InkWell(
          child: Image.asset('assets/tarea.png', height: 250),
        ),
      ],
    );
  }

  Widget agenda() {
    return ListView();
  }

  void cargarListas() async {
    List<Materia> l = await DBMateria.mostrar();
    setState(() {
      listaMateria = l;
    });
  }

  void vistaEliminar(String id) async {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Seguro que deseas eliminar ID $id?"),
          actions: [
            TextButton(
              onPressed: () {
                DBMateria.eliminar(id).then((value) {
                  mensaje("Se eliminó correctamente");
                  cargarListas();
                  Navigator.pop(context);
                });
              },
              child: Text("Eliminar"),
            ),
          ],
        );
      },
    );
  }

  void mensaje(String s) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(s)));
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
  final Function cargarListas;

  AgregarMateriaForm({required this.cargarListas});

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
                icon: Icon(Icons.book, color: Colors.deepOrange),
              ),
            ),
            SizedBox(height: 10,),
            TextField(
              controller: idMateria,
              decoration: InputDecoration(
                labelText: "ID de la materia",
                icon: Icon(Icons.confirmation_number, color: Colors.deepOrange),
              ),
            ),
            SizedBox(height: 10,),
            TextField(
              controller: semestreMateria,
              decoration: InputDecoration(
                labelText: "Semestre (Formato: AGO-DIC202x o ENE-JUN202x)",
                icon: Icon(Icons.date_range, color: Colors.deepOrange),
              ),
              keyboardType: TextInputType.text,
              onChanged: (value) {

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
                icon: Icon(Icons.person, color: Colors.deepOrange),
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

                  cargarListas();
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

class ActualizarMateriaForm extends StatelessWidget {
  final Materia materia;
  final Function cargarListas;

  ActualizarMateriaForm({required this.materia, required this.cargarListas});

  TextEditingController nombreController = TextEditingController();
  TextEditingController semestreController = TextEditingController();
  TextEditingController docenteController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    nombreController.text = materia.nombre;
    semestreController.text = materia.semestre;
    docenteController.text = materia.docente;

    return Scaffold(
      appBar: AppBar(
        title: Text('Actualizar Materia'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('ID de la Materia: ${materia.idmateria}'),
            TextField(
              controller: nombreController,
              decoration: InputDecoration(
                labelText: "Nombre de la materia",
                icon: Icon(Icons.book, color: Colors.deepOrange),
              ),
            ),
            SizedBox(height: 10,),
            TextField(
              controller: semestreController,
              decoration: InputDecoration(
                labelText: "Semestre",
                icon: Icon(Icons.date_range, color: Colors.deepOrange),
              ),
            ),
            SizedBox(height: 10,),
            TextField(
              controller: docenteController,
              decoration: InputDecoration(
                labelText: "Nombre del docente",
                icon: Icon(Icons.person, color: Colors.deepOrange),
              ),
            ),
            SizedBox(height: 20,),
            ElevatedButton(
              onPressed: () {

                Materia materiaActualizada = Materia(
                  idmateria: materia.idmateria,
                  nombre: nombreController.text,
                  semestre: semestreController.text,
                  docente: docenteController.text,
                );


                DBMateria.actualizar(materiaActualizada).then((value) {

                  cargarListas();

                  Navigator.pop(context);
                });
              },
              child: Text("Guardar Cambios"),
            ),
          ],
        ),
      ),
    );
  }
}

