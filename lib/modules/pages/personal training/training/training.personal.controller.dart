
class TrainingModel {
  final String code;
  final String equipment;
  final String status;
  final String dateRange;
  final String condition;
  final int hoursCompleted;
  final int totalHours;

  TrainingModel({
    required this.code,
    required this.equipment,
    required this.status,
    required this.dateRange,
    required this.condition,
    required this.hoursCompleted,
    required this.totalHours,
  });
}

class TrainingPersonalController {
  List<TrainingModel> trainingList = [
    TrainingModel(
      code: 'E00M',
      equipment: 'HEX390DL',
      status: 'Entrenando',
      dateRange: '10-05-2024 / 10-06-2024',
      condition: 'Experiencia',
      hoursCompleted: 100,
      totalHours: 200,
    ),
    TrainingModel(
      code: 'E01M',
      equipment: 'CAT980L',
      status: 'Completado',
      dateRange: '01-04-2024 / 01-05-2024',
      condition: 'Principiante',
      hoursCompleted: 200,
      totalHours: 200,
    ),
  ];

  // Función para eliminar un entrenamiento
  void deleteTraining(int index) {
    trainingList.removeAt(index);
  }

  // Función para editar un entrenamiento (reemplazar con nueva información)
  void editTraining(int index, TrainingModel updatedTraining) {
    trainingList[index] = updatedTraining;
  }

  // Función para agregar un nuevo entrenamiento
  void addTraining(TrainingModel newTraining) {
    trainingList.add(newTraining);
  }
}
