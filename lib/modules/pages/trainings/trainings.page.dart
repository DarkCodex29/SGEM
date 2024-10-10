
import 'package:flutter/material.dart';

class TrainingsPage extends StatelessWidget {
  const TrainingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: _buildConsultaEntrenamiento(context)
    );
  }

  Widget _buildConsultaEntrenamiento(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return const SingleChildScrollView(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: [
              SizedBox(
                height: 20,
              )
            ],
          ),
        );
      },
    );
  }
}
