import 'package:flutter/material.dart';
import 'package:u3_practica2_control_tareas/controlador/materiaDB.dart';
import 'package:u3_practica2_control_tareas/modelo/materia.dart';
import 'package:u3_practica2_control_tareas/modelo/tarea.dart';
import 'modelo/MateriaTarea.dart';
import 'package:u3_practica2_control_tareas/controlador/tareaDB.dart';

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
  List<Tarea> listaTareas = [];
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
        centerTitle: true,
        title: Text(
          "CONTROL DE TAREAS",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: Color.fromRGBO(0, 53, 104, 1),
      ),
      body: dinamico(_indice),
      bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Colors.black,
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.update), label: "Actualizar",),
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
    return indice == 0
        ? actualizar()
        : indice == 1
            ? agenda()
            : agregar();
  }

  Widget actualizar() {
    return listaMateria.isEmpty
        ? ListView(
            padding: EdgeInsets.fromLTRB(30, 350, 30, 0),
            children: [
              Text('AQUI SE MOSTRARAN TODAS LAS MATERIAS REGISTRADAS',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                  ))
            ],
          )
        : ListView.builder(
            itemCount: listaMateria.length,
            itemBuilder: (context, index) {
              return Card(
                elevation: 2,
                margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
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
                        MaterialPageRoute(
                            builder: (context) => ActualizarMateriaForm(
                                materia: listaMateria[index],
                                cargarListas: cargarListas)),
                      );
                    },
                    icon: Icon(Icons.update, color: Colors.deepOrange),
                  ),
                  trailing: IconButton(
                    onPressed: () {
                      vistaEliminar(listaMateria[index].idmateria);
                    },
                    icon: Icon(Icons.delete, color: Colors.red),
                  ),
                ),
              );
            },
          );
  }

  Widget agregar() {
    return ListView(
      padding: EdgeInsets.all(30),
      children: [
        SizedBox(
          height: 20,
        ),
        InkWell(
          child: Image.asset('assets/tarea.png', height: 100),
        ),
        SizedBox(
          height: 40,
        ),
        Text("Agregar Tareas", style: TextStyle(color: Colors.deepOrange, fontSize: 25), textAlign: TextAlign.center,),
        SizedBox(
          height: 20,
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AgregarTareaForm()),
            );
          },
          child:
              Text("Agregar Tarea", style: TextStyle(color: Colors.deepOrange)),
        ),
        SizedBox(height: 15,),
        ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      AgregarMateriaForm(cargarListas: cargarListas)),
            );
          },
          child: Text("Agregar Materia",
              style: TextStyle(color: Colors.deepOrange)),
        ),
        SizedBox(
          height: 70,
        ),
      ],
    );
  }

  Widget agenda() {
    List<Tarea> tareasHoy = [];
    List<Tarea> tareasFuturas = [];

    DateTime now = DateTime.now();
    for (Tarea tarea in listaTareas) {
      if (tarea.f_entrega.contains(now.day.toString().padLeft(2, '0') +
          '-' +
          now.month.toString().padLeft(2, '0') +
          '-' +
          now.year.toString())) {
        tareasHoy.add(tarea);
      } else {
        tareasFuturas.add(tarea);
      }
    }
    tareasFuturas.sort((a, b) => a.f_entrega.compareTo(b.f_entrega));

    List<Tarea> todasLasTareas = [...tareasHoy, ...tareasFuturas];

    return todasLasTareas.isEmpty
        ? ListView(
            padding: EdgeInsets.fromLTRB(30, 350, 30, 0),
            children: [
              Text('AQUI SE MOSTRARAN TODAS LAS TAREAS DEL DIA REGISTRADAS',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                  ))
            ],
          )
        : ListView.builder(
            itemCount: todasLasTareas.length,
            itemBuilder: (context, index) {
              return Card(
                elevation: 2,
                margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: ListTile(
                  title: Text(
                    todasLasTareas[index].descripcion,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(todasLasTareas[index].f_entrega),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            EditarTareaForm(tarea: todasLasTareas[index]),
                      ),
                    );
                  },
                  trailing: IconButton(
                    icon: Icon(
                      Icons.check,
                      color: Colors.green,
                    ),
                    onPressed: () {
                      marcarTareaComoCompletada(todasLasTareas[index]);
                    },
                  ),
                ),
              );
            },
          );
  }

  Future<void> marcarTareaComoCompletada(Tarea tarea) async {
    int filasEliminadas = await DBTarea.eliminar(tarea.idtarea.toString());

    if (filasEliminadas > 0) {
      mensaje("Tarea completada");
    } else {
      mensaje("Erros al completar tarea");
    }
    cargarListas();
  }

  void cargarListas() async {
    List<Materia> lMaterias = await DBMateria.mostrar();
    List<Tarea> lTareas = await DBTarea.mostrar();
    setState(() {
      listaMateria = lMaterias;
      listaTareas = lTareas;
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

class AgregarTareaForm extends StatefulWidget {
  @override
  _AgregarTareaFormState createState() => _AgregarTareaFormState();
}

class _AgregarTareaFormState extends State<AgregarTareaForm> {
  final TextEditingController tareaNombre = TextEditingController();
  final TextEditingController tareaFecha = TextEditingController();
  final TextEditingController tareaDescripcion = TextEditingController();
  String materiaPK = "";
  bool isValidDate = false;
  String? selectedMateria;
  List<Materia> materias = [];
  List<Tarea> tareas = [];

  @override
  void initState() {
    super.initState();
    cargarMateriasYTareas();
  }

  void cargarMateriasYTareas() async {
    List<Materia> listaMaterias = await DBMateria.mostrar();
    List<Tarea> listaTareas = await DBTarea.mostrar();
    setState(() {
      materias = listaMaterias;
      tareas = listaTareas;
    });
  }

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
                icon: Icon(Icons.assignment, color: Colors.deepOrange),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: tareaFecha,
              decoration: InputDecoration(
                labelText: "Fecha",
                icon: Icon(Icons.calendar_today, color: Colors.deepOrange),
              ),
              onChanged: (value) {
                setState(() {
                  isValidDate = _isValidDateFormat(value);
                });
              },
            ),
            SizedBox(height: 10),
            TextField(
              controller: tareaDescripcion,
              decoration: InputDecoration(
                labelText: "Descripción",
                icon: Icon(Icons.description, color: Colors.deepOrange),
              ),
            ),
            SizedBox(height: 10),
            DropdownButtonFormField<String>(
              value: selectedMateria,
              decoration: InputDecoration(
                labelText: 'Materia',
                icon: Icon(Icons.book, color: Colors.deepOrange),
              ),
              items: materias.map((Materia materia) {
                return DropdownMenuItem<String>(
                  value: materia.nombre,
                  child: Text(materia.nombre),
                );
              }).toList(),
              onChanged: (String? value) {
                setState(() {
                  selectedMateria = value;
                });
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: isValidDate && selectedMateria != null
                  ? () {
                      int newIdTarea = DateTime.now().millisecondsSinceEpoch;

                      Tarea t = Tarea(
                          idtarea: newIdTarea,
                          idmateria: selectedMateria.toString(),
                          f_entrega: tareaFecha.text,
                          descripcion: tareaDescripcion.text);
                      DBTarea.insertar(t).then((value) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Se insertó")));
                        tareaDescripcion.clear();
                        tareaFecha.clear();
                        tareaNombre.clear();
                        cargarMateriasYTareas();
                      });
                    }
                  : null,
              child: Text("Guardar"),
            ),
          ],
        ),
      ),
    );
  }

  bool _isValidDateFormat(String input) {
    RegExp regex = RegExp(r'^\d{2}-\d{2}-\d{4}$');
    return regex.hasMatch(input);
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
            SizedBox(
              height: 20,
            ),
            TextField(
              controller: materiaNombre,
              decoration: InputDecoration(
                labelText: "Nombre de la materia",
                icon: Icon(Icons.book, color: Colors.deepOrange),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            TextField(
              controller: idMateria,
              decoration: InputDecoration(
                labelText: "ID de la materia",
                icon: Icon(Icons.confirmation_number, color: Colors.deepOrange),
              ),
            ),
            SizedBox(
              height: 10,
            ),
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
            SizedBox(
              height: 10,
            ),
            TextField(
              controller: docenteMateria,
              decoration: InputDecoration(
                labelText: "Nombre del docente",
                icon: Icon(Icons.person, color: Colors.deepOrange),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () {
                Materia m = Materia(
                    idmateria: idMateria.text,
                    nombre: materiaNombre.text,
                    semestre: semestreMateria.text,
                    docente: docenteMateria.text);

                DBMateria.insertar(m).then((value) {
                  cargarListas();
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text("Se insertó")));
                  idMateria.clear();
                  materiaNombre.clear();
                  semestreMateria.clear();
                  docenteMateria.clear();
                  cargarListas();
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
            SizedBox(
              height: 10,
            ),
            TextField(
              controller: semestreController,
              decoration: InputDecoration(
                labelText: "Semestre",
                icon: Icon(Icons.date_range, color: Colors.deepOrange),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            TextField(
              controller: docenteController,
              decoration: InputDecoration(
                labelText: "Nombre del docente",
                icon: Icon(Icons.person, color: Colors.deepOrange),
              ),
            ),
            SizedBox(
              height: 20,
            ),
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

class EditarTareaForm extends StatefulWidget {
  final Tarea tarea;

  const EditarTareaForm({Key? key, required this.tarea}) : super(key: key);

  @override
  _EditarTareaFormState createState() => _EditarTareaFormState();
}

class _EditarTareaFormState extends State<EditarTareaForm> {
  late TextEditingController _descripcionController;
  late TextEditingController _fechaController;

  @override
  void initState() {
    super.initState();
    _descripcionController =
        TextEditingController(text: widget.tarea.descripcion);
    _fechaController = TextEditingController(text: widget.tarea.f_entrega);
  }

  @override
  void dispose() {
    _descripcionController.dispose();
    _fechaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Editar Tarea'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _descripcionController,
              decoration: InputDecoration(
                labelText: 'Descripción',
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _fechaController,
              decoration: InputDecoration(
                labelText: 'Fecha de entrega',
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _guardarCambios();
              },
              child: Text('Guardar Cambios'),
            ),
          ],
        ),
      ),
    );
  }

  void _guardarCambios() {
    Tarea tareaActualizada = Tarea(
      idtarea: widget.tarea.idtarea,
      idmateria: widget.tarea.idmateria,
      descripcion: _descripcionController.text,
      f_entrega: _fechaController.text,
    );

    DBTarea.actualizar(tareaActualizada).then((value) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Tarea actualizada')),
      );
      Navigator.pop(context);
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al actualizar la tarea')),
      );
    });
  }
}
