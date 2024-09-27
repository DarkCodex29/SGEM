import 'package:flutter/material.dart';
import 'package:sgem/config/theme/app_theme.dart';
import 'package:sgem/shared/widgets/custom.textfield.dart';

class TrainingPersonalPage extends StatelessWidget {
  const TrainingPersonalPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildPersonalDetails(),
            const SizedBox(height: 16),
            _buildTrainingListHeaderWithButton(context),
            const SizedBox(height: 16),
            Expanded(child: _buildTrainingList(context)),
          ],
        ),
      ),
    );
  }

  Widget _buildPersonalDetails() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        crossAxisAlignment:
            CrossAxisAlignment.start, // Mejor alineación vertical
        children: [
          const CircleAvatar(
              radius: 40,
              backgroundImage: AssetImage('assets/images/user_avatar.png')),
          const SizedBox(width: 24), // Ajustar el espaciado aquí
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Datos del Personal',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                Row(
                  children: [
                    _buildCustomTextField('Código', '2564'),
                    const SizedBox(width: 32),
                    _buildCustomTextField(
                        'Nombres y Apellidos', 'Juan Alberto Casas Mayta'),
                    const SizedBox(width: 32),
                    _buildCustomTextField('Guardia', 'A'),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCustomTextField(String label, String initialValue) {
    TextEditingController controller =
        TextEditingController(text: initialValue);
    return SizedBox(
      width: 180, // Ajuste para dar más espacio
      child: CustomTextField(
        label: label,
        controller: controller,
        isReadOnly: true,
      ),
    );
  }

  // Colocamos el botón dentro del encabezado de entrenamientos
  Widget _buildTrainingListHeaderWithButton(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Entrenamientos',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(20, 0, 0, 0),
          child: ElevatedButton.icon(
            onPressed: () async {
              await showModalBottomSheet(
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                enableDrag: false,
                context: context,
                builder: (context) {
                  return GestureDetector(
                    onTap: () => FocusScope.of(context).unfocus(),
                  );
                },
              );
            },
            icon: const Icon(
              Icons.add,
              size: 15,
              color: Colors.white,
            ),
            label: const Text('Nuevo entrenamiento',
                style: TextStyle(fontSize: 16, color: Colors.white)),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryColor,
              padding: const EdgeInsets.symmetric(horizontal: 24),
              elevation: 2,
              minimumSize: const Size(230, 50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTrainingList(BuildContext context) {
    final List<Map<String, String>> trainingData = [
      {
        'code': 'E00M',
        'equipment': 'HEX390DL',
        'status': 'Entrenando',
        'startDate': '10-05-2024',
        'endDate': '10-06-2024',
        'hours': '100/200',
        'condition': 'Experiencia',
        'noteTheory': '85',
        'notePractice': '80',
        'module': 'Módulo IV',
        'trainer': 'Juan Perez'
      },
    ];

    return ListView.builder(
      itemCount: trainingData.length,
      itemBuilder: (context, index) {
        final training = trainingData[index];
        return _buildTrainingCard(training, context);
      },
    );
  }

  Widget _buildTrainingCard(
      Map<String, String> training, BuildContext context) {
    return Card(
      color: const Color(0xFFF2F6FF), // Fondo azul claro
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment:
                  CrossAxisAlignment.start, // Ajusta la alineación vertical
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildCustomTextField(
                        'Código de entrenamiento', training['code']!),
                    _buildCustomTextField(
                        'Estado de avance actual', training['module']!),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildCustomTextField('Equipo', training['equipment']!),
                    _buildCustomTextField('Entrenador', training['trainer']!),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.radio_button_checked,
                            color: Colors.orange),
                        const SizedBox(width: 4),
                        _buildCustomTextField(
                            'Estado entrenamiento', training['status']!),
                      ],
                    ),
                    Row(
                      children: [
                        const Icon(Icons.radio_button_on, color: Colors.green),
                        const SizedBox(width: 4),
                        _buildCustomTextField(
                            'Horas de entrenamiento', training['hours']!),
                      ],
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildCustomTextField('Fecha inicio / Fin',
                        '${training['startDate']} / ${training['endDate']}'),
                    _buildCustomTextField('Nota teórica / práctica',
                        '${training['noteTheory']} / ${training['notePractice']}'),
                  ],
                ),
                _buildCustomTextField('Condición', training['condition']!),
                _buildActionButtons(context),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Row(
          children: [
            IconButton(
              icon: const Icon(Icons.edit, color: AppTheme.primaryColor),
              onPressed: () {
                // Lógica de editar
              },
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () {
                // Lógica de eliminar
              },
            ),
            IconButton(
              icon: const Icon(Icons.add_circle_outline,
                  color: AppTheme.primaryColor),
              onPressed: () {
                // Lógica de agregar más entrenamientos
              },
            ),
          ],
        ),
        Row(
          children: [
            IconButton(
              icon: const Icon(Icons.stars_sharp, color: AppTheme.primaryColor),
              onPressed: () {
                // Lógica de ver diploma
              },
            ),
            IconButton(
              icon: const Icon(Icons.file_copy_sharp,
                  color: AppTheme.primaryColor),
              onPressed: () {
                // Lógica de ver autorización
              },
            ),
          ],
        ),
      ],
    );
  }

  void _showNewTrainingModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Padding(
          padding: MediaQuery.of(context).viewInsets,
          child: const Text('Nuevo Entrenamiento Formulario'),
        );
      },
    );
  }
}
