import 'package:flutter/material.dart';
import 'package:sgem/shared/utils/Extensions/widgetExtensions.dart';

class EntrenamientoNuevo extends StatelessWidget {
  final VoidCallback onCancel;

  const EntrenamientoNuevo({super.key, required this.onCancel});

  @override
  Widget build(BuildContext context) {
    return Align(
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
              ]),
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
                      const Align(
                        alignment: AlignmentDirectional(-1, 0),
                        child: Text(
                          'Nuevo Entrenamiento', //$entityType
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: onCancel,
                        child: const Icon(Icons.close,
                            size: 24, color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(padding: EdgeInsets.all(16.0),
              child: Text('Nuevo'),)
            ],
          ),
        ),
      ),
    );
  }
}
