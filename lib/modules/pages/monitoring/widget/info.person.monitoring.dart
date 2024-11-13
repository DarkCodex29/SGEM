import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:sgem/config/theme/app_theme.dart';
import 'package:sgem/modules/pages/monitoring/controllers/monitoring.controller.dart';
import 'package:sgem/shared/widgets/custom.textfield.dart';

class InfoPersonMonitoringWidegt extends StatelessWidget {
  const InfoPersonMonitoringWidegt(
      {super.key,
      required this.isSmallScreen,
      required this.createMonitoringController});
  final bool isSmallScreen;
  final CreateMonitoringController createMonitoringController;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: isSmallScreen
            ? Column(
                children: [
                  getImage(),
                  const SizedBox(width: 5),
                  const Text(
                    "Datos del Personal",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppTheme.backgroundBlue,
                        fontSize: 18),
                  ),
                  const SizedBox(width: 5),
                  CustomTextField(
                    label: "Código MCP",
                    isReadOnly: true,
                    controller: createMonitoringController.codigoMCP2Controller,
                  ),
                  const SizedBox(height: 10),
                  CustomTextField(
                    label: "Nombres y Apellidos",
                    isReadOnly: true,
                    controller: createMonitoringController.fullNameController,
                  ),
                  const SizedBox(height: 10),
                  CustomTextField(
                    label: "Guardia",
                    isReadOnly: true,
                    controller: createMonitoringController.guardController,
                  ),
                  const SizedBox(height: 10),
                  CustomTextField(
                    label: "Estado del  entrenamiento",
                    isReadOnly: true,
                    controller:
                        createMonitoringController.stateTrainingController,
                  ),
                  const SizedBox(height: 10),
                  CustomTextField(
                    label: "Módulo",
                    isReadOnly: true,
                    controller: createMonitoringController.moduleController,
                  ),
                ],
              )
            : Row(
                children: [
                  getImage(),
                  const SizedBox(width: 5),
                  Expanded(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Datos del Personal",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: AppTheme.backgroundBlue,
                                fontSize: 19),
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: CustomTextField(
                                  label: "Código MCP",
                                  isReadOnly: true,
                                  controller: createMonitoringController
                                      .codigoMCP2Controller,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: CustomTextField(
                                  label: "Nombres y Apellidos",
                                  isReadOnly: true,
                                  controller: createMonitoringController
                                      .fullNameController,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: CustomTextField(
                                  label: "Guardia",
                                  isReadOnly: true,
                                  controller: createMonitoringController
                                      .guardController,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: CustomTextField(
                                  label: "Estado del  entrenamiento",
                                  isReadOnly: true,
                                  controller: createMonitoringController
                                      .stateTrainingController,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: CustomTextField(
                                  label: "Módulo",
                                  isReadOnly: true,
                                  controller: createMonitoringController
                                      .moduleController,
                                ),
                              ),
                            ],
                          )
                        ]),
                  )
                ],
              ),
      ),
    );
  }

  Widget getImage() {
    return Obx(() {
      if (createMonitoringController.personalPhoto.value == null) {
        return const CircleAvatar(
          backgroundColor: Colors.grey,
          backgroundImage: AssetImage('assets/images/user_avatar.png'),
          radius: 40,
        );
      }
      return CircleAvatar(
        backgroundColor: Colors.grey,
        backgroundImage:
            MemoryImage(createMonitoringController.personalPhoto.value!),
        radius: 40,
      );
    });
  }
}
