class Materia{
  String idmateria;
  String nombre;
  String semestre;
  String docente;

  Materia({
    required this.idmateria,
    required this.nombre,
    required this.semestre,
    required this.docente
  });


  Map<String, dynamic> toJSON(){
    return {
      'idmateria': idmateria,
      'nombre': nombre,
      'semestre' : semestre,
      "docente" : docente
    };
  }

}