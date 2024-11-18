import 'package:flutter/material.dart';
import 'package:sgem/shared/widgets/alert/widget.alert.dart';

class DeleteReasonWidget extends StatelessWidget {
  final TextEditingController motivoController = TextEditingController();
  final String entityType;
  final bool isMotivoRequired;
  final VoidCallback onCancel;
  final Function(String) onConfirm;

  DeleteReasonWidget({
    super.key,
    required this.entityType,
    required this.isMotivoRequired,
    required this.onCancel,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Align(
        alignment: const AlignmentDirectional(0, 0),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Container(
            width: 714,
            height: 365,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
              boxShadow: const [
                BoxShadow(
                    blurRadius: 3,
                    color: Color(0x33000000),
                    offset: Offset(0, 1))
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  height: 80,
                  decoration: const BoxDecoration(
                    color: Color(0xFF051367),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(8),
                      topRight: Radius.circular(8),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Align(
                          alignment: const AlignmentDirectional(-1, 0),
                          child: Text(
                            'Eliminar $entityType',
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: onCancel,
                          child: const Icon(Icons.close,
                              size: 24, color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    'Ingrese el motivo de la eliminación:',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF051367),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: SizedBox(
                    height: 134,
                    child: TextField(
                      controller: motivoController,
                      maxLines: 5,
                      decoration: InputDecoration(
                        hintText: 'Motivo de eliminación',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                        onPressed: onCancel,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 24.0, vertical: 12.0),
                          backgroundColor: Colors.white,
                          side: BorderSide(color: Colors.grey.shade400),
                        ),
                        child: const Text('Cancelar',
                            style: TextStyle(color: Colors.black)),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          if (isMotivoRequired &&
                              motivoController.text.isEmpty) {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return const MensajeValidacionWidget(
                                  errores: ['Ingrese el motivo de eliminación'],
                                );
                              },
                            );
                            return;
                          }

                          onConfirm(motivoController.text.isEmpty
                              ? 'Sin motivo'
                              : motivoController.text);
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 24.0, vertical: 12.0),
                          backgroundColor: Colors.red,
                        ),
                        child: const Text('Eliminar',
                            style: TextStyle(color: Colors.white)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
